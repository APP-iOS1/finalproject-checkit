//
//  GroupMemberListCell.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/20.
//

import SwiftUI

struct GroupMemberListCell: View {
    @Binding var nameDict: [String:String]
    @Binding var isEditing: Bool
    
    var member: Member
    
    var body: some View {
        VStack {
            HStack {
                GroupPosition(position: member.position)
                    .padding(.leading, 17)
                
                Text(nameDict[member.uid] ?? "N/A")
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
                    .frame(width: 52)
                
                Button {
                    print("dd")
                } label: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    print("ss")
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(.leading, -20)
                }
                .opacity(isEditing ? 1 : 0)
                .padding(.trailing)
            }
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

//struct GroupMemberListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMemberListCell(data: .constant(MemberTest(position: "운영진", memberName: "류창휘")))
////            .previewLayout(.sizeThatFits)
//    }
//}
