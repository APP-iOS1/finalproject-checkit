//
//  Profile.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct Profile: View {
    @State var changedName: String = ""
    var userEmailvalue: String
    var userImageURL: URL
    @State var isPresentedChangeProfileView: Bool = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.myLightGray)
            VStack {
                AsyncImage(
                    url: userImageURL,
                    content: { image in
                        image
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(Color.myGray, lineWidth: 2)
                            }
                            .padding(.top, 23)
                    },
                    placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(Color.myGray, lineWidth: 2)
                            }
                            .padding(.top, 23)
                            .foregroundColor(.myGray)
                    }
                )
                
                
                Text(userEmailvalue)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 18)
                    .padding(.bottom, 24)
                
                Button {
                    isPresentedChangeProfileView = true
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                        .foregroundColor(.myGreen)
                        .overlay {
                            Text("프로필 편집")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .regular))
                        }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
            }
        }
        .frame(height: 200)
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
            Text("프로필 편집")
                .font(.title2)
                .bold()
                .padding(.bottom, 30)
            
            TextField("변경할 이름을 작성해주세요", text: $changedName)
            
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
                Text("이름 변경하기")
                    .modifier(GruopCustomButtonModifier())
            }
            
        }
        .padding(.horizontal, 30)
        
    }
} // - ChangeProfileView
//
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile(userEmailvalue: "captainHuh@naver.com", userImageURL: URL)
//    }
//}
