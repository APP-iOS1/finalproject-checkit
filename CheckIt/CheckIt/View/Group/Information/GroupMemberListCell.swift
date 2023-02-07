//
//  GroupMemberListCell.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/20.
//

import SwiftUI

struct GroupMemberListCell: View {
    @EnvironmentObject var memberStore: MemberStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isRemoveMember: Bool = false
    
    @Binding var nameDict: [String:String]
    @Binding var isEditing: Bool
    
    var group: Group
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
                
                ///  1. 동아리 멤버 컬렉션에서 멤버 삭제
                /// 2. 동아리 컬렉션에 동아리원 숫자 감소
                /// 3. 삭제된 동아리원 groupId에서 강퇴 또는 나간 동아리 id 삭제
                Button {
                    isRemoveMember.toggle()
                    
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
                .opacity(isEditing && member.uid != group.hostID ? 1 : 0)
                .padding(.trailing)
            }
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(10)
        }
        
        .alert("해당 동아리원을 강퇴하시겠습니까?", isPresented: $isRemoveMember) {
            Button(role: .destructive, action: {
                print("강퇴된 동아리원 :\(nameDict[member.uid])")
                
                Task {
                    await memberStore.removeMember(group.id, uid: member.uid)
                    await memberStore.removeGroupId(group.id, uid: member.uid)
                    
                    self.memberStore.members.removeAll {$0.uid == member.uid }
                }
            }, label: {
                Text("강퇴하기")
            })
            
            Button(role: .cancel, action: {
                print("취소하기")
            }, label: {
                Text("취소하기")
            })
        }
    }
}

//struct GroupMemberListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMemberListCell(data: .constant(MemberTest(position: "운영진", memberName: "류창휘")))
////            .previewLayout(.sizeThatFits)
//    }
//}
