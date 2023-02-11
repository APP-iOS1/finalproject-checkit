//
//  Profile.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct Profile: View {
    @State var changedName: String = ""
    @State var isPresentedChangeProfileView: Bool = false
    
    var body: some View {
        VStack {
            Button {
                isPresentedChangeProfileView = true
            } label: {
                Text("이름 변경하기")
            }
            
        }
        .sheet(isPresented: $isPresentedChangeProfileView) {
            ChangeProfileView(changedName: $changedName)
                .presentationDetents([.height(300)])
            
        }
    }
}

    //MARK: - View(ChangeProfileView)
    struct ChangeProfileView: View {
        @Binding var changedName: String
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var userStore: UserStore
        var body: some View {
            VStack(alignment: .leading) {
                Text("이름 변경하기")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 30)
                
                TextField("변경할 이름을 입력해주세요", text: $changedName)
                
                Capsule()
                    .foregroundColor(Color.myGray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                
                Button {
                    userStore.changeUserName(name: changedName)
                    changedName = ""
                    dismiss()
                } label: {
                    Text("저장하기")
                        .modifier(GruopCustomButtonModifier())
                }
                
            }
            .padding(.horizontal, 40)
        }
    } // - ChangeProfileView
    
    struct Profile_Previews: PreviewProvider {
        static var previews: some View {
            Profile()
        }
    }
