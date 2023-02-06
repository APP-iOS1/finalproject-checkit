//
//  MemberStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import Firebase

enum MemberError: Error {
    case notFoundMember
}

class MemberStore: ObservableObject {
    let database = Firestore.firestore()
    
    @Published var members: [Member] = []
    
    /// 동아리에 해당하는 구성원 정보를 불러오는 메소드입니다.
    /// - Parameter groudId: 불러올 동아리 id
    func fetchMember(_ groupId: String) async throws {
        let querySnapshot = try await database.collection("Group")
            .document(groupId)
            .collection("Member")
            .getDocuments()
        
        guard !querySnapshot.isEmpty else { throw MemberError.notFoundMember }
        
        for documnet in querySnapshot.documents {
            let data = documnet.data()
            
            let uid = data[MemberConstants.uid] as? String ?? ""
            let position = data[MemberConstants.position] as? String ?? ""
            
            let member = Member(uid: uid, position: position)
            
            DispatchQueue.main.async {
                self.members.append(member)
            }
        }
    }
    
    /// 동아리 멤버를 제거하는 메소드
    /// - Parameter groupdId 삭제할 멤버가 속해 있는 동아리
    /// - Parameter uid 삭제할 멤버의 uid
    ///
    /// 동아리에서 멤버를 삭제(강퇴)시 해야하는 작업은 다음과 같다.
    /// 1. 동아리 멤버 컬렉션에서 멤버 삭제
    /// 2. 동아리 컬렉션에 동아리원 숫자 감소
    /// 3. 삭제된 동아리원 groupId에서 강퇴 또는 나간 동아리 id 삭제
    func removeMember(_ groupId: String, uid: String) async {
        do {
            try await database.collection("Group").document(groupId)
                .collection("Member")
                .document(uid)
                .delete()
        } catch {
            print("remove member error: \(error.localizedDescription)")
        }
    }
    
    
}

// MARK: - 데이터 crud외 작업
extension MemberStore {
    
    /// 동아리원을 정렬하는 메소드입니다.
    /// 정렬 순서는 (방장 - 운영진 - 구성원) 순서입니다.
    func sortedMember(_ nameDict: [String:String]) async -> [Member] {
        let host = self.members.filter({$0.position == "방장"})
        let mangement = self.members.filter{$0.position == "운영진"}
        var general = self.members.filter{$0.position == "구성원"}
        
        general.sort(by: { member1, member2 in
            return nameDict[member1.uid] ?? "A" < nameDict[member2.uid] ?? "B"
        })
        
        let members = host + mangement + general
        return members
    }
}
