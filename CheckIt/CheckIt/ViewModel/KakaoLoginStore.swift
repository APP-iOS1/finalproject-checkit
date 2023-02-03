//
//  KakaoLoginStore.swift
//  CheckIt
//
//  Created by sole on 2023/02/04.
//

import Foundation

//MARK: - Class(KakaoLoginStore)
class KakaoLoginStore {

//     func signInCompletionHandler() {
//          // 카카오톡 실행 가능 여부 확인
//          if (UserApi.isKakaoTalkLoginAvailable()) {
//               UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                    if let error = error {
//                         print("\(error.localizedDescription)")
//                         return
//                    }
//                    print("loginWithKakaoTalk() success.")
//
//                    //do something
//                    _ = oauthToken
//                    print("\(oauthToken)")
//
//
//
//               }
//          } else {
//               //TODO: 카카오톡 설치 후 시도하라는 알럿 필요
//               print("카카오톡 실행 불가")
//          }
//
//
//     }
//
//     func signIn() {
//          // 이미 로그인 된 경우
//          if (AuthApi.hasToken()) {
//               UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
//                    if let error = error {
//                         if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
//                              //로그인 필요
//                              print("로그인이 필요합니다")
//                              print("\(error.localizedDescription)")
//                              if (UserApi.isKakaoTalkLoginAvailable()) {
//                                   UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                                        if let error = error {
//                                             print("\(error.localizedDescription)")
//                                             return
//                                        }
//                                        print("loginWithKakaoTalk() success.")
//
//                                        //do something
//                                        _ = oauthToken
//                                        print(oauthToken?.accessToken)
//
//                                   }
//                              } else {
//                                   //TODO: 카카오톡 설치 후 시도하라는 알럿 필요
//                                   print("카카오톡 실행 불가")
//                              }
//                              return
//
//                         }
//                         else {
//                              //기타 에러
//                              print("\(error.localizedDescription)")
//
//                         }
//                    }
//                    else {
//                         //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
//                         print(accessTokenInfo?.expiresIn)
//                    }
//               }
//               return
//          }
//          //FIXME: 불가능하면 알럿 띄워줘야 함.
//          // 카카오톡 실행 가능 여부 확인
//          else if (UserApi.isKakaoTalkLoginAvailable()) {
//               UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                    if let error = error {
//                         print("\(error.localizedDescription)")
//                         return
//                    }
//                    print("loginWithKakaoTalk() success.")
//
//                    //do something
//                    _ = oauthToken
//                    print(oauthToken?.accessToken)
//
//               }
//          } else {
//               //TODO: 카카오톡 설치 후 시도하라는 알럿 필요
//               print("카카오톡 실행 불가")
//          }
//
//     }
//     func signOut() {
//          UserApi.shared.logout { error in
//               return
//          }
//     }
}
