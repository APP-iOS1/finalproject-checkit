//
//  QuestionView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct QuestionView: View {
    @State private var frequentlyQeustionsTitle: String = "자주하는 질문"
    @State private var frequentlyQeustionsImage: String = "person.fill.questionmark"
    @State private var customServiceTitle: String = "문의하기"
    @State private var customServiceImage: String = "person.crop.circle.badge.questionmark"
    @State private var unregisterTitle: String = "회원탈퇴"
    @State private var unregisterImage: String = "x.circle"
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: FrequentlyAskedQuestionsView()) {
                MyPageButton(buttonTitle: $frequentlyQeustionsTitle, buttonImage: $frequentlyQeustionsImage)
            }
            .padding(.top)
            
            Divider()
                .background(Color.white)
            
            NavigationLink(destination: Text("문의하기")) {
                MyPageButton(buttonTitle: $customServiceTitle, buttonImage: $customServiceImage)
            }
            
            Divider()
                .background(Color.white)
            
            NavigationLink(destination: Text("회원 탈퇴")) {
                MyPageButton(buttonTitle: $unregisterTitle, buttonImage: $unregisterImage)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
