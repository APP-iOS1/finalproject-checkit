//
//  JoinGruopModalView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI

struct JoinGruopModalView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var groupStores: GroupStore
    @EnvironmentObject var userStores: UserStore
    
    @State private var invitationCode: String = ""
    @State private var isJoined: Bool = false
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("동아리 참가하기")
                .font(.system(size: 22, weight: .bold))
            
            // MARK: - 동아리 초대 코드 텍스트필드
            TextField("공유 받은 초대 코드를 입력해주세요!", text: $invitationCode)
                .font(.system(size: 16, weight: .regular))
                .padding()
                .frame(height: 65)
                .background(Color.myLightGray)
                .cornerRadius(10)
            
            // MARK: - 동아리 참가하기 버튼
            Button {
                isJoined.toggle()
                Task {
                    let statusCode = await groupStores.joinGroup(invitationCode, user: userStores.user!)
                    showToast.toggle()
                    
                    switch statusCode {
                    case .alreadyJoined:
                        toastMessage = "이미 가입된 동아리입니다."
                    case .newJoined:
                        toastMessage = "동아리 가입이 완료되었습니다."
                    case .notValidated:
                        toastMessage = "올바르지 않은 초대코드 입니다."
                    }
                }
                dismiss()
                
            } label: {
                Text("동아리 참가하기")
                    .modifier(GruopCustomButtonModifier())
            }
        }
        .padding(40)
        .presentationDragIndicator(.visible)
    }
}

struct JoinGruopModalView_Previews: PreviewProvider {
    @State static var showToast: Bool = false
    @State static var toastMessage: String = ""
    
    static var previews: some View {
        JoinGruopModalView(showToast: $showToast, toastMessage: $toastMessage)
            .environmentObject(GroupStore())
    }
}
