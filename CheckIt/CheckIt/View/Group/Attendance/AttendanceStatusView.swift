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
    var hostId: String
    var body: some View {
        ScrollView {
            if userStore.user?.id == hostId {
                ForEach(scheduleStore.scheduleList.indices, id: \.self) { index in
                    
                    NavigationLink(destination: AttendanceDetailView(schedule: scheduleStore.scheduleList[index])) {
                        AttendanceCellView(schedule: scheduleStore.scheduleList[index])
                            .padding(.horizontal, 30)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                    }
                }
            }
            else {
                ForEach(scheduleStore.userScheduleList.indices, id: \.self) { index in
                    AttendanceStatusListCell(schedule: scheduleStore.userScheduleList[index], attendance: attendanceStore.attendanceList[index])
                }
            }
        }
        .onAppear {
            print("호출 테스트--------------------------")
//            print(userStore.user?.id ?? "", "유저 id")
//            print(hostId, "호스트 id")
            if userStore.user?.id ?? "" == hostId {
                
            }
            else {
                scheduleStore.fetchUserScheduleList(scheduleList: scheduleStore.scheduleList, userID: userStore.user?.id ?? "", attendanceStore: attendanceStore)
            }
            print(scheduleIDList, "스케줄 아이디 리스트")
        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView( hostId: "")
    }
}
