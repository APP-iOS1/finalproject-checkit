//
//  QuestionView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct QuestionView: View {
    @State private var termsButtonTitle: String = "이용약관"
    @State private var openSourceLicenseTitle: String = "오픈소스 라이센스"
    @State private var customServiceTitle: String = "고객센터"
    @State private var frequentlyQeustionsTitle: String = "자주 하는 질문"
    var body: some View {
        VStack {
            
            NavigationLink(destination: Text("이용약관")) {
                MyPageButton(buttonTitle: $termsButtonTitle)
            }
            .padding(.top)
            Divider()
                .padding(.horizontal, 24)
            NavigationLink(destination: Text("오픈소스 라이센스")) {
                MyPageButton(buttonTitle: $openSourceLicenseTitle)
            }
            Divider()
                .padding(.horizontal, 24)
            NavigationLink(destination: Text("고객센터")) {
                MyPageButton(buttonTitle: $customServiceTitle)
            }
            Divider()
                .padding(.horizontal, 24)
            NavigationLink(destination: Text("자주 하는 질문")) {
                MyPageButton(buttonTitle: $frequentlyQeustionsTitle)
            }
            Spacer()
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
