//
//  MyPageView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    
    var userName: String {
        userStore.user?.name ?? "N/A"
    }
    
    @State private var primiumPlansButtonTitle: String = "프리미엄 요금제 알아보기"
    @State private var primiumPlansButtonImage: String = "checkmark.seal"
    @State private var termsAndPolicyButtonTitle: String = "약관 및 정책"
    @State private var termsAndPolicyButtonImage: String = "info.circle"
    @State private var contackUsButtonTitle: String = "고객문의"
    @State private var contackUsButtonImage: String = "questionmark.bubble"
    @State private var logoutButtonTitle: String = "로그아웃"
    @State private var logoutButtonImage: String = "rectangle.portrait.and.arrow.right"
    @State private var premiumButtonToggle: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(userName) 님")
                        .font(.system(size: 32, weight: .semibold))
                    
                    Spacer()
                    
                    Profile()
                }
                Text("Apple 로그인 중")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            Divider()
                .padding(.vertical)
            
            // MARK: - 프리미엄 요금제 페이지
            Section {
                Button {
                    premiumButtonToggle.toggle()
                } label: {
                    MyPageButton(buttonTitle: $primiumPlansButtonTitle, buttonImage: $primiumPlansButtonImage)
                }.sheet(isPresented: $premiumButtonToggle) {
                    premiumRateView()
                }
            }
            
            // MARK: - 약관 및 정책 페이지
            Section {
                NavigationLink(destination: TermsAndPolicyView()) {
                    MyPageButton(buttonTitle: $termsAndPolicyButtonTitle, buttonImage: $termsAndPolicyButtonImage)
                }
            }
            
            // MARK: - 고객문의 페이지
            Section {
                NavigationLink(destination: QuestionView()) {
                    MyPageButton(buttonTitle: $contackUsButtonTitle, buttonImage: $contackUsButtonImage)
                }
            }
            
            // MARK: - 로그아웃 페이지
            Section {
                NavigationLink(destination: LogoutView) {
                    MyPageButton(buttonTitle: $logoutButtonTitle, buttonImage: $logoutButtonImage)
                }
//                Divider()
//                    .padding(.bottom)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    //MARK: - Logout Test Views
    private var LogoutView: some View {
        VStack {
            Button(action: {
                userStore.signOut()
            }) {
                Text("로그아웃하기")
            }.buttonStyle(BorderedButtonStyle())
            
        }
    }
}


//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//
//    }
//}
