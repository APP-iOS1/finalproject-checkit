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
    @EnvironmentObject var userStore: UserStore
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
    
    // google login button custom
    var googleLoginButton: some View {
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
            
            SignInWithAppleButton(onRequest: { _ in }, onCompletion: { _ in })
                .frame(width: 280, height: 50)
            
            kakaoLoginButton
            
//            naverLoginButton
            
//            GoogleSignInButton(action: signInWithGoogle)
//                .frame(width: 280, height: 60)
//                .cornerRadius(12)
            
            // 구글로 로그인
            Button(action: {
                userStore.loginCenter = .google
                Task {
                    let credential = await GoogleLoginStore().signIn()
                    await userStore.signIn(credential: credential)
                    print(userStore.userData?.uid ?? "ZA")
//                    await userStore.fetchUser(userStore.userData?.uid ?? "NA")
                    
                    
                }
                
            }) { googleLoginButton }
            
            
  
            Spacer()
        }
    }
    
    func signInWithGoogle() { }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserStore())
    }
}
