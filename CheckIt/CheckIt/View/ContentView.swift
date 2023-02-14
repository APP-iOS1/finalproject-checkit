//
//  ContentView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    @State private var totalSchedule: [Schedule] = []
    
    @AppStorage("onboarding") var isOnboarindViewActive: Bool = true
    
    var body: some View {
        
        ZStack {
            if isOnboarindViewActive {
                OnBoardingView()
            } else {
                TabView {
                    
                    CheckMainView()
                        .tabItem {
                            Image(systemName: "checkmark.seal.fill")
                            Text("출석체크")
                        }
                    GroupMainView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("동아리")
                        }
                    
                    CalendarView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("캘린더")
                        }
                }
                .accentColor(Color.myGreen)
                .onAppear {
//                    UITabBar.appearance().backgroundColor = .lightGray
                    
                    guard let user = userStore.user else { return }
                    if userStore.isLogined {
                        return
                    }
                    //UITabBar.appearance().backgroundColor = .black
                    
                    userStore.isLogined.toggle()
                    
                    Task {
                        await groupStore.fetchGroups(user)
                        print("groups: \(groupStore.groups)")
                        for group in groupStore.groups {
                            await scheduleStore.fetchRecentSchedule(groupName: group.name)
                            await scheduleStore.fetchSchedule(groupName: group.name)
                        }
                        for schedule in scheduleStore.calendarSchedule {
                            await attendanceStore.checkUserAttendance(scheduleID: schedule.id, id: user.id)
                        }
                    }
                    userStore.startUserListener(user.id)
                }
                .onDisappear {
                    groupStore.detachListener()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
