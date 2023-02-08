//
//  CalendarView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    @State var currentDate: Date = Date()
    @State var currentMonth: Int = 0
    @State private var selectedGroup = "전체"
    @State private var totalSchedule: [Schedule] = []
    
    var body: some View {
        VStack {
            CustomDatePickerView(currentDate: $currentDate, selectedGroup: $selectedGroup, totalSchedule: $totalSchedule, currentMonth: $currentMonth)
                .padding(.horizontal)
            
            Divider()
            
            //일정섹션
            TaskView(currentDate: $currentDate, totalSchedule: $totalSchedule, selectedGroup: $selectedGroup)
//                .padding(.top, -8)
            Spacer()
        }
        .padding(.vertical)
        .onAppear {
                groupStore.groups.forEach { group in
                    Task {
                        await scheduleStore.fetchCalendarSchedule(groupName: group.name)
                        print("foreach group name: \(group.name)")
                        print("totalGroup schedule: \(scheduleStore.scheduleList)")
                        totalSchedule = scheduleStore.scheduleList
                    }
                }
        }
    }

}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
