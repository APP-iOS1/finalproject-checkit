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
    
    var group: Group
    
    //FIXME: - 현재 보고있는 방이 방장인지 아닌지 나타내는 연산프로퍼티
    /// 현재 Bool 타입인데 열거형으로 바꿔야 한다.
    var isHost: Bool {
        guard let user = userStore.user else { return false }
        return (group.hostID == user.id)
    }
    
    var body: some View {
        VStack {
            if isHost {
                GroupInfoMainView(group: group)
            } else {
                GeneralGroupInfoMainView()
            }
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
    }
}
