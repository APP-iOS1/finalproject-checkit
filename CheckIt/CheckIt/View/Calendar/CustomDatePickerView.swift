//
//  CustomDatePickerView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

//MARK: - 날짜 output class
class ExtraData: ObservableObject {
    let formatter = DateFormatter()
    var date: String = ""
    
    //MARK: - Date 데이터를 String으로 변환. 반환형식 예시: 2023 01 02 월요일 AM 01 22
    ///달력이 나타내는 날짜를 알려주기 위한 클래스. 현재 날짜(currentDate)변수의 데이터를 Date -> String 타입 변환,
    ///"MM DD"형식으로 반환. (예시: 01)
    func selectedDate(date: Date) -> [String] {
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy MM dd EEEE a HH mm"
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        self.date = formatter.string(from: date)
        return self.date.components(separatedBy: " ")
    }
    
    //MARK: - 날짜 비교
    ///날짜를 비교하는 함수. date1, date2를 인수로 받는다.
    ///반환 타입은 Bool
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct CustomDatePickerView: View {
    @ObservedObject var extraData = ExtraData()
    @Binding var currentDate: Date
    
    //화살표 누르면 달(month) 업데이트
    @Binding var currentMonth: Int
    
    var body: some View {
        VStack(spacing: 20) {
            //요일 array
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            HStack {
                PickerView()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top,8)
            
            //MARK: - 라벨(연도, 달, 화살표)
            HStack(spacing: 20) {
                Text("\(extraData.selectedDate(date: currentDate)[0]).\(extraData.selectedDate(date: currentDate)[1])")
                    .font(.title.bold())
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                Spacer(minLength: 0)
                
                
            }
            .padding(.horizontal)
            
            Divider()
            
            //MARK: - 요일뷰
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //MARK: - 날짜뷰
            //lazy grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background (
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.myGray)
                                .opacity(extraData.isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
        }
        .onChange(of: currentMonth) { newValue in
            //updating Month
            currentDate = getCurrentMonth()
        }
    }
    
    //MARK: - 달력 디테일뷰 생성
    ///달력 디테일뷰(day 데이터) 구성하는 함수
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                
                if let task = tasks.first(where: { task in
                    return extraData.isSameDay(date1: task.taskDate, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.body.bold())
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(task.task) {_ in
                            Circle()
                                .fill(Color.myRed)
                                .frame(width: 7, height: 7)
                        }
                    }
                } else {
                    Text("\(value.day)")
                        .font(.body.bold())
                    Spacer()
                }
            }
        }
        .padding(.vertical, 5)
        .frame(height: 50, alignment: .top)
    }
    
    //MARK: - Month GET
    ///현재 달(month) 받아오는 함수
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    
    //MARK: - 날짜 GET
    ///날짜 추출해주는 함수. DateValue 배열로 반환한다.
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            //일(day) get
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

//MARK: 현재 달(month) 날짜들을 Date 타입으로 Get
extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        return range?.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        } ?? []
    }
}

struct CustomDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
