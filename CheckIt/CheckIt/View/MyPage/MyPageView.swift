//
//  MyPageView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStores: GroupStore
    var userName: String {
        userStore.user?.name ?? "N/A"
    }
    var userEmail: String {
        userStore.user?.email ?? "N/A"
    }
    var userImageURL: URL {
        userStore.userData?.photoURL ?? URL(string: "N/A")!
    }
    
    @State private var primiumPlansButtonTitle: String = "프리미엄 요금제 알아보기"
    @State private var contackUsButtonTitle: String = "문의하기"
    @State private var logoutButtonTitle: String = "로그아웃"
    @State private var premiumButtonToggle: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            //            AsyncImage(url: userImageURL)
            Text("반갑습니다, \n\(userName)님")
                .lineLimit(2)
                .font(.system(size: 32, weight: .bold))
                .padding([.top, .leading], 40)
                .padding(.bottom, 40)
            
            Profile(userEmailvalue: userEmail, userImageURL: userImageURL)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // MARK: - 프리미엄 요금제 페이지
            Section {
                Button {
                    premiumButtonToggle.toggle()
                } label: {
                    MyPageButton(buttonTitle: $primiumPlansButtonTitle)
                }.sheet(isPresented: $premiumButtonToggle) {
                    premiumRateView()
                }
                Divider()
                    .padding(.horizontal, 24)
            }
            
            // MARK: - 문의하기 페이지
            Section {
                NavigationLink(destination: QuestionView()) {
                    MyPageButton(buttonTitle: $contackUsButtonTitle)
                }
                Divider()
                    .padding(.horizontal, 24)
            }
            
            // MARK: - 로그아웃 페이지
            Section {
                NavigationLink(destination: LogoutView) {
                    MyPageButton(buttonTitle: $logoutButtonTitle)
                }
                Divider()
                    .padding(.horizontal, 24)
                //                .padding(.bottom, 76)
                    .padding(.bottom)
            }
            
            Spacer()
        }
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

//
//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//
//    }
//}
