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
        VStack {
            TextField("이름을 입력하세요", text: $name)
            Button(action: {
                userStore.changeUserName(name: name)
                userStore.isFirstLogin = false
                userStore.isPresentedLoginView = false
            }) { Text("Submit") }
        }
    }
}


//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
