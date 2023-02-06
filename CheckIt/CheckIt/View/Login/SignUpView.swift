//
//  SignUpView.swift
//  CheckIt
//
//  Created by sole on 2023/02/05.
//

import SwiftUI

struct SignUpView: View {
    @State var name: String = ""
    @EnvironmentObject var userStore: UserStore
    var body: some View {
        VStack(alignment: .leading) {
            Text("회원가입")
                .font(.title2)
                .bold()
                .padding(.bottom, 30)
            
            TextField("이름을 입력하세요", text: $name)
            
            Capsule()
                .foregroundColor(Color.myGray)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            
            Button {
                userStore.changeUserName(name: name)
                userStore.isFirstLogin = false
                userStore.isPresentedLoginView = false
            } label: {
                Text("이름 입력하기")
                    .modifier(GruopCustomButtonModifier())
            }
        }
        .padding(.horizontal, 30)
    }
}


//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
