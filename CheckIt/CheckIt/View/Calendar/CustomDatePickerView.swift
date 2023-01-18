//
//  CustomDatePickerView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct CustomDatePickerView: View {
   
    @Binding var currentDate: Date
    
    //화살표 누르면 달(month) 업데이트
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack(spacing: 35) {
            //요일 array
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            HStack(spacing: 20) {
                
                Text("\(extraData()[0]).\(extraData()[1])")
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
            
            //요일뷰
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //날짜뷰
            //lazy grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                }
            }
        }
        .onChange(of: currentMonth) { newValue in
            //updating Month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3.bold())
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    
    func extraData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    ///현재 달(month) 받아오는 함수
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        //현재 날짜(dates) get
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    ///날짜 추출해주는 함수. 배열로 반환한다.
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        //현재 날짜(dates) get
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
    
    ///현재 달(month)에 관한 데이터를 Date 배열 타입으로 반환해주는 함수
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        //시작 날짜 get
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        //날짜 Get
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
