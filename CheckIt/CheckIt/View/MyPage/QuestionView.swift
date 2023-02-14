//
//  QuestionView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct QuestionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var isPresentedNotionSheet: Bool = false
    @State var isPresentedWithdrawalAlert: Bool = false
   
    @State private var frequentlyQeustionsTitle: String = "자주하는 질문"
    @State private var frequentlyQeustionsImage: String = "person.fill.questionmark"
    @State private var customServiceTitle: String = "문의하기"
    @State private var customServiceImage: String = "person.crop.circle.badge.questionmark"
    @State private var unregisterTitle: String = "회원탈퇴"
    @State private var unregisterImage: String = "x.circle"
    @State private var openSourceLicenseTitle: String = "오픈소스 라이선스"
    @State private var openSourceLicenseImage: String = "globe.central.south.asia"
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { isPresentedNotionSheet = true }) {
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
            
            // 오픈소스 라이선스
            
            NavigationLink(destination: LicenseView()) {
                HStack {
                    MyPageButton(buttonTitle: $openSourceLicenseTitle, buttonImage: $openSourceLicenseImage)
                    Spacer()
                }
            }
            
            Divider()
                .background(Color.white)

            // 회원탈퇴
            Button(action: {
                isPresentedWithdrawalAlert = true
            }) {
                HStack {
                    MyPageButton(buttonTitle: $unregisterTitle, buttonImage: $unregisterImage)
                    Spacer()
                }
            }
            .foregroundColor(.myGray)
            
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
        .overlay {
            if isPresentedWithdrawalAlert {
                withdrawalAlert
            }
        }
    }
    
    //MARK: - View
    private var withdrawalAlert: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.4))
                .ignoresSafeArea()
            WithdrawalAlert(cancelButtonTapped: $isPresentedWithdrawalAlert)
                .padding(.horizontal, 30)
        }
        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
    }
    
}

