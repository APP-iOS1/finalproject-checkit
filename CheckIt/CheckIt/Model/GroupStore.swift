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
    case newJoined(String)
    case notValidated
    case fulled
}

enum GroupCodeValidation {
    case validated(String)
    case notValidated
}

enum GroupGetError: Error {
    case getGroupFailed
    case notExisted
}

class GroupStore: ObservableObject {
    @Published var groups: [Group] = []
    @Published var groupDetail: Group = Group.sampleGroup
    
    @Published var groupImage: [String:UIImage] = [:]
    
    let database = Firestore.firestore()
    private let storage = Storage.storage()
    
    private var listener: ListenerRegistration?
    
    
    /// 동아리 데이터에 리스너를 시작하는 메소드
    /// - Parameter user: 현재 로그인한 user의 정보가 담겨있습니다.
    ///
    /// 동아리 데이터의 추가 수정 삭제 변화를 관찰합니다.
    func startGroupListener(_ group: Group) {
        // FIXME: - 현재 동아리를 가져오는 기준은 User의 groupId필드로 가져온다.
        /// 그러나 동아리를 추가하고 나서는 User의 groupdId는 방금 추가된 동아리의 id가 담기지 않는다. 그래서 일단은 동아리 추가시
        /// 바로 @Published배열에 넣는다
        print("startGroupListener 호출")
        
        self.listener = database.collection("Group").whereField("id", isEqualTo: group.id).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("fetching group error: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    self.readGroup(diff.document.data())
                case .modified:
                    print("동아리 수정")
                    // FIXME: 오류 발생 위험
                    self.updateGroup(diff.document.data())
                case .removed:
                    print("동아리 제거")
                    self.removeDetailGroup()
                }
            }
        }
    }
    
    /// 동아리 데이터에 리스너를 종료하는 메소드
    ///
    /// 동아리 데이터의 관찰을 종료합니다.
    func detachListener() {
        print("detachListener 호출")
        self.groupDetail = Group.sampleGroup
        listener?.remove()
    }
    
    /// 동아리의 데이터를 읽는 메소드입니다.
    /// - Parameter group: 읽을 동아리의 데이터
    ///
    /// 파라미터로 들어온 동아리를 스토어의 @Published groups 프로퍼티에 저장합니다.
    func readGroup(_ group: [String:Any]) {
        print("동아리 추가")
        
        let id = group[GroupConstants.id] as? String ?? ""
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
        
        self.groupDetail = group
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
    // FIXME: - 중복 코드 수정 필요
    func updateGroup(_ group: [String:Any]) {
        print("동아리 수정")
        
        let id = group[GroupConstants.id] as? String ?? ""
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
        
        self.groupDetail = group
        let updateGroupIndex = self.groups.firstIndex {$0.id == group.id } ?? -1
        self.groups[updateGroupIndex] = group
    }
    
    /// 동아리 삭제하기를 눌렀을때 호출되는 메소드
    func removeDetailGroup() {
        print("removeDetailGroup 호출")
        self.groupDetail = Group.sampleGroup
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
    // MARK: - 동아리 생성 시 중복을 확인하는 메소드
    func canUseGroupsName(groupName: String) async -> Bool {
        do {

            let querySnapshot = try await database.collection("Group").whereField("name", isEqualTo: groupName).getDocuments()
            
            if querySnapshot.isEmpty {
                return true
            }
            else {
                return false
            }
        }
        catch {
            print("checkGroupsName error: \(error.localizedDescription)")
        }
        return false
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
                            //self.groupImage[id] = UIImage()
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
    
    /// 초대코드를 입력하여 동아리에 참가시 참가한 동아리의 데이터를 불러오는 메소드
    /// - Parameter groupId: 참가한 동아리의 id
    func getGroup(_ groupId: String) async -> Result<Group, GroupGetError> {
        do {
            let documentSnapshot = try await database.collection("Group").document(groupId)
                .getDocument()
            guard documentSnapshot.exists == true else { return .failure(GroupGetError.notExisted)}
            
            let group = documentSnapshot.data()!
            
            let id = group[GroupConstants.id] as? String ?? ""
            let name = group[GroupConstants.name] as? String ?? ""
            let invitationCode = group[GroupConstants.invitationCode] as? String ?? ""
            let image = group[GroupConstants.image] as? String ?? ""
            let hostID = group[GroupConstants.hostID] as? String ?? ""
            let description = group[GroupConstants.description] as? String ?? ""
            let scheduleID = group[GroupConstants.scheduleID] as? [String] ?? []
            let memberLimit = group[GroupConstants.memberLimit] as? Int ?? 0
            
            let newGroup = Group(id: id,
                              name: name,
                              invitationCode: invitationCode,
                              image: image,
                              hostID: hostID,
                              description: description,
                              scheduleID: scheduleID,
                              memberLimit: memberLimit)
            
            readImages("group_images/\(id)", groupId: newGroup.id)
            
            return .success(newGroup)
        } catch {
            print("getGroup error: \(error.localizedDescription)")
            return .failure(GroupGetError.getGroupFailed)
        }
    }
    /// 재생성된 동아리의 초대코드를 업데이트 하는 메소드입니다.
    /// - Parameter groupId: 재생성할 동아리 id
    /// - Parameter newInvitationCode: 재생성된 초대코드
    func updateInvitationCode(_ groupId: String, newInvitationCode: String) async {
        do {
           try await database.collection("Group").document(groupId)
                .updateData([
                    GroupConstants.invitationCode: newInvitationCode
                ])
        } catch {
            print("updateInvitationCode error: \(error.localizedDescription)")
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
                
                return .newJoined(groupId)
                
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
    // MARK: - REMOVE
    
    /// 동아리를 삭제하는 메소드
    /// - Parameter groupdId: 삭제할 동아리의 id
    /// - Parameter uidList: 삭제할 동아리 멤버들의 id 리스트
    ///
    /// 동아리를 삭제하는 절차는 다음과 같다.
    /// 1. 동아리 컬렉션 내 member 컬렉션 삭제 -> 컬렉션내 모든 document를 삭제해야 함
    /// 2. 동아리가 가진 모든 스케줄을 삭제
    /// 3. 스케줄에 연관된 컬렉션 삭제
    /// 4. 동아리 컬렉션 document 삭제
    /// 5. 방장 및 가입한 모든 유저의 필드에서 groupId제거
    /// 6. 스토리지내 이미지 삭제
    func removeGroup(groupId: String, uidList: [String]) async {
        let docRef = database.collection("Group").document(groupId)
        
        await removeMemberCollection(ref: docRef, uidList: uidList) // 1.
        
        do {
            try await docRef.delete() // 4.
        } catch {
            print("Groupstore removeGroup error: \(error.localizedDescription)")
        }
        await removeGroupIdAllMember(groupId: groupId, uidList: uidList) // 5.
        await removeGroupImage(groupId) // 6.
    }
    /// 동아리의 MemberCollection을 삭제하는 메소드
    /// - Parameter ref: 삭제할 동아리의 reference
    /// - Parameter uidList: 동아리에 속한 유저들의 id들
    func removeMemberCollection(ref: DocumentReference, uidList: [String]) async {
        do {
            for uid in uidList {
                try await ref
                    .collection("Member")
                    .document(uid)
                    .delete()
            }
        } catch {
            print("Groupstore removeAllMembers error: \(error.localizedDescription)")
        }
    }
    /// 동아리에 가입된 모든 유저의 groupId리스트에서 삭제된 동아리를 제거하는 메소드
    /// - Parameter groupdId: 삭제할 동아리의 id
    /// - Parameter uidList: 삭제할 동아리 멤버들의 id 리스트
    func removeGroupIdAllMember(groupId: String, uidList: [String]) async {
        for uid in uidList {
            await removeGroupId(groupId, uid: uid)
        }
    }
    
    /// 동아리원이 동아리를 나갈때 호출되는 메소드
    /// - Parameter uid: 나갈 동아리원의 uid
    /// - Parameter groudId: 동아리원이 나가는 uid
    ///
    /// 동아리를 나갈때 필요한 처리
    /// 1. group의 member collection에서 나간 동아리원 다큐먼트 삭제
    /// 2. 나간 동아리원의 groupId에서 필드 제거
    /// 3. 동아리를 나갔다는 애니메이션 + 뒤로가기
    func removeMember(_ uid: String, groupdId: String) async {
        do {
            // 1.
           try await database.collection("Group").document(groupdId)
                .collection("Member")
                .document(uid)
                .delete()
            // 2.
            await removeGroupId(groupdId, uid: uid)
        } catch {
            print("GroupStore removeMember error: \(error.localizedDescription)")
        }
    }
    
    /// 동아리를 강퇴당하거나 나갈시 호출되는 메소드
    /// - Parameter groupdId 삭제할 멤버가 속해 있는 동아리
    /// - Parameter uid 삭제할 멤버의 uid
    ///
    /// 동아리원이 동아리를 나가거나 강퇴당할 시 user 컬렉션의 groupId 배열에 동아리 id를 제거하는 역할을 합니다.
    func removeGroupId(_ groupId: String, uid: String) async {
        do {
            let document = try await database.collection("User").document(uid).getDocument()
            guard document.exists == true else { return }
            
            let data = document.data()!
            let groupIdList = data["group_id"] as? [String] ?? []
            
            let newList = groupIdList.filter{$0 != groupId}
            
            try await database.collection("User").document(uid)
                .updateData([
                    "group_id": newList
                ])
            
        } catch {
            print("removeGroupId error: \(error.localizedDescription)")
        }
    }
    /// 동아리의 이미지를 삭제하는 메소드입니다.
    /// - Parameter groupId: 삭제할 동아리 id
    func removeGroupImage(_ groupId: String) async {
        let path = "group_images/\(groupId)"
        let imageRef = storage.reference().child(path)
        
        do {
            try await imageRef.delete()
        } catch {
            print("removeGroupImage error: \(error.localizedDescription)")
        }
    }
    
    /// 동아리 컬렉션에서 일정을 삭제하는 메소드
    /// - Parameter groupId: 삭제할 일정이 속해있는 동아리
    /// - Parameter scheduleList: 현재 동아리에 속한 일정들
    /// - Parameter scheduleId: 삭제할 일정
    /// - Returns: 동아리에서 삭제될 일정이 제거된 데이터 리스트
    func removeScheduleInGroup(_ groupId: String, scheduleList: [Schedule], scheduleId: String) async -> [Schedule] {
        var newScheduleIdList = scheduleList.map {$0.id }
        newScheduleIdList.removeAll {$0 == scheduleId }
        
        var newScheduleList = scheduleList.filter{$0.id != scheduleId}
        
        do {
            try await database.collection("Group").document(groupId)
                .updateData([
                    "schedule_id": newScheduleIdList
                ])
            return newScheduleList
        } catch {
            print("removeScheduleInGroup error: \(error.localizedDescription)")
        }
        return newScheduleList
    }
    
    // DB에 바뀐 Group을 반영하는 친구
    // 스토리지에 따로 반영을 하기위해서 newImage
    func editGroup(newGroup: Group, newImage: UIImage) async {
        do {
            try await database.collection("Group")
                .document(newGroup.id)
                .updateData([
                    // 파이어베이스는 항상 키:값으로 받아옴
                    GroupConstants.name: newGroup.name,
                    GroupConstants.image: newGroup.image, // group.id로 불러와서 사실상 필요없음
                    GroupConstants.description: newGroup.description
                ])
            // 스토리지에 새로 업로드
            await createImages(newImage, path: newGroup.id)
            
            // 리스너를 달아놔서 패치 필요없음
            // 네트워트 통신이 느려서 바로바로 바꿔줄 수 없어서 await를 붙인다.
        } catch {
            print("\(error.localizedDescription)")
            
            return
        }
    }
    
}
