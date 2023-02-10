//
//  JoinGruopModalView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI
import AlertToast

struct JoinGruopModalView: View {
    @EnvironmentObject var groupStores: GroupStore
    @EnvironmentObject var userStores: UserStore
    
    @Environment(\.presentations) private var presentations
    
    @State private var invitationCode: String = ""
    @State private var isClicked: Bool = false
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("동아리 참가하기")
                .font(.system(size: 25, weight: .bold))
            
            HStack() {
                Image(systemName: "arrow.down.doc")
                
                Text("복사한 코드 붙여넣기")
                    .font(.system(size: 18, weight: .regular))
                    .onTapGesture {
                        if let str = UIPasteboard.general.string {
                            invitationCode = str
                        }
                    }
            }
            
            // MARK: - 동아리 초대 코드 텍스트필드
            TextField("공유 받은 초대 코드를 입력해주세요!", text: $invitationCode)
                .font(.system(size: 16, weight: .regular))
                .padding()
                .frame(height: 65)
                .background(Color.myLightGray)
                .cornerRadius(10)
            
            // MARK: - 동아리 참가하기 버튼
            Button {
                if isClicked {
                    return
                }
                isClicked.toggle()
                
                Task {
                    let statusCode = await groupStores.joinGroup(invitationCode, user: userStores.user!)
                    showToast.toggle()
                    
                    switch statusCode {
                    case .alreadyJoined:
                        toastMessage = "이미 가입된 동아리입니다."
                        presentations.forEach {
                            $0.wrappedValue = false
                        }
                    case .newJoined(let newGroupId):
                        toastMessage = "동아리 가입이 완료되었습니다."
                        
                        presentations.forEach {
                            $0.wrappedValue = false
                        }
                        let result = await groupStores.getGroup(newGroupId)
                        switch result {
                        case .success(let group):
                            self.groupStores.groups.append(group)
                        case .failure(let error):
                            print(error)
                        }
                        
                    case .notValidated:
                        toastMessage = "올바르지 않은 초대코드 입니다."
                    case .fulled:
                        toastMessage = "동아리 정원이 초과 했습니다."
                    }
                    isClicked.toggle()
                }
                
            } label: {
                Text("동아리 참가하기")
                    .modifier(GruopCustomButtonModifier())
            }
        }
        .padding(40)
        .presentationDragIndicator(.visible)
        .toast(isPresenting: $showToast){
            AlertToast(displayMode: .banner(.slide), type: .regular, title: toastMessage)
        }
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
