//
//  QuitGroupAlert.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct QuitGroupAlert: View {
    @Binding var cancelButtonTapped: Bool
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
            VStack {
                Text("해당 동아리를 나가시겠습니까?")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 25)

                Text("해당 동아리를 나가면 \n동아리에 대한 모든 정보가 사라집니다.")
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
//                    .padding(.top, 10)
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
                        print("dd")
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGreen)
                            .overlay {
                                Text("나가기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.leading, 0)


                }
                .padding(.bottom, 27)
            }
        }
        .frame(height: 200)
    }
}

struct QuitGroupAlert_Previews: PreviewProvider {
    static var previews: some View {
        QuitGroupAlert(cancelButtonTapped: .constant(false))
    }
}
