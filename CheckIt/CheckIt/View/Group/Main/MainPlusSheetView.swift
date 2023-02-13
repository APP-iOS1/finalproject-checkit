//
//  MainPlusSheetView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/23.
//

import SwiftUI
import AlertToast

struct MainPlusSheetView: View {
    @State var isMakingGroup: Bool = false
    @State var isJoiningGroup: Bool = false
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    @Binding var toastObj: ToastMessage
    
    @Environment(\.presentations) private var presentations
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("원하는 동아리를 직접 만들어보세요!\n동아리에 가입도 할 수 있습니다.")
                .font(.system(size: 22, weight: .bold))
            
            Text("아래 버튼을 누르면 개설이 시작돼요.")
                .font(.system(size: 16, weight: .regular))
            
            // MARK: - 동아리 개설하기 버튼
            Button {
                isMakingGroup.toggle()
            } label: {
                Text("동아리 개설하기")
                    .modifier(MainPlusSheetButtonModifier())
            }
            .sheet(isPresented: $isMakingGroup) {
                MakeGroupModalView(showToast: $showToast, toastMessage: $toastMessage, toastObj: $toastObj)
                    .environment(\.presentations, presentations + [$isMakingGroup])
                    .presentationDetents([.height(600)])
            }
            
            Text("아래 버튼을 누르고 코드를 입력해주세요.")
                .font(.system(size: 16, weight: .regular))
            
            // MARK: - 동아리 참가하기 버튼
            Button {
                isJoiningGroup.toggle()
            } label: {
                Text("동아리 참가하기")
                    .modifier(MainPlusSheetButtonModifier())
            }
            .sheet(isPresented: $isJoiningGroup) {
                JoinGruopModalView(showToast: $showToast, toastMessage: $toastMessage, toastObj: $toastObj)
                    .environment(\.presentations, presentations + [$isJoiningGroup])
                    .presentationDetents([.height(415)])
            }
        }
        .padding(.horizontal, 40)
        .presentationDragIndicator(.visible)
        
//        .toast(isPresenting: $showToast){
//            AlertToast(displayMode: .banner(.slide), type: .regular, title: toastMessage)
//        }
    }
}

//struct MainPlusSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainPlusSheetView(showToast: .constant(false), toastMessage: .constant(""))
//    }
//}
