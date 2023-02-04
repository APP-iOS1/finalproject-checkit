//
//  GroupStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import UIKit
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
    @Published var groupImage: [String:UIImage] = [:]
    
    let database = Firestore.firestore()
    private let storage = Storage.storage()
    
    private var listener: ListenerRegistration?
    
    
    /// 동아리 데이터에 리스너를 시작하는 메소드
    /// - Parameter user: 현재 로그인한 user의 정보가 담겨있습니다.
    ///
    /// 동아리 데이터의 추가 수정 삭제 변화를 관찰합니다.
    func startGroupListener(_ user: User) {
        let groupId = user.groupID
        self.listener = database.collection("Group").whereField("id", in: groupId)
            .addSnapshotListener{ querySnapshot, error in
            print("메시지 리스너 호출")
            
            guard let snapshot = querySnapshot else {
                print("fetching group error: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    print("동아리 추가")
                case .modified:
                    print("동아리 수정")
                case .removed:
                    print("동아리 제거")
                }
            }
        }
    }
    
    /// 동아리 데이터에 리스너를 종료하는 메소드
    ///
    /// 동아리 데이터의 관찰을 종료합니다.
    func detachListener() {
        listener?.remove()
    }
    
    // MARK: - 동아리를 개설하는 메소드
    /// - Parameter uid: 로그인한사용자의 uid 동아리 방장의 id
    /// - Parameter group: 사용자가 생성한 동아리 인스턴스
    func createGroup(_ user: User, group: Group, image: UIImage) async {
        do {
            try await database.collection("Group")
                .document(group.id)
                .setData([
                    "\(GroupConstants.id)": group.id,
                    "\(GroupConstants.hostID)": group.hostID,
                    "\(GroupConstants.name)": group.name,
                    "\(GroupConstants.invitationCode)": group.invitationCode,
                    "\(GroupConstants.image)": group.image,
                    "\(GroupConstants.description)": group.description,
                    "\(GroupConstants.scheduleID)": group.scheduleID,
                    "\(GroupConstants.memberCount)": group.memberCount
                ])
            
            // FIXME: - position관련 정보는 enum으로 수정 필요
            await createMember(database.collection("Group"), documentID: group.id, uid: user.id, position: "방장")
            await addGroupsInUser(user, joinedGroupId: group.id)
            await createImages(image, path: group.id)
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
    
    /// - Parameter image: 저장할 동아리 이미지
    /// - Parameter path: 저장할 이미지 경로
    ///
    /// 동아리 생성시 동아리 이미지를 스토리지에 저장하는 메소드입니다.
    func createImages(_ image: UIImage, path: String) async {
        let storageRef = storage.reference().child("group_images/\(path)")
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            do {
                _ = try await storageRef.putDataAsync(data, metadata: metadata)
            } catch {
                let code = error as NSError
                print("code: \(code)")
                print("group image upload error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 자신이 속한 동아리 데이터를 가져오는 메소드
    /// - Parameter uid: 로그인한 사용자의 uid
    /// 자신이 속한 동아리의 데이터를 groups 프로퍼티 래퍼에 저장한다.
    func fetchGroups(_ user: User) async {
        // FIXME: - 현재 더미데이터로 유저가 속한 그룹의 id를 선언함
        let groupID: [String] = user.groupID
        print("실행 groupId: \(user.groupID)")
        DispatchQueue.main.async {
            self.groups.removeAll()
        }
        
        if user.groupID.isEmpty {
            return
        }
        
        do {
            let querySnapshot = try await database.collection("Group")
                .whereField("id", in: groupID)
                .getDocuments()
            print("실행22")
            for document in querySnapshot.documents {
                let data = document.data()
                
                let id = data[GroupConstants.id] as? String ?? ""
                let name = data[GroupConstants.name] as? String ?? ""
                let invitationCode = data[GroupConstants.invitationCode] as? String ?? ""
                let image = data[GroupConstants.image] as? String ?? ""
                let hostID = data[GroupConstants.hostID] as? String ?? ""
                let description = data[GroupConstants.description] as? String ?? ""
                let scheduleID = data[GroupConstants.scheduleID] as? [String] ?? []
                let memberCount = data[GroupConstants.memberCount] as? Int ?? 0
                
                do {
                    let image = try await fetchImages("group_images/\(id)")
                    
                    // FIXME: - 유저가 동아리 이미지를 저장하지 않을 경우 다른 디폴트 이미지가 필요
                    DispatchQueue.main.async {
                        if image == nil {
                            self.groupImage[id] = UIImage()
                        } else {
                            self.groupImage[id] = UIImage(data: image!)!
                        }
                    }
                } catch {
                    print("fetch group image error: \(error.localizedDescription)")
                }
                
                let group = Group(id: id,
                                  name: name,
                                  invitationCode: invitationCode,
                                  image: image,
                                  hostID: hostID,
                                  description: description,
                                  scheduleID: scheduleID,
                                  memberCount: memberCount)
                
                DispatchQueue.main.async {
                    self.groups.append(group)
                }
            }
        } catch {
            print("동아리 가져오기 에러: \(error.localizedDescription)")
        }
    }
    
    /// - Parameter path: 동아리 이미지가 저장된 스토리지 경로
    ///
    ///  경로를 기반으로 동아리 이미지를 가져오며 Date 타입으로 이미지를 반환합니다. 따라서 UIImage로 타입 캐스팅을 해야합니다
    func fetchImages(_ path: String) async throws -> Data? {
        return await withCheckedContinuation { continuation in
            let ref = storage.reference().child(path)
            
            ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                continuation.resume(returning: data)
            }
        }
    }
    
    // MARK: - 유저가 동아리에 참가하는 메소드
    /// - Parameter code: 동아리 참가 코드
    /// - Parameter uid: 참가하는 사용자의 uid
    /// - Reuturn Value: 동아리 참가코드 입력시 반환되는 상태
    ///
    ///  유저는 초대받은 코드를 입력하여 동아리에 참가하는 메소드
    ///  이때 Member컬렉션에 직책과 uid정보를 추가해야하며, user 컬렉션에 참가한 동아리id를 추가해야한다.
    func joinGroup(_ code: String, user: User) async -> GroupJoinStatus {
        let status = await checkedGroupCode(code)
        switch status {
        case .validated(let groupId):
            let userGroups: [String] = user.groupID
            if userGroups.contains(groupId) {
                return .alreadyJoined
            }
            
            do {
                try await database.collection("Group")
                    .document(groupId)
                    .collection("Member")
                    .document(user.id)
                    .setData([
                        "uid": user.id,
                        "position": "구성원"
                    ])
                //FIXME: - User를 파라미터의 User로 변경 필요
                await addGroupsInUser(user, joinedGroupId: groupId)
                await addGroupMemberCount(groupId)
                await fetchGroups(user)
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
                .whereField("\(GroupConstants.invitationCode)", isEqualTo: invitationCode)
                .getDocuments()
            return (querySnapshot.isEmpty) ? .notValidated : .validated(querySnapshot.documents.first!.documentID)
        } catch {
            print("checkedJoinGroup error: \(error.localizedDescription)")
            return .notValidated
        }
    }
    
    // MARK: - 가입한 동아리의 id를 UserCollection에 넣는 함수
    func addGroupsInUser(_ user: User, joinedGroupId: String) async {
        do {
            var oldGroups = user.groupID
            print("addGroupsInUser user: \(user.groupID)")
            oldGroups.append(joinedGroupId)
            print("oldGroups: \(oldGroups)")
            try await database.collection("User")
                .document(user.id)
                .updateData([
                    "\(UserConstants.groupID)": oldGroups
                ])
        } catch {
            print("addGroupsInUser error: \(error.localizedDescription)")
        }
    }
    
    /// 동아리에 참가할 시 동아리의 memberCount를 증가시키는 메소드
    /// - Parameter groupdId: 참가할 동아리의 id
    func addGroupMemberCount(_ groupId: String) async {
        let oldUserCount = await getMemberCount(groupId)
        do {
            try await database.collection("Group")
                .document(groupId)
                .updateData([
                    "member_count": oldUserCount + 1,
                ])
        } catch {
            print("addGroupMemberCount error: \(error.localizedDescription)")
        }
    }
    /// 동아리에 참가할 시 참가할 동아리의 멤버 수를 반환하는 메소드
    /// - Parameter groupdId: 참가할 동아리의 id
    func getMemberCount(_ groupId: String) async -> Int {
        do {
            let querySnapshot = try await database.collection("Group")
                .document(groupId)
                .getDocument()
            if !querySnapshot.exists { return 0 }
            let data = querySnapshot.data()!
            let memberCount = data[GroupConstants.memberCount] as? Int ?? 0
            return memberCount
        } catch {
            print("getMemberCount error: \(error.localizedDescription)")
            return 0
        }
    }
}
