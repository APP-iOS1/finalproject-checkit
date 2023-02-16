//
//  ScheduleView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var extraData = ExtraData()
    
    @Binding var currentDate: Date
    @Binding var totalSchedule: [Schedule]
    @Binding var totalAttendance: [Attendance]
    @Binding var selectedGroup: String
    
    var body: some View {
        HStack {
            if let filterSchedules = totalSchedule.filter({ schedule in
                if selectedGroup != "전체" {
                    return extraData.isSameDay(date1: schedule.startTime, date2: currentDate) && (schedule.groupName == selectedGroup)
                } else {
                    return extraData.isSameDay(date1: schedule.startTime, date2: currentDate)
                }
            }) {
                if !filterSchedules.isEmpty {
                    VStack(alignment: .leading, spacing: 9) {
                        //MARK: - 일정 날짜
                            Text("예정된 일정")
                                .font(.title3)
                                .padding(.top, 25)
                                .bold()
                        ScrollView(showsIndicators: true) {
                            // MARK: - selectedGroup에 맞춰 필터된 스케줄을 시간순으로 정렬(과거순)
                            let sortedSchedules = filterSchedules.sorted {
                                $0.startTime < $1.startTime
                            }
                            //MARK: - 일정 디테일
                            ForEach(sortedSchedules) { schedule in
                                HStack(spacing: 20) {
                                    switch Date().dateCompare(fromDate: schedule.startTime) {
                                    case "Future":
                                        ExDivider(color: .myGray)
                                    default:
                                        if let filterAttendance = totalAttendance.first(where: { attendance in
                                            return attendance.scheduleId == schedule.id
                                        }) {
                                            switch filterAttendance.attendanceStatus {
                                            case "출석":
                                                ExDivider(color: .myGreen)
                                            case "지각":
                                                ExDivider(color: .myOrange)
                                            case "공결":
                                                ExDivider(color: .myBlack)
                                            default:
                                                ExDivider(color: .myRed)
                                            }
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(extraData.selectedDate(date: schedule.startTime)[4]) \(extraData.selectedDate(date: schedule.startTime)[5]):\(extraData.selectedDate(date: schedule.startTime)[6])")
                                            .font(.body)
                                        Text(schedule.groupName)
                                            .font(.body.bold())
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                .padding(.top, 17)
                            }
                        }
                    }
                    .padding(.leading,30)
                    .padding(.top, -8)
                    Spacer()
                } else {
                    VStack {
                        Spacer()
                        
                        Text("일정 없음")
                            .foregroundColor(Color.myGray)
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                }
            }
            
        }
    }
}

//MARK: - 일정 구분선
///달력 뷰에서 일정별로 구분해주는 선을 그려주는 구조체입니다. Color를 인자로 받습니다.
///해당 색은 구분선의 색으로 사용됩니다.
struct ExDivider: View {
    let color: Color
    let width: CGFloat = 5
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .frame(width: width, height: 45)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
