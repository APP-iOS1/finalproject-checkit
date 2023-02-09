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
    @Environment(\.dismiss) var dismiss
    
    @State private var text: String = ""
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotoData: [UIImage] = []
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    @Binding var group: Group
    
    var maxGroupNameCount: Int = 15
    var maxGroupDescriptionCount: Int = 40
    
    @State var showAlert: Bool = false
    @State var alertMessage = "글자수 조건을 확인하세요!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("동아리 정보 수정하기")
                .font(.system(size: 24, weight: .bold))
            
            // 사진첩, 고른 사진은 selectedItems, selectedPhotoData에 할당
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                ZStack {
                    // 고른게 0개라는 뜻
                    if selectedPhotoData.isEmpty {
                        // 바뀐게 없으니깐 옛날 사진 보여줌
                        // FIXME: - 강제 언래핑을 옵셔널로 고치기
                        Image(uiImage: groupStores.groupImage[group.id]!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                        // 사진 하나 골랐다.
                    } else {
                        Image(uiImage: selectedPhotoData.first!) // 하나밖에 없으니깐 first
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
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
                showToast.toggle()
                toastMessage = "동아리 수정이 완료되었습니다."

                let newGroup = Group(id: group.id,
                                     name: group.name,
                                     invitationCode: group.invitationCode,
                                     image: group.image,
                                     hostID: group.hostID,
                                     description: group.description,
                                     scheduleID: group.scheduleID,
                                     memberLimit: group.memberLimit)

                Task {
                    await groupStores.editGroup(newGroup: newGroup, newImage: selectedPhotoData.first ?? groupStores.groupImage[group.id]!)
                    
                    self.groupStores.groupDetail = newGroup
                    
                    let index = self.groupStores.groups.firstIndex{ $0.id == group.id }
                    self.groupStores.groups[index ?? -1] = newGroup

                    toastMessage = "동아리 수정이 완료되었습니다."
                    dismiss()
                }
                
            } label: {
                Text("동아리 편집하기")
                    .modifier(GruopCustomButtonModifier())
            }
            .disabled(!isCountValid())
            .onTapGesture{
                showAlert.toggle()
            }
            
        }
        .padding(40)
        .presentationDragIndicator(.visible)
        .toast(isPresenting: $showAlert){
            AlertToast(displayMode: .alert, type: .error(.red), title: alertMessage)
        }
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
