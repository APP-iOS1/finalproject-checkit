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

struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    var kakaoLoginButton: some View {
        Button(action: {
            userStore.loginCenter = .kakao
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
    }
    
    var naverLoginButton: some View {
        Button(action: {
            
        }, label: {
            HStack {
                Image("naver")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40 ,height: 50)
                
                Text("네이버로 로그인")
            }
            .foregroundColor(.white)
            .frame(width: 280, height: 50)
            .background(Color("naver"))
            .cornerRadius(12)
        })
    }
    
    // google login button custom
    var googleLoginButton: some View {
        Button(action: {
            userStore.loginCenter = .google
            Task {
                await userStore.loginWithCredential()
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
                        Spacer()
                    }
                }
            
        }
    } // - googleLoginButton
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("CheckItLogo")
                .resizable()
                .scaledToFit()
            
            //FIXME: - 수정 예정
            Text("동아리 관리는 Check - It")
                .font(.title2)
            
            Spacer()
            
            SignInWithAppleButton(onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }) { result in
                userStore.loginCenter = .apple
                Task {
                    await userStore.loginWithCredential(result)
                }
            }
            .frame(width: 280, height: 50)
            
            // 카카오 로그인
            kakaoLoginButton
            
            // 구글 로그인
            googleLoginButton
            
            
            Button(action: {
                KakaoLoginStore().signOut()
            }){
                Text("카카오 로그아웃")
            }
            
            Spacer()
        }
    }
    
    func signInWithGoogle() { }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(userStore: UserStore())
//            .environmentObject(UserStore())
//    }
//}
