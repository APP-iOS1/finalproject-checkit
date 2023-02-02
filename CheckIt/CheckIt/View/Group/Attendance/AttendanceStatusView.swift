//
//  AttendanceStatusView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct AttendanceStatusView: View {
    @EnvironmentObject var attendanceStore: AttendanceStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    var scheduleIDList: [String]?
    @State private var test: String = ""
    var body: some View {
        ScrollView {
            Text("\(test), ㄴㅇ")
            ForEach(scheduleStore.scheduleList.indices, id: \.self) { index in
                AttendanceStatusListCell(schedule: scheduleStore.scheduleList[index], attendance: attendanceStore.attendanceList[index])

            }

        }
        .onAppear {
//            scheduleStore.fetchSchedule()
            print(scheduleIDList, "스케줄 아이디 리스트")
//            Task {
//                await scheduleStore.fetchUserScheduleList(scheduleList: scheduleIDList ?? [])
//            }
//            attendanceStore.fetchUserAttendance(scheduleID: scheduleIDList?[2] ?? "") { value in
//                test = value
//            }
            scheduleStore.fetchUserScheduleList(scheduleList: scheduleIDList ?? [""])
        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView()
    }
}
