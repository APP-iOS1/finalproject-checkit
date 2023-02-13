//
//  QuestionView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct QuestionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var frequentlyQeustionsTitle: String = "자주하는 질문"
    @State private var frequentlyQeustionsImage: String = "person.fill.questionmark"
    @State private var customServiceTitle: String = "문의하기"
    @State private var customServiceImage: String = "person.crop.circle.badge.questionmark"
    @State private var unregisterTitle: String = "회원탈퇴"
    @State private var unregisterImage: String = "x.circle"
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: FrequentlyAskedQuestionsView()) {
                HStack {
                    MyPageButton(buttonTitle: $frequentlyQeustionsTitle, buttonImage: $frequentlyQeustionsImage)
                    Spacer()
                }
            }
            .padding(.top)
            
            Divider()
                .background(Color.white)
            
            NavigationLink(destination: Text("문의하기")) {
                HStack {
                    MyPageButton(buttonTitle: $customServiceTitle, buttonImage: $customServiceImage)
                    Spacer()
                }
            }
            
            Divider()
                .background(Color.white)
            
            NavigationLink(destination: Text("회원 탈퇴")) {
                HStack {
                    MyPageButton(buttonTitle: $unregisterTitle, buttonImage: $unregisterImage)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
