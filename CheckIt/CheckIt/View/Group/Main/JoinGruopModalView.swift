//
//  JoinGruopModalView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI

struct JoinGruopModalView: View {
    @State private var invitationCode: String = ""
    @State private var isJoined: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var groupStores: GroupStore
    
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
//                Task {
//                    await groupStores.joinGroup(invitationCode, uid: "Dpcvu3OOAUuq3ccDhBcW")
//                }
                
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
    static var previews: some View {
        JoinGruopModalView()
            .environmentObject(GroupStore())
    }
}
