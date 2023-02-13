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
        formatter.dateFormat = "yyyy MM dd EEE a HH mm"
        
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        self.date = formatter.string(from: date)
        return self.date.components(separatedBy: " ")
    }
    
    //MARK: - 날짜 비교
    ///날짜가 같은지 비교하는 함수. date1, date2를 인수로 받는다.
    ///반환 타입은 Bool
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct CustomDatePickerView: View {
    @ObservedObject var extraData = ExtraData()
    @Binding var currentDate: Date
    //피커에서 선택된 그룹
    @Binding var selectedGroup: String
    @Binding var totalSchedule: [Schedule]
    @Binding var totalAttendance: [Attendance]
    
    //화살표 누르면 달(month) 업데이트
    @Binding var currentMonth: Int
    
    var body: some View {
        VStack(spacing:  UIScreen.main.bounds.height * 0.02) {
            //요일 array
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            HStack {
                
                VStack(alignment: .leading, spacing: 0) {
                    PickerView(selectedGroup: $selectedGroup)
//                        .padding(.top)
//                        .padding(.top, UIScreen.main.bounds.height * 0.01)
                    Text("\(extraData.selectedDate(date: currentDate)[1]).\(extraData.selectedDate(date: currentDate)[2]) \(extraData.selectedDate(date: currentDate)[3])")
                        .font(.largeTitle)
//                        .font(.system(size: 40))
                        .fontWeight(.bold)
//                        .padding(.bottom)
//                        .padding(.top, -(UIScreen.main.bounds.height * 0.01))
                }
                .padding(.leading, 20)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.125, alignment: .leading)
            .background(Color.myGreen)
            .padding(.top, -25)
            
            //MARK: - 라벨(연도, 달, 화살표)
            HStack() {
                Button {
                        currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                Spacer()
                
                Text("\(extraData.selectedDate(date: currentDate)[0]).\(extraData.selectedDate(date: currentDate)[1])")
                    .font(.title3)
                Spacer()
                
                Button {
                        currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
            }
            .padding(.horizontal)
            
//            Divider()
            
            //MARK: - 요일뷰
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 0)
            
            //MARK: - 날짜뷰
            //lazy grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background (
                            Rectangle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.myGray)
                                .opacity((value.day != -1) && extraData.isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
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
                if let filterSchedules = totalSchedule.filter({ schedule in
                if selectedGroup != "전체" {
                    return extraData.isSameDay(date1: schedule.startTime, date2: value.date) && (schedule.groupName == selectedGroup)
                } else {
                    return extraData.isSameDay(date1: schedule.startTime, date2: value.date)
                }
            }) {
                Text("\(value.day)")
                    .font(.body)
                Spacer()
                
                HStack(spacing: 6) {
                    //FIXME: 3+ 라벨 처리
                    if !filterSchedules.isEmpty {
                        // MARK: - selectedGroup에 맞춰 필터된 스케줄을 시간순으로 정렬(과거순)
                        let sortedSchedules = filterSchedules.sorted {
                            $0.startTime < $1.startTime
                        }
                        let scheduleNum = sortedSchedules.count
                       
                        if scheduleNum > 3 {
                            Text("3+")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(Color.myRed)
                                .frame(width: 28, height: 16)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.myRed, lineWidth: 1))
                                .padding(.top, -5)
                            
                        } else {
                            ForEach(sortedSchedules) { schedule in
                                // MARK: - 지금을 기준으로 지난 일정과 예정 일정을 구분
                                switch Date().dateCompare(fromDate: schedule.startTime) {
                                case "Future":
                                    Circle()
                                        .fill(Color.myGray)
                                        .frame(width: 7, height: 7)
                                default:
                                    // MARK: - 일정에 맞는 출석상태를 필터링
                                    if let filterAttendance = totalAttendance.first(where: { attendance in
                                        return attendance.scheduleId == schedule.id
                                    }) {
                                        switch filterAttendance.attendanceStatus {
                                        case "출석":
                                            Circle()
                                                .fill(Color.myGreen)
                                                .frame(width: 7, height: 7)
                                        case "지각":
                                            Circle()
                                                .fill(Color.myOrange)
                                                .frame(width: 7, height: 7)
                                        case "공결":
                                            Circle()
                                                .fill(Color.myBlack)
                                                .frame(width: 7, height: 7)
                                        default:
                                            Circle()
                                                .fill(Color.myRed)
                                                .frame(width: 7, height: 7)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 15)
            } else {
                Text("\(value.day)")
                    .font(.body.bold())
                Spacer()
            }
            }
        }
        .padding(.vertical, 3)
        .frame(height: 45, alignment: .top) // 50
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

struct CustomDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
