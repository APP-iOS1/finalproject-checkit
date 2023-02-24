//
//  KakaoLoginStore.swift
//  CheckIt
//
//  Created by sole on 2023/02/04.
//
import Alamofire
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Foundation
import SwiftyJSON



//MARK: - Class(KakaoLoginStore)
class KakaoLoginStore {
    // async로 구현시 로그인 창을 띄우는 코드도 메인 스레드가 아닌 스레드에서 실행돼서 오류 발생 -> Completion Handler로 구현
//    private func requestKakao(accessToken: String) async -> String? {
//        return await withCheckedContinuation { continuation in
//            requestKakaoCompletionHandler(accessToken: accessToken) { firebaseToken in
//                continuation.resume(returning: firebaseToken)
//            }
//        }
//    }
//
//    private func getTokenWithKakaoTalk() async -> String? {
//        return await withCheckedContinuation { continuation in
//            getTokenWithKakaoTalkCompletionHanlder { accessToken in
//                continuation.resume(returning: accessToken)
//            }
//        }
//    }
//
//
    
    func returnFirebaseToken() async -> String? {
        return await withCheckedContinuation { continuation in
            returnFirebaseToken { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func returnFirebaseToken(completion: @escaping (String?) -> ()) {
        getTokenWithKakaoTalkCompletionHanlder { accessToken in
            guard let accessToken else { completion(nil); return }
            self.requestKakaoCompletionHandler(accessToken: accessToken) { result in
                guard let result else { completion(nil); return }
                completion(result)
                return
            }
        }
    }
    
    
    private func getTokenWithKakaoTalkCompletionHanlder(completion: @escaping (String?) -> ()) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                if let error {
                    if let sdkError = error as? SdkError,
                       sdkError.isInvalidTokenError() == true {
                        // 카카오톡 설치되어 있으면
                        if UserApi.isKakaoTalkLoginAvailable() {
                            UserApi.shared.loginWithKakaoTalk() { oauthToken, error in
                                if let error {
                                    completion(nil)
                                    return
                                }
                                guard let oauthToken else {
                                    completion(nil)
                                    return
                                }
                                print("accessToken: \(oauthToken.accessToken)")
                                
                                completion(oauthToken.accessToken)
                                
                            }
                        }
                        
                        // 카카오톡 설치가 안 되어 있는 경우
                        else {
                            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                if let error {
                                    print("\(error.localizedDescription)")
                                    return
                                }
                                guard let oauthToken else { return }
                                completion(oauthToken.accessToken)
                            } // - loginWithKakaoAccount
                            
                        } // - else
                    } // - isInvalidTokenError
                    else { print("\(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                } // - if let error
                // 카카오톡 설치되어 있으면
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk() { oauthToken, error in
                        if let error {
                            completion(nil)
                            return
                        }
                        guard let oauthToken else {
                            completion(nil)
                            return
                        }
                        print("accessToken: \(oauthToken.accessToken)")
                        
                        completion(oauthToken.accessToken)
                        
                    }
                }
                
                // 카카오톡 설치가 안 되어 있는 경우
                else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if let error {
                            print("\(error.localizedDescription)")
                            return
                        }
                        guard let oauthToken else { return }
                        completion(oauthToken.accessToken)
                    } // - loginWithKakaoAccount
                    
                } // - else
            }
        } else {
            // 카카오톡 설치되어 있으면
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk() { oauthToken, error in
                    if let error {
                        completion(nil)
                        return
                    }
                    guard let oauthToken else {
                        completion(nil)
                        return
                    }
                    print("accessToken: \(oauthToken.accessToken)")
                    
                    completion(oauthToken.accessToken)
                    
                }
            }
            
            // 카카오톡 설치가 안 되어 있는 경우
            else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error {
                        print("\(error.localizedDescription)")
                        return
                    }
                    guard let oauthToken else { return }
                    completion(oauthToken.accessToken)
                } // - loginWithKakaoAccount
            }
        }
    }
    
    
    private func requestKakaoCompletionHandler(accessToken: String, completion: @escaping (String?) -> ()) {
        let url = URL(string: "\(Bundle.main.object(forInfoDictionaryKey: "KAKAO_AUTHENTICATION_SERVER_URL") as? String ?? "")")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        let params = ["token": accessToken]
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error")
            return
        }
        
        AF.request(request).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let data):
                guard let object = JSON(data).dictionary as? [String: Any] else {
                    print("토큰 발행 실패")
                    completion(nil)
                    return
                }
//                print(String(describing: object["firebase_token"]))
                let firebaseToken = String(describing: object["firebase_token"] ?? "")
                completion(firebaseToken)
                
            case .failure(let error):
                print("error : \(response.response?.statusCode)")
                completion(nil)
            }
        }
    }
    
    func signOut() {
        UserApi.shared.logout { error in
            return
        }
    }
}
