//
//  CheckItApp.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth

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
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
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
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "7a4ee9f84ebf3bcf24029e1c6febb14d")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginRouteView()
                    .onOpenURL(perform: { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            AuthController.handleOpenUrl(url: url)
                        }
                    })
                    .environmentObject(userStore)
                    .environmentObject(groupStore)
                    .environmentObject(scheduleStore)
                    .environmentObject(attendanceStore)
                    .environmentObject(memberStore)
                    .onAppear {
                        Task {
                            guard let user = Auth.auth().currentUser else { return }
                            if userStore.isLogined {
                                return
                            }
                            
                            userStore.isLogined.toggle()
                            userStore.isPresentedLoginView = false
                            userStore.userData = user
                            await userStore.fetchUser(user.uid)
                            //groupStore.startGroupListener(userStore)
                            await groupStore.fetchGroups(userStore.user!)
                            userStore.startUserListener(user.uid)
                            print("groups: \(groupStore.groups)")
                            for group in groupStore.groups {
                                await scheduleStore.fetchRecentSchedule(groupName: group.name)
                            }
                        }
                    }
            }
        }
    }
}

