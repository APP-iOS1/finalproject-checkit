//
//  GroupInformationView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/20.
//

import SwiftUI

struct MemberTest: Hashable {
    var position: String
    var memberName: String
}

struct GroupInformationView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var memberStore: MemberStore
    @EnvironmentObject var groupStore: GroupStore
    
    /// 동아리 방장이 동아리 정보를 편집할지를 나타내는 State 프로퍼티입니다.
    /// 초기값은 false입니다.
    @State private var isEditing: Bool = false
    
    var group: Group
    
    //FIXME: - 현재 보고있는 방이 방장인지 아닌지 나타내는 연산프로퍼티
    /// 현재 Bool 타입인데 열거형으로 바꿔야 한다.
    var isHost: Bool {
        guard let user = userStore.user else { return false }
        return (group.hostID == user.id)
    }
    
    var groupImage: UIImage {
        guard let image = groupStore.groupImage[group.id] else { return UIImage() }
        return image
    }
    
    var body: some View {
        VStack {
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
                        
                        Text("\(memberStore.members.count) /20 명")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        if isHost {
                            Button {
                                isEditing.toggle()
                            } label: {
                                Image(systemName: "pencil.circle")
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing, 26)
                        }
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                    
                    ScrollView {
                        VStack {
                            ForEach(memberStore.members.indices, id: \.self) { idx in
                                GroupMemberListCell(isEditing: $isEditing, member: memberStore.members[idx])
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
        .onAppear {
            memberStore.members.removeAll()
            Task {
                do {
                    try await memberStore.fetchMembers(group.id)
                } catch MemberError.notFoundMember {
                    print("member를 못찾음")
                } catch {
                    print("not found error")
                }
                
                print("가져온 구성원들: \(memberStore.members)")
            }
        }
    }
}

struct GroupInformationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInformationView(group: Group.sampleGroup)
            .environmentObject(UserStore())
            .environmentObject(MemberStore())
            .environmentObject(GroupStore())
    }
}
