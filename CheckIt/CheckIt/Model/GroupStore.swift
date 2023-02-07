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
    case fulled
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
    func startGroupListener(_ userStore: UserStore) {
        // FIXME: - 현재 동아리를 가져오는 기준은 User의 groupId필드로 가져온다.
        /// 그러나 동아리를 추가하고 나서는 User의 groupdId는 방금 추가된 동아리의 id가 담기지 않는다. 그래서 일단은 동아리 추가시
        /// 바로 @Published배열에 넣는다
        print("startGroupListener 호출")
        
        self.listener = database.collection("Group").addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            print("동아리 리스너 호출")
            
            guard let snapshot = querySnapshot else {
                print("fetching group error: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    self.readGroup(diff.document.data(), userGroupIdList: userStore.user!.groupID)
                case .modified:
                    print("동아리 수정")
                    // FIXME: 오류 발생 위험
                    self.readGroup(diff.document.data(), userGroupIdList: userStore.user!.groupID)
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
        self.groups.removeAll()
        self.groupImage = [:]
        listener?.remove()
    }
    
    /// 동아리의 데이터를 읽는 메소드입니다.
    /// - Parameter group: 읽을 동아리의 데이터
    ///
    /// 파라미터로 들어온 동아리를 스토어의 @Published groups 프로퍼티에 저장합니다.
    func readGroup(_ group: [String:Any], userGroupIdList: [String]) {
        let id = group[GroupConstants.id] as? String ?? ""
        print("groupid: \(id)")
        guard userGroupIdList.contains(id) else { return }
        if self.groups.contains(where: {$0.id == id}) {
            return
        }
        
        print("동아리 추가")
        
        let name = group[GroupConstants.name] as? String ?? ""
        let invitationCode = group[GroupConstants.invitationCode] as? String ?? ""
        let image = group[GroupConstants.image] as? String ?? ""
        let hostID = group[GroupConstants.hostID] as? String ?? ""
        let description = group[GroupConstants.description] as? String ?? ""
        let scheduleID = group[GroupConstants.scheduleID] as? [String] ?? []
        let memberLimit = group[GroupConstants.memberLimit] as? Int ?? 0
        
        let group = Group(id: id,
                          name: name,
                          invitationCode: invitationCode,
                          image: image,
                          hostID: hostID,
                          description: description,
                          scheduleID: scheduleID,
                          memberLimit: memberLimit)
        
        readImages("group_images/\(id)", groupId: group.id)
        
        self.groups.append(group)
        
    }
    
    ///  동아리 이미지를 가져오는 메소드
    /// - Parameter path: 동아리 이미지가 저장된 스토리지 경로
    /// - Parameter groupdId: 동아리 id
    ///
    ///  경로를 기반으로 스토리지로 부터 동아리 이미지를 가져옵니다. 가져온 이미지는 스토어의 groupImage 딕셔너리의 value에 저장됩니다.
    ///  이 딕셔너리의 key는 해당 동아리의 id 입니다.
    func readImages(_ path: String, groupId: String) {
        let ref = storage.reference().child(path)
        
        ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("readImages error: \(error.localizedDescription)")
            } else {
                guard let data else { return }
                print("readImage Success")
                self.groupImage[groupId] = UIImage(data: data)
            }
        }
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
                    "\(GroupConstants.memberLimit)": group.memberLimit
                ])
            DispatchQueue.main.async {
                self.groups.append(group)
            }
            
            // FIXME: - position관련 정보는 enum으로 수정 필요
            await createMember(database.collection("Group"), documentID: group.id, uid: user.id, position: "방장")
            
            await createImages(image, path: group.id)
            
            readImages("group_images/\(group.id)", groupId: group.id)
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
                let memberLimit = data[GroupConstants.memberLimit] as? Int ?? 0

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
                                  memberLimit: memberLimit)

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
            
            let currentMemberCount = await getMemberCount(groupId)
            guard currentMemberCount < 8 else { return .fulled }
            
            do {
                try await database.collection("Group")
                    .document(groupId)
                    .collection("Member")
                    .document(user.id)
                    .setData([
                        "uid": user.id,
                        "position": "구성원"
                    ])
                await addGroupsInUser(user, joinedGroupId: groupId)
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
            print("newGroups: \(oldGroups)")
            try await database.collection("User")
                .document(user.id)
                .updateData([
                    "\(UserConstants.groupID)": oldGroups
                ])
        } catch {
            print("addGroupsInUser error: \(error.localizedDescription)")
        }
    }
    /// 동아리에 참가할 시 참가한 동아리의 총 멤버 수를 반환하는 메소드
    /// - Parameter groupdId: 참가할 동아리의 id
    /// - Returns Int: 현재 동아리의 인원 수
    func getMemberCount(_ groupId: String) async -> Int {
        do {
            let querySnapshot = try await database.collection("Group")
                .document(groupId)
                .collection("Member")
                .getDocuments()
            return querySnapshot.documents.count
        } catch {
            print("getMemberCount error: \(error.localizedDescription)")
            return 0
        }
    }
    
    /// 동아리원이 동아리를 나갈때 호출되는 메소드
    /// - Parameter uid: 나갈 동아리원의 uid
    /// - Parameter groudId: 동아리원이 나가는 uid
    ///
    /// 동아리를 나갈때 필요한 처리
    /// 1. group의 member collection에서 나간 동아리원 다큐먼트 삭제
    /// 2. 나간 동아리원의 groupId에서 필드 제거
    func removeMember(_ uid: String, groupdId: String) async {
        do {
            // 1.
           try await database.collection("Group").document(groupdId)
                .collection("Member")
                .document(uid)
                .delete()
            // 2.
        } catch {
            print("GroupStore removeMember error: \(error.localizedDescription)")
        }
    }
}
