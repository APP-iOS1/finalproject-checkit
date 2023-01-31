//
//  CheckItApp.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct CheckItApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var groupStore = GroupStore()
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var attendanceStore = AttendanceStore()
    @StateObject private var memberStore = MemberStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(groupStore)
                    .environmentObject(scheduleStore)
                    .environmentObject(attendanceStore)
                    .environmentObject(memberStore)
            }
        }
    }
}
