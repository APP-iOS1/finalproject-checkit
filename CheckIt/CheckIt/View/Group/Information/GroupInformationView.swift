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
    @State private var nameDict: [String:String] = [:]
    @State private var isLoading: Bool = false
    
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
            if isLoading {
                LoadingView()
            } else {
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
                .padding(.bottom, 20)
                
                //동아리 멤버 리스트
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(.myLightGray)
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.myGray)
                            }
                        VStack {
                            HStack {
                                Text("동아리 멤버 리스트")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.leading, 28)
                                    .padding(.trailing, 0)
                                
                                Spacer()
                                
                                HStack {
                                    Text("\(memberStore.members.count) / \(Constants.notPremiumGroupSize) 명")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    if isHost {
                                        Button {
                                            isEditing.toggle()
                                        } label: {
                                            Image(systemName: "pencil.circle")
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .padding(.trailing, 26)
                            }
                            .padding(.vertical, 20)
                            
                            Spacer()
                            
                            ScrollView {
                                VStack {
                                    ForEach(memberStore.members.indices, id: \.self) { idx in
                                        GroupMemberListCell(nameDict: $nameDict, isEditing: $isEditing, group: group, member: memberStore.members[idx])
                                            .padding(.horizontal, 24)
                                            .padding(.bottom, 5)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 8) //아직 기준을 잘 모르겠음
            }
        }
        
        .onAppear {
            Task {
                for member in memberStore.members {
                    let name = userStore.userDictionaryList[member.uid] ?? Constants.exsitMemberName
                    nameDict[member.uid] = name
                }
                
                self.memberStore.members = await memberStore.sortedMember(nameDict)
                //isLoading.toggle()
            }
        }
    }
}


private enum Constants {
    static let exsitMemberName: String = "탈퇴한 회원"
    static let notPremiumGroupSize: Int = 8
    static let premiumGroupSize: Int = 50
}


struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(.black)))
                .scaleEffect(3)
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
