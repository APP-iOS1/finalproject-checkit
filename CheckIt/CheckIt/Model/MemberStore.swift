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
    func fetchMembers(_ groupId: String) async throws {
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
}



// 동아리가 있으면 안에 일정도 있다
// 일정이 있으면 출석부도 있다
