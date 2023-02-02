//
//  UserStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import UIKit
import GoogleSignIn
import FirebaseAuth

class UserStore: ObservableObject {
    let database = Firestore.firestore()
    
    @Published var loginState: LoginState = .logout
    @Published var loginCenter: LoginCenter? = nil
    @Published var isPresentedLoginView: Bool = true
    
    // 사용자 이름 수정 가능하도록
    @Published var userName: String = ""
    
    var userData: FirebaseAuth.User? = nil
    
    enum LoginState {
        case login
        case logout
    }
    
    enum LoginCenter {
        case apple
        case kakao
        case google
    }
    
    //MARK: - Method(isUserInDatabaseCompletionHandler)
    /// 유저가 파이어베이스 스토어에 등록됐는지 확인하는 과정을 컴플리션 핸들러로 구현한 메서드입니다.
    func isUserInDatabaseCompletionHandler(uid: String, completion: @escaping (Bool) -> ()) {
        database.collection("User").whereField("uid", isEqualTo: "\(uid)")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if snapshot == nil || snapshot?.documents == [] {
                    completion(false)
                    return
                }
                
                completion(true)
                
            }
    } // - isUserInDatabaseCompletionHandler
    
    
    //MARK: - isUserInDatabase
    /// 유저가 파이어베이스 스토어에 등록됐는지 확인하는 과정을 Async로 구현한 메서드입니다 .
    func isUserInDatabase(uid: String) async -> Bool {
        return await withCheckedContinuation { continuation in
                isUserInDatabaseCompletionHandler(uid: uid) { result in
                    continuation.resume(returning: result)
                }
            }
    } // - isUserInDatabase
    
    func toggleLoginState() {
        switch loginState {
        case .login:
            self.loginState = .logout
            DispatchQueue.main.async {
                self.isPresentedLoginView = true
            }
        case .logout:
            self.loginState = .login
            DispatchQueue.main.async {
                self.isPresentedLoginView = false
            }
        }
    }
    
    //MARK: - Method(signIn)
    /// Firebase 로그인 메서드입니다. credential을 제3자(애플, 카카오, 구글)로부터  파라미터로 제공받아 파이어베이스 로그인에 연결합니다.
    func signInCompletionHandler(credential: AuthCredential?, completion: @escaping (FirebaseAuth.User?) -> ()) {
        var isUser: Bool = false
        guard let credential = credential else { return }
        Auth.auth().signIn(with: credential) { [self] authResult, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            self.userData = authResult?.user
            
            Task {
                isUser = await self.isUserInDatabase(uid: userData?.uid ?? "N/A")
                print("isUserParameter: \(userData?.uid)")
                print("isUser",isUser)
            }
            print(authResult?.user.email, "Firebase Login")
            
            if !isUser {
                addUser(userData: authResult?.user)
            }
            
            self.toggleLoginState()
            completion(authResult?.user)
        }
    } // - signIn
    
    func signIn(credential: AuthCredential?) async -> FirebaseAuth.User? {
        return await withCheckedContinuation { continuation in
                signInCompletionHandler(credential: credential) { result in
                    continuation.resume(returning: result)
                }
            }
    }
    
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
            self.toggleLoginState()
            self.userData = nil
            
            // 제3자 로그아웃
            switch loginCenter {
            case .apple:
                break
            case .kakao:
                break
            case .google:
                GIDSignIn.sharedInstance.signOut()
                break
            case .none:
                print("Error! 로그인 센터가 없습니다.")
                break
            }
            
            print("Firebase Logout")
        } catch {
            print("\(error.localizedDescription)")
        }
    } // - signOut
    
    
    func addUser(userData: FirebaseAuth.User?) {
        guard let user = userData else { return }
        database.collection("User")
            .document("\(user.uid)")
            .setData([
                "uid" : user.uid ?? "N/A",
                "name" : user.displayName,
                "email" : user.email ?? "N/A",
                "group_id" : [],
            ])
        
    }
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
    
    
    
    func restorePreviousSignIn() {
        
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
                    user.loginCenter = .google
                    await user.signIn(credential: credential)
                }
            }){ Text("로그인") }
            Button(action: {
                user.signOut()
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


