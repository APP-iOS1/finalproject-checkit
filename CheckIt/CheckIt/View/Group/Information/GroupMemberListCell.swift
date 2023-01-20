//
//  GroupMemberListCell.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/20.
//

import SwiftUI

struct GroupMemberListCell: View {
    @Binding var data: MemberTest
    var body: some View {
        VStack {
            HStack {
                GroupPosition(position: $data.position)
                    .padding(.leading, 17)
                    .padding(.trailing, 0)
                Text(data.memberName)
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(1)
                    .frame(width: 52)
                    .padding(.leading, 25)
                Button {
                    print("dd")
                } label: {
                    Image(systemName: "person.circle.fill")
                }
                Spacer()
                
                Button {
                    print("ss")
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .bold()
                }
                .padding(.trailing, 17)


            }
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(10)
        }

    }
}

struct GroupMemberListCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupMemberListCell(data: .constant(MemberTest(position: "운영진", memberName: "류창휘")))
//            .previewLayout(.sizeThatFits)
    }
}
