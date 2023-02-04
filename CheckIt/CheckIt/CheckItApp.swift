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
    @State var isLogin: Bool = true
    
    init() {
            // Kakao SDK 초기화
            KakaoSDK.initSDK(appKey: "7a4ee9f84ebf3bcf24029e1c6febb14d")
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .fullScreenCover(isPresented: self.$userStore.isPresentedLoginView) {
                        LoginView()
                    }
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
                    .onAppear{
                        if let user = Auth.auth().currentUser {
                            userStore.isPresentedLoginView = false
                            userStore.userData = user
                            Task {
                                await userStore.fetchUser(user.uid)   
                            }
                        }
                    }
                    

            }
        }
    }
}
