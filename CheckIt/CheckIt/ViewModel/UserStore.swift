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
    
    enum LoginState {
        case login
        case logout
    }
    
    /// Firebase 로그인 메서드입니다.
    func signIn(credential: AuthCredential?) {
        guard let credential = credential else { return }
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            print(authResult?.user.email)
            
        }
    }
}


//MARK: - GoogleLoginStore

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
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print("\(user?.profile?.email)")
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            completion(credential)
        }
        
        completion(nil)
    }
    
    
    //MARK: - Method(signOut)
    /// 구글 로그아웃 함수입니다.
    func signOut() {
        
    }
    
    
    
    
    
    
}


//MARK: - Test Views
struct GoogleLogin1: View {
    var body: some View {
        VStack {
            Button(action:  {
                
            }){ Text("1") }
            
        }
    }
}
