//
//  ContentView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CheckMainView()
                .tabItem {
                    Image(systemName: "checkmark.square.fill")
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

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
