//
//  EditGroupView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/09.
//

import SwiftUI
import PhotosUI
import AlertToast

struct EditGroupView: View {
    @EnvironmentObject var groupStores: GroupStore
    @EnvironmentObject var userStores: UserStore
    @EnvironmentObject var scheduleStores: ScheduleStore
    
    @Environment(\.dismiss) var dismiss
    
    @State private var text: String = ""
    @State private var isLoading: Bool = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedData: Data?
    @State private var selectedPhotoData: [UIImage] = []
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    @Binding var toastObj: ToastMessage
    
    @Binding var group: Group
    var oldGroupName: String
    
    var maxGroupNameCount: Int = 15
    var maxGroupDescriptionCount: Int = 40
    
    @State var showAlert: Bool = false
    @State var alertMessage = "글자수 조건을 확인하세요!"
    @State private var isClicked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("동아리 정보 수정하기")
                .font(.system(size: 24, weight: .bold))
            
            // 사진첩, 고른 사진은 selectedItems, selectedPhotoData에 할당
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                ZStack {
                    if groupStores.groupImage[group.id] == nil && selectedPhotoData.isEmpty {
                        Circle()
                            .foregroundColor(Color.myGray)
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                    } else {
                        if selectedPhotoData.isEmpty {
                            Image(uiImage: groupStores.groupImage[group.id]!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                        } else {
                            Image(uiImage: selectedPhotoData.first!) // 하나밖에 없으니깐 first
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                        }
                    }
                }
            }
            // 변화가 있는걸 감지하는 onChange, 변화가 있음 고른거 잔뜩 소매에 집어넣겠다.
            .onChange(of: selectedItems) { newPhotos in
                selectedPhotoData.removeAll()
                for photo in newPhotos {
                    Task {
                        if let data = try? await photo.loadTransferable(type: Data.self),
                           let image = UIImage(data: data){
                            let data = try! await photo.loadTransferable(type: Data.self)
                            selectedData = data
                            selectedPhotoData.append(image)
                        }
                    }
                }
            }
            
            Text("동아리 기본정보")
                .font(.system(size: 18, weight: .medium))
            
            // MARK: - 동아리 이름 텍스트필드
            CustomTextField(
                text: $group.name,
                placeholder: "\(group.name)",
                maximumCount: maxGroupNameCount)
            .font(.system(size: 14, weight: .regular))
            
            // MARK: - 동아리 상세 내용 텍스트필드
            CustomTextField(
                text: $group.description,
                placeholder: "\(group.description)",
                maximumCount: maxGroupDescriptionCount)
            .font(.system(size: 14, weight: .regular))
            
            // MARK: - 동아리 편집하기 버튼
            Button {
                if isClicked {
                    return
                }
                
                isClicked.toggle()
                isLoading.toggle()
                
                // 이미지가 변경됨
                if !selectedPhotoData.isEmpty {
                    print("이미지가 변경됨")
                    imageChanged()
                }
                
                let newGroup = Group(id: group.id,
                                     name: group.name,
                                     invitationCode: group.invitationCode,
                                     image: group.image,
                                     hostID: group.hostID,
                                     description: group.description,
                                     scheduleID: group.scheduleID,
                                     memberLimit: group.memberLimit)

                Task {
                    await groupStores.editGroup(newGroup: newGroup, newImage: selectedPhotoData.first ?? groupStores.groupImage[group.id] ?? UIImage())
                    
                    if oldGroupName != newGroup.name { // 스케줄내 모든 동아리 이름 변경
                        print("여기 호출: \(newGroup.name)")
                        await scheduleStores.updateScheduleGroupName(newGroup.name, scheduleIdList: group.scheduleID)
                        await scheduleStores.fetchRecentSchedule(groupName: newGroup.name)
                    }
                    
                    let index = self.groupStores.groups.firstIndex{ $0.id == group.id }
                    self.groupStores.groups[index ?? -1] = newGroup
                    
                    toastObj.message = "동아리 수정이 완료되었습니다."
                    toastObj.type = .competion
                    showToast.toggle()
                    
                    self.groupStores.groupDetail = newGroup
                    if !selectedPhotoData.isEmpty {
                        self.groupStores.groupImage[group.id] = selectedPhotoData.first!
                    }
                    
                    dismiss()
                }
                
            } label: {
                if isLoading {
                    ProgressView()
                        .modifier(GruopCustomButtonModifier())
                } else {
                    Text("저장 하기")
                        .modifier(GruopCustomButtonModifier())
                }
            }
            .disabled(!isCountValid())
            .onTapGesture{
                showAlert.toggle()
            }
            
        }
        .padding(40)
        .presentationDragIndicator(.visible)
    }
    
    private func imageChanged() {
        // 동아리 수정시 디스크에 있는 이미지 삭제
        guard let directory = ImageCacheManager.cachesDirectory else {
            print("디스크에 있는 이미지 경로 읽기 실패")
            toastObj.message = "알수 없는 오류입니다."
            toastObj.type = .failed
            return
        }
        /// 이미지 수정시 해야할일
        /// 캐시 비우기
        /// 디스크 비우기
//        var filePath = URL(fileURLWithPath: directory.path)
//        filePath.appendPathComponent(group.id)
//
//        print("filePath: \(filePath)")
//
//        do {
//            try ImageCacheManager.fileManager.removeItem(atPath: filePath.path)
//            print("원래 이미지 삭제 성공")
//        } catch {
//            print("이미지 삭제 실패: \(error.localizedDescription)")
//            toastObj.message = "디바이스에 존재하는 이미지를 삭제하는데 실패하였습니다."
//            toastObj.type = .failed
//            dismiss()
//            return
//        }
        
        // 메모리 캐시도 새로운 이미지로 갈아치우기
        // 메모리를 다 비우고 새로 끼워넣기
        ImageCacheManager.shared.removeAllObjects()
        let cacheKey = NSString(string: group.id)
        ImageCacheManager.setObject(image: selectedPhotoData.first!, forKey: cacheKey, type: .memory)
        
        //디스크에 쓰기
        //ImageCacheManager.setObject(image: UIImage(), forKey: cacheKey, type: .disk(filePath), data: selectedData!)
        
        //groupStores.readImage(group.id)
    }
    
    //MARK: - isCountValid
    /// 글자수 조건이 맞는지 확인하는 메서드입니다.
    private func isCountValid() -> Bool {
        if group.name.isEmpty || group.description.isEmpty {
            DispatchQueue.main.async{
                self.alertMessage = "한 글자 이상 입력해야 합니다!"
            }
            return false
        }
        
        if group.name.count > maxGroupNameCount || group.description.count > maxGroupDescriptionCount {
            DispatchQueue.main.async{
                self.alertMessage = "입력 가능한 글자 수를 넘었습니다!"
            }
            return false
        }
        
        return true
    } // - isCountValid
}

//struct EditGroupView_Previews: PreviewProvider {
//    @State static var showToast: Bool = false
//    @State static var toastMessage: String = ""
//
//    static var previews: some View {
//        EditGroupView(showToast: $showToast, toastMessage: $toastMessage)
//            .environmentObject(GroupStore())
//    }
//}
