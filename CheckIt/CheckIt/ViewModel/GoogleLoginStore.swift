//
//  GoogleStore.swift
//  CheckIt
//
//  Created by sole on 2023/02/03.
//

import Firebase
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth

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
    
    func restorePreviousLogin() async -> AuthCredential? {
        return await withCheckedContinuation { continuation in
            restorePreviousLoginCompletionHandler { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func restorePreviousLoginCompletionHandler(completion: @escaping (AuthCredential?) -> ()) {
        //FIXME: 로그인 한 내역이 있는 경우
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
    }
    
    //MARK: - Method(signIn)
    /// 구글 로그인을 Completion Handler로 구현한 메서드입니다.
    func signInCompletionHandler(completion: @escaping (AuthCredential?) -> (Void)) {
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
