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
                    print("contentview onappear 호출")
                    guard let user = userStore.user else {
                        print("user가 nill")
                        userStore.isPresentedLoginView = true
                        return
                    }
                    if userStore.isLogined {
                        return
                    }
                    
                    print("여기로 이동")
                    userStore.isLogined.toggle()
                    
                    Task {
                        await groupStore.fetchGroups(user)
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
                    print("contentview disappear 호출")
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
