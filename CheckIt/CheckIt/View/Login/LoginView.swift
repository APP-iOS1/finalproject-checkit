//
//  LoginView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import KakaoSDKUser
import AlertToast

struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @State var isProcessing: Bool = false
    var body: some View {
        VStack {
            Spacer()
            
            Image("checkItLogoRemove")
                .resizable()
                .scaledToFit()
            
            
            SignInWithAppleButton(onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }) { result in
                isProcessing = true
                userStore.loginCenter = .apple
                Task {
                    await userStore.loginWithCredential(result)
                    isProcessing = false
                }
            }
            .frame(width: 280, height: 50)
            
            
            // 카카오 로그인
            kakaoLoginButton
            
            // 구글 로그인
            googleLoginButton
            
            Spacer()
        } // - VStack
        .toast(isPresenting: $isProcessing) {
            AlertToast(displayMode: .alert, type: .loading)
        }
    }
    
    
    
    //MARK: - (Button)kakaoLoginButton
    private var kakaoLoginButton: some View {
        Button(action: {
            userStore.loginCenter = .kakao
            isProcessing = true
            userStore.loginWithKakao()
        }, label: {
            HStack {
                Image(systemName: "message.fill")
                
                Text(" 카카오로 로그인")
            }
            .frame(width: 280, height: 50)
            .background(Color("kakao"))
            .cornerRadius(12)
        })
        .foregroundColor(.black)
    } // - kakaoLoginButton
    
    //MARK: - (Button)googleLoginButton
    // google login button custom
    private var googleLoginButton: some View {
        Button(action: {
            userStore.loginCenter = .google
            isProcessing = true
            Task {
                await userStore.loginWithCredential()
                isProcessing = false
            }
        })
        {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.myGray)
                .frame(width: 280, height: 50)
                .overlay{
                    HStack {
                        Spacer()
                        Image("google_logo")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        //FIXME: Robot 글꼴 적용해야함
                        Text("Sign in with Google")
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            
        }
    } // - googleLoginButton
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(userStore: UserStore())
//            .environmentObject(UserStore())
//    }
//}
