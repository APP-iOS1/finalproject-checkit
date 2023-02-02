//
//  Profile.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct Profile: View {
    var userEmailvalue: String
    var userImageURL: URL
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
                                    ProgressView()
                                }
                            )
                
                
                Text(userEmailvalue)
                    .font(.system(size: 13, weight: .medium))
                    .padding(.top, 18)
                    .padding(.bottom, 24)
                
                Button {
                    print("dd")
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
        .frame(height: 250)
    }
}
//
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile(userEmailvalue: "captainHuh@naver.com", userImageURL: URL)
//    }
//}
