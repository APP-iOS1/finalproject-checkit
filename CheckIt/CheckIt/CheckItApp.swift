//
//  CheckItApp.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct CheckItApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userStore = UserStore()
    @StateObject private var groupStore = GroupStore()
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var attendanceStore = AttendanceStore()
    @StateObject private var memberStore = MemberStore()
    @State var isLogin: Bool = true
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .fullScreenCover(isPresented: self.$userStore.isPresentedLoginView) {
                        LoginView()
                    }
//                ContentView()
                    .environmentObject(userStore)
                    .environmentObject(groupStore)
                    .environmentObject(scheduleStore)
                    .environmentObject(attendanceStore)
                    .environmentObject(memberStore)
                    

            }
        }
    }
}
