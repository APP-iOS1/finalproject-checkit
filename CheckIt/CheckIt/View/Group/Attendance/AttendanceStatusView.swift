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
    @EnvironmentObject var userStore: UserStore
    var scheduleIDList: [String]?
    @State private var test: String = ""
    var body: some View {
        ScrollView {
            ForEach(scheduleStore.userScheduleList.indices, id: \.self) { index in
                AttendanceStatusListCell(schedule: scheduleStore.userScheduleList[index], attendance: attendanceStore.attendanceList[index])

            }

        }
        .onAppear {
            print(scheduleIDList, "스케줄 아이디 리스트")
                scheduleStore.fetchUserScheduleList(scheduleList: scheduleStore.scheduleList, userID: userStore.user?.id ?? "", attendanceStore: attendanceStore)

        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView()
    }
}
