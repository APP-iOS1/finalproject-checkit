//
//  GroupInfoMainView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/06.
//

import SwiftUI

struct GroupInfoMainView: View {
    @EnvironmentObject var memberStore: MemberStore
    @EnvironmentObject var groupStore: GroupStore
    
    var group: Group
    
    // 현재 보고있는 동아리 이미지를 얻는 연산프로퍼티
    // FIXME: - 현재 그룹이미지가 없는 경우 빈 image를 반환하는데 이를 디폴트 이미지로 수정해야합니다.
    var groupImage: UIImage {
        guard let image = groupStore.groupImage[group.id] else { return UIImage() }
        return image
    }
    
    @State var memberTest: [MemberTest] =
    [
        MemberTest(position: "구성원", memberName: "류창휘"),
        MemberTest(position: "방장", memberName: "허님니"),
        MemberTest(position: "운영진", memberName: "지니"),
        MemberTest(position: "운영진", memberName: "예린스"),
        MemberTest(position: "운영진", memberName: "호이"),
        MemberTest(position: "구성원", memberName: "또리")
    ]
    
    var body: some View {
        
        HStack(spacing: 25) {
            //동아리 이미지
            Image(uiImage: groupImage)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.myGray, lineWidth: 2)
                }
            
            //동아리 정보
            VStack(alignment: .leading, spacing: 10) {
                Text(group.name)
                    .font(.system(size: 16, weight: .bold))
                Text(group.description)
                    .font(.system(size: 13, weight: .regular))
                    .lineLimit(3)
            }
            .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 20)
        
        //동아리 멤버 리스트
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.myLightGray)
            VStack {
                HStack {
                    Text("동아리 멤버 리스트")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.leading, 28)
                        .padding(.trailing, 0)
                    Spacer()
                    Text("\(memberStore.members.count) /20 명")
                        .font(.system(size: 16, weight: .semibold))
                    Button {
                        print("dd")
                    } label: {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 26)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                ScrollView {
                    VStack {
                        ForEach(memberStore.members.indices, id: \.self) { idx in
                            GroupMemberListCell(member: memberStore.members[idx])
                                .padding(.horizontal, 24)
                                .padding(.bottom, 5)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 8) //아직 기준을 잘 모르겠음
    }
}

struct GroupInfoMainView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInfoMainView(group: Group.sampleGroup)
            .environmentObject(MemberStore())
            .environmentObject(GroupStore())
    }
}
