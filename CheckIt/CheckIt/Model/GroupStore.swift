//
//  GroupStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import Firebase
import FirebaseStorage

enum GroupJoinStatus {
    case alreadyJoined
    case newJoined
    case notValidated
}

enum GroupCodeValidation {
    case validated(String)
    case notValidated
}

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
                    "name": group.name,
                    "invitationCode": group.invitationCode,
                    "image": group.image,
                    "description": group.description,
                    "schedule_id": group.scheduleID])
            
            // FIXME: - position관련 정보는 enum으로 수정 필요
    
            await createMember(database.collection("Group"), documentID: group.id, uid: uid, position: "방장")
        } catch {
            print("동아리 생성 에러: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - 동아리 멤버를 생성하는 메소드이다.
    /// - Parameter ref: 컬렉션 레퍼런스로 멤버가 속할 동아리의 컬렉션을 참조
    /// - Parameter documentID: 동아리의 docuemnt ID
    /// - Parameter uid: 동아리 멤버 컬렉션에 들어갈 uid
    /// - Parameter position: 멤버의 직책
    ///
    /// 동아리에 멤버를 추가하는 메소드입니다.
    func createMember(_ ref: CollectionReference, documentID: String, uid: String, position: String) async {
        do {
            try await ref.document(documentID).collection("Member")
                .document(uid)
                .setData([
                    "uid": uid,
                    "position": position
                ])
        } catch {
            print("동아리 멤버 추가 에러: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 자신이 속한 동아리 데이터를 가져오는 메소드
    /// - Parameter uid: 로그인한 사용자의 uid
    /// 자신이 속한 동아리의 데이터를 groups 프로퍼티 래퍼에 저장한다.
    func fetchGroups(_ uid: String) async {
        // FIXME: - 현재 더미데이터로 유저가 속한 그룹의 id를 선언함
        let groupID: [String] = ["bBpYMyPqY3OD1eIdRbGc", "A08B4C57-C0A7-4677-90D8-15E81F0C2E1B"]
        DispatchQueue.main.async {
            self.groups.removeAll()
        }
        
        do {
            let querySnapshot = try await database.collection("Group")
                .whereField("id", in: groupID)
                .getDocuments()
            
            for document in querySnapshot.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let invitationCode = data["invitationCode"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let hostID = data["hostID"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let scheduleID = data["scheduleID"] as? [String] ?? []
                
                let group = Group(id: id,
                                  name: name,
                                  invitationCode: invitationCode,
                                  image: image,
                                  hostID: hostID,
                                  description: description,
                                  scheduleID: scheduleID)
                
                DispatchQueue.main.async {
                    self.groups.append(group)
                }
            }
        } catch {
            print("동아리 가져오기 에러: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 유저가 동아리에 참가하는 메소드
    /// - Parameter code: 동아리 참가 코드
    /// - Parameter uid: 참가하는 사용자의 uid
    /// - Reuturn Value: 동아리 참가코드 입력시 반환되는 상태
    ///
    ///  유저는 초대받은 코드를 입력하여 동아리에 참가하는 메소드
    ///  이때 Member컬렉션에 직책과 uid정보를 추가해야하며, user 컬렉션에 참가한 동아리id를 추가해야한다.
    func joinGroup(_ code: String, uid: String) async -> GroupJoinStatus {
        let status = await checkedGroupCode(code)
        switch status {
        case .validated(let groupId):
            do {
                // FIXME: - 동아리에 이미 가입되었는지 확인하는 로직이 필요함
                try await database.collection("Group")
                    .document(groupId)
                    .collection("Member")
                    .document(uid)
                    .setData([
                        "uid": uid,
                        "position": "구성원"
                    ])
                return .newJoined
                
            } catch {
                print("joinGroup error: \(error.localizedDescription)")
                return .notValidated
            }
        case .notValidated:
            return .notValidated
        }
    }
    
    
    /// - Parameter invitationCode: 동아리 참가 코드
    ///
    /// 유저가 유효한  참가코드를 입력했는지 확인하는 메소드
    func checkedGroupCode(_ invitationCode: String) async -> GroupCodeValidation {
        do {
            let querySnapshot = try await database
                .collection("Group")
                .whereField("invitationCode", isEqualTo: invitationCode)
                .getDocuments()
            return (querySnapshot.isEmpty) ? .notValidated : .validated(querySnapshot.documents.first!.documentID)
        } catch {
            print("checkedJoinGroup error: \(error.localizedDescription)")
            return .notValidated
        }
    }
    
    /// 가입된 동아리인지 확인하는 메소드
    func isJoinedGroup() {
        
    }
}
