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
//                Image(systemName: "scribble")
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//                    .overlay {
//                        Circle().stroke(Color.myGray, lineWidth: 2)
//                    }
//                    .padding(.top, 23)
                
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
        }
    }
}

struct ChangeProfileView: View {
    @Binding var changedName: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    var body: some View {
        VStack {
            TextField("변경할 이름을 작성해주세요", text: $changedName)
            Button(action: {
                userStore.changeUserName(name: changedName)
                dismiss()
            }) {
                Text("Submit")
            }
        }
        
    }
}
//
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile(userEmailvalue: "captainHuh@naver.com", userImageURL: URL)
//    }
//}
