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
                        .foregroundColor(Color.myGreen)
                    
                    Text("출석체크")
                }
            GroupMainView()
                .tabItem {
                    Image(systemName: "house.fill")
                        .foregroundColor(Color.myGreen)
                    
                    Text("동아리")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.myGreen)
                    
                    Text("캘린더")
                }
            MyPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color.myGreen)
                    
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
