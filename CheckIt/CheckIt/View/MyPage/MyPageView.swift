//
//  MyPageView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI


struct MyPageView: View {
    @EnvironmentObject var userStore: UserStore
//    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    var userName: String {
        userStore.user?.name ?? "N/A"
    }
    
    var loginCenter: String {
        switch userStore.loginCenter {
        case .apple:
            return "Apple"
        case .kakao:
            return "Kakao"
        case .google:
            return "Google"
        default:
            return "N/A"
        }
    }
    
    @State var isPresentedLogoutAlert: Bool = false
    @State var isPresentedNotionSheet: Bool = false
    
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
                Text("\(loginCenter) 로그인 중")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            Divider()
                .padding(.vertical)
            
            // MARK: - 프리미엄 요금제 페이지
//            Section {
//                Button {
//                    premiumButtonToggle.toggle()
//                } label: {
//                    HStack{
//                        MyPageButton(buttonTitle: $primiumPlansButtonTitle, buttonImage: $primiumPlansButtonImage)
//                        Spacer()
//                    }
//                }.sheet(isPresented: $premiumButtonToggle) {
//                    premiumRateView()
//                }
//            }
            
            // MARK: - 약관 및 정책 페이지
            Section {

               

                Button(action: {
                    isPresentedNotionSheet = true
                }) {
                    HStack {
                        MyPageButton(buttonTitle: $termsAndPolicyButtonTitle, buttonImage: $termsAndPolicyButtonImage)
                        Spacer()
                    }
                }
                
            }
            
            // MARK: - 고객문의 페이지
            Section {
                NavigationLink(destination: QuestionView()) {
                    HStack {
                        MyPageButton(buttonTitle: $contackUsButtonTitle, buttonImage: $contackUsButtonImage)
                        Spacer()
                    }
                }
            }
            
            // MARK: - 로그아웃 페이지
            Section {
                HStack {
                    Button(action: { isPresentedLogoutAlert = true }) {
                        MyPageButton(buttonTitle: $logoutButtonTitle, buttonImage: $logoutButtonImage)
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .overlay {
            if isPresentedLogoutAlert {
                logoutAlert
            }
        }
        .sheet(isPresented: $isPresentedNotionSheet) {
            SafariView(mode: .term)
        }
        
    }
    
    //MARK: - logoutAlert
    private var logoutAlert: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.4))
                .ignoresSafeArea()
            LogoutAlert(cancelButtonTapped: $isPresentedLogoutAlert)
                .padding(.horizontal, 30)
        }
        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
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
