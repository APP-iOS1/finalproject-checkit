//
//  UserStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Firebase
import SwiftUI
import UIKit
import GoogleSignIn
import FirebaseAuth

class UserStore: ObservableObject {
    @Published var loginState: LoginState = .logout
    var userData: FirebaseAuth.User? = nil
    
    enum LoginState {
        case login
        case logout
    }

    
    //MARK: - Method(signIn)
    /// Firebase 로그인 메서드입니다.
    func signIn(credential: AuthCredential?) {
        guard let credential = credential else { return }
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            self.userData = authResult?.user
            print(authResult?.user.email, "Firebase Login")
            self.loginState = .login
            
        }
    } // - signIn
    
    //MARK: - Method(fetchUserData)
    /// 유저 데이터를 반환하는 메서드입니다.
    func fetchUserData() -> FirebaseAuth.User? {
        if loginState == .logout {
            print("로그인 진행 필요")
            return nil
        }
        return self.userData
    } // - fetchUserData
    
    
    //MARK: - Method(signOut)
    /// Firebase 로그아웃 메서드입니다.
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.loginState = .logout
            self.userData = nil
            print("Firebase Logout")
        } catch {
            print("\(error.localizedDescription)")
        }
    } // - signOut
}


//MARK: - GoogleLoginStore
/// 구글 로그인 관련 로직
class GoogleLoginStore {
    
    //MARK: - Method(signIn Async)
    /// 구글 로그인 함수입니다.
    func signIn() async -> AuthCredential? {
        return await withCheckedContinuation { continuation in
            signInCompletionHandler { result in
                continuation.resume(returning: result)
            }
        }
        
    }
    
    
    //MARK: - Method(signIn)
    func signInCompletionHandler(completion: @escaping (AuthCredential?) -> (Void)) {
        
        //FIXME: 로그인 한 내역이 있는 경우
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    completion(nil)
                    return
                }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: authentication.accessToken)
                completion(credential)
                print("로그인 내역이 있습니다")
                
            }
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
            GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion(nil)
                    return
                }
                print("\(user?.profile?.email)")
                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    completion(nil)
                    return
                }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: authentication.accessToken)
                
                completion(credential)
            }
        }
    } // - signInCompletionHandler
    
    
    //MARK: - Method(signOut)
    /// 구글 로그아웃 함수입니다.
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    } // - signOut
}


//MARK: - Test Views
struct GoogleLogin1: View {
    @StateObject var user = UserStore()
    var body: some View {
        VStack {
            Button(action:  {
                Task {
                    guard let credential = await GoogleLoginStore().signIn() else { return }
                    user.signIn(credential: credential)
                }
            }){ Text("로그인") }
            Button(action: {
                user.signOut()
                GIDSignIn.sharedInstance.signOut()
            }) {
                Text("로그아웃")
            }
            Button(action: {
                print("\(GIDSignIn.sharedInstance.currentUser)")
                guard let userData = user.fetchUserData() else { print("로그아웃"); return }
                print(userData.uid, "유저 데이터 불러오기")

            }) {
                Text("유저 데이터 불러오기")
            }
            
        }
    }
}
