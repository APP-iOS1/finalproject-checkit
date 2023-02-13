//
//  WithdrawalAlert.swift
//  CheckIt
//
//  Created by sole on 2023/02/13.
//

import SwiftUI

struct WithdrawalAlert: View {
    @EnvironmentObject var userStore: UserStore
    @Binding var cancelButtonTapped: Bool
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
            VStack {
                Spacer()
                
                Text("정말로 탈퇴하시겠습니까?")
                    .font(.system(size: 20, weight: .bold))
                    
                Text("탈퇴 시 모든 회원정보가 즉시 삭제됩니다.")
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                
                Spacer()
                HStack {
                    
                    Button {
                        cancelButtonTapped = false
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGray)
                            .overlay {
                                Text("취소하기")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.trailing, 18)
                    
                    
                    Button {
                        let resultDeleteUser = userStore.deleteUser()
                        userStore.isPresentedLoginView = true
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGreen)
                            .overlay {
                                Text("탈퇴하기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.leading, 0)


                } // - HStack
                
                
                Spacer()
            }
        }
        .frame(height: 200)
    }
}


