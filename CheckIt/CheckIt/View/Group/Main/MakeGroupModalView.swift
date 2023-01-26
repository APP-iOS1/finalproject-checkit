//
//  MakeGroupModalView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI

struct MakeGroupModalView: View {
    @State private var groupName: String = ""
    @State private var groupDescription: String = ""
    @State private var isJoined: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("동아리 개설하기")
                .font(.system(size: 24, weight: .bold))
            
            HStack {
                Button {
                    // MARK: - 동아리 이미지 추가하는 버튼
                    isJoined.toggle()
                    dismiss()
                } label: {
                    ZStack {
                        Circle().fill(Color.myLightGray)
                            .scaledToFit()
                            .frame(width: 110, height: 90)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("동아리 기본정보")
                        .font(.system(size: 17, weight: .regular))
                    
                    // MARK: - 동아리 이름 텍스트필드
                    // FIXME: - 글자수 제한해줘야함, 현재 한줄로 계속 이어짐
                    TextField("동아리 이름을 입력해주세요!", text: $groupName)
                        .font(.system(size: 14, weight: .regular))
                    
                    Divider()
                        .background(.black)
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black, lineWidth: 0.5)
                    .frame(height: 100)
                
                // MARK: - 동아리 상세내용 텍스트필드
                // FIXME: - 글자수 제한해줘야함, 현재 한줄로 계속 이어짐
                TextField("동아리의 상세 내용을 적어주세요.", text: $groupDescription)
                    .font(.system(size: 14, weight: .regular))
                    .padding()
                    .frame(height: 75)
            }
            
            Button {
                // MARK: - 동아리 개설하기 버튼
                isJoined.toggle()
                dismiss()
            } label: {
                Text("동아리 개설하기")
                    .modifier(GruopCustomButtonModifier())
            }
        }
        .padding(40)
        .presentationDragIndicator(.visible)
    }
}

struct MakeGroupModalView_Previews: PreviewProvider {
    static var previews: some View {
        MakeGroupModalView()
    }
}
