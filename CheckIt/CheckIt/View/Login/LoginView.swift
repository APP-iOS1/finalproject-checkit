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

struct LoginView: View {
    
    var kakaoLoginButton: some View {
        Button(action: {
            
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
    
    var body: some View {
        VStack {
            SignInWithAppleButton(onRequest: { _ in }, onCompletion: { _ in })
                .frame(width: 280, height: 50)
            
            kakaoLoginButton
            
            naverLoginButton
            
            GoogleSignInButton(action: signInWithGoogle)
                .frame(width: 280, height: 60)
                .cornerRadius(12)
        }
    }
    
    func signInWithGoogle() { }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
