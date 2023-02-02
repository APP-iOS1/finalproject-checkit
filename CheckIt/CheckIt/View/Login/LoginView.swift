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
import KakaoSDKAuth
import KakaoSDKUser

struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    
    // kakao login button custom
    private var kakaoLoginButton: some View {
        Button(action: {
            userStore.loginCenter = .kakao
            userStore.kakaoLoginWithFirebase()
        }) {
            HStack {
                Image(systemName: "message.fill")
                
                Text(" 카카오로 로그인")
            }
            .frame(width: 280, height: 50)
            .background(Color("kakao"))
            .cornerRadius(12)
            .foregroundColor(.black)
        }
    }
    
    // google login button custom
    private var googleLoginButton: some View {
        Button(action: {
            userStore.loginCenter = .google
            Task {
                let credential = await GoogleLoginStore().signIn()
                let user = await userStore.signIn(credential: credential)
            }
        }) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.myGray)
                .foregroundColor(.white)
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
    }
    
    // naver login button custom
    private var naverLoginButton: some View {
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
            
            // 애플 로그인
            SignInWithAppleButton(onRequest: { _ in }, onCompletion: { _ in })
                .frame(width: 280, height: 50)
            
            // 카카오 로그인
            kakaoLoginButton
            
            // 구글 로그인
            googleLoginButton
   
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserStore())
    }
}
