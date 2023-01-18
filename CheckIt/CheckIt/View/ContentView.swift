//
//  ContentView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("출석체크")
                .tabItem {
                    Image(systemName: "checkmark.square.fill")
                    Text("출석체크")
                }
            Text("동아리")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("동아리")
                }
            Text("캘린더")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("캘린더")
                }
            Text("마이")
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
