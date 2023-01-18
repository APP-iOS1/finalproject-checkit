//
//  MyPageView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct MyPageView: View {
    @State private var userName: String = "허대장"
    @State private var userEmail: String = "captainhuh@navar.com"
    
    @State private var primiumPlansButtonTitle: String = "프리미엄 요금제 알아보기"
    @State private var contackUsButtonTitle: String = "문의하기"
    @State private var logoutButtonTitle: String = "로그아웃"
    @State private var premiumButtonToggle: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("반갑습니다, \n\(userName)님")
                .lineLimit(2)
                .font(.system(size: 32, weight: .heavy))
                .padding(.leading, 40)
                .padding(.top)
                .padding(.bottom)
            
            Profile(userEmailvalue: $userEmail)
                .padding(.horizontal, 40)
            Spacer()
            
            Divider()
                .padding(.horizontal, 24)
            Button {
                premiumButtonToggle.toggle()
            } label: {
                MyPageButton(buttonTitle: $primiumPlansButtonTitle)
            }.sheet(isPresented: $premiumButtonToggle) {
                premiumRateView()
            }

            Divider()
                .padding(.horizontal, 24)
            NavigationLink(destination: QuestionView()) {
                MyPageButton(buttonTitle: $contackUsButtonTitle)
            }
            Divider()
                .padding(.horizontal, 24)
            NavigationLink(destination: Text("로그아웃")) {
                MyPageButton(buttonTitle: $logoutButtonTitle)
            }
            Divider()
                .padding(.horizontal, 24)
//                .padding(.bottom, 76)
                .padding(.bottom)
            
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
