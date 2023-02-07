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
    @Binding var selectedGroup: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                //MARK: - 일정 날짜
                Text("To Do List")
                    .font(.title3)
                    .padding(.top, 25)
                
                ScrollView(showsIndicators: true) {
                    //MARK: - 일정 디테일
                    if let filterSchedule = totalSchedule.filter({ schedule in
                        if selectedGroup != "전체" {
                            return extraData.isSameDay(date1: schedule.startTime, date2: currentDate) && (schedule.groupName == selectedGroup)
                        } else {
                            return extraData.isSameDay(date1: schedule.startTime, date2: currentDate)
                        }
                    }) {
                        if !filterSchedule.isEmpty {
                            ForEach(filterSchedule) { schedule in
                                HStack(spacing: 30) {
                                    ExDivider(color: .myRed)
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(extraData.selectedDate(date: schedule.startTime)[5]):\(extraData.selectedDate(date: schedule.startTime)[6]) \(extraData.selectedDate(date: schedule.startTime)[4])")
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
                }
            }
            .padding(.leading,30)
            .padding(.top, -8)
            Spacer()
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
