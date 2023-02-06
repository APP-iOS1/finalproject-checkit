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
    
    @State var memberTest: [MemberTest] =
    [
        MemberTest(position: "구성원", memberName: "류창휘"),
        MemberTest(position: "방장", memberName: "허님니"),
        MemberTest(position: "운영진", memberName: "지니"),
        MemberTest(position: "운영진", memberName: "예린스"),
        MemberTest(position: "운영진", memberName: "호이"),
        MemberTest(position: "구성원", memberName: "또리")
    ]
    
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
                GroupInfoMainView()
            } else {
                // 일반 구성원이 보는 뷰
                // FIXME: - 뷰 생성 필요
                Text("일반 동아리원이 보는 동아리 정보 뷰")
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
