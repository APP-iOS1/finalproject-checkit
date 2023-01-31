//
//  GroupStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import Firebase
import FirebaseStorage

class GroupStore: ObservableObject {
    @Published var groups: [Group] = []
    
    let database = Firestore.firestore()
    
    // MARK: - 동아리를 개설하는 메소드
    /// - Parameter uid: 로그인한사용자의 uid 동아리 방장의 id
    /// - Parameter group: 사용자가 생성한 동아리 인스턴스
    func createGroup(_ uid: String, group: Group) async {
        do {
            try await database.collection("Group")
                .document(group.id)
                .setData([
                    "id": group.id,
                    "host_id": group.hostID,
                    "invitationCode": group.invitationCode,
                    "image": group.image,
                    "description": group.description,
                    "schedule_id": group.scheduleID])
        } catch {
            print("동아리 생성 에러: \(error.localizedDescription)")
        }
    }
}

