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
    var body: some View {
        //NavigationStack {
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
                
                MyPageView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("마이")
                    }
            }
            .accentColor(Color.myGreen)
            .onAppear {
                guard let user = userStore.user else { return }
                if userStore.isFirstLogin {
                    return
                }
                
                userStore.isLogined.toggle()
                
                Task {
                    await groupStore.fetchGroups(user)
                }
                userStore.startUserListener(user.id)
            }
            .onDisappear {
                groupStore.detachListener()
            }
        //}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
