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
    
    @Binding var isGroupManager: Bool
    var scheduleIDList: [String]?
    var hostId: String
    
    var body: some View {
        VStack {
                if isGroupManager {
                    
                    if scheduleStore.scheduleList.count == 0 {
                        Spacer()
                        HStack{}
                            .frame(height: 25)
                        AttendanceEmptyView()
                        Spacer()
                    } else {
                        ScrollView {
                            ForEach(scheduleStore.scheduleList.indices, id: \.self) { index in
                                
                                NavigationLink(destination: AttendanceDetailView(schedule: scheduleStore.scheduleList[index])) {
                                    AttendanceCellView(schedule: scheduleStore.scheduleList[index])
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
                else {
                    
                    if scheduleStore.userScheduleList.count == 0 {
                        Spacer()
                        HStack{}
                            .frame(height: 25)
                        AttendanceEmptyView()
                        Spacer()
                    } else {
                        ScrollView {
                            ForEach(scheduleStore.userScheduleList.indices, id: \.self) { index in
                                AttendanceStatusListCell(schedule: scheduleStore.userScheduleList[index], attendance: attendanceStore.attendanceList[index])
                            }
                        }
                    }
                }
        }
        .onAppear {
            print("호출 테스트--------------------------")
            //            print(userStore.user?.id ?? "", "유저 id")
            //            print(hostId, "호스트 id")
            if isGroupManager {
                
            }
            else {
                scheduleStore.fetchUserScheduleList(scheduleList: scheduleStore.scheduleList, userID: userStore.user?.id ?? "", attendanceStore: attendanceStore)
            }
        }
        .onDisappear {
            scheduleStore.userScheduleList = []
        }
    }
}

//struct AttendanceStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendanceStatusView( hostId: "")
//    }
//}
