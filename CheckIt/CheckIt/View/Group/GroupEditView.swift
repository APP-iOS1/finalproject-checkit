//
//  GroupEditView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/09.
//

import SwiftUI
import PhotosUI
import AlertToast

struct GroupEditView: View {
    @EnvironmentObject var groupStores: GroupStore
    @EnvironmentObject var userStores: UserStore
    
    @State private var changedGroupName: String = ""
    @State private var changedGroupDescription: String = ""
    @State private var text: String = ""
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotoData: [UIImage] = []
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    var maxGroupNameCount: Int = 15
    var maxGroupDescriptionCount: Int = 40
    
    @State var showAlert: Bool = false
    @State var alertMessage = "글자수 조건을 확인하세요!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("동아리 정보 수정하기")
                .font(.system(size: 24, weight: .bold))
            
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                ZStack {
                    if selectedPhotoData.isEmpty {
                        Circle().fill(Color.myLightGray)
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(uiImage: selectedPhotoData.first!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                    }
                }
            }
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
                text: $changedGroupName,
                placeholder: "동아리 이름을 입력해주세요! (필수)",
                maximumCount: maxGroupNameCount)
            .font(.system(size: 14, weight: .regular))
            
            // MARK: - 동아리 상세 내용 텍스트필드
            CustomTextField(
                text: $changedGroupDescription,
                placeholder: "동아리의 상세 내용을 적어주세요. (필수)",
                maximumCount: maxGroupDescriptionCount)
            .font(.system(size: 14, weight: .regular))
            
            // MARK: - 동아리 편집하기 버튼
            Button {
                
//                let group = Group(id: UUID().uuidString,
//                                  name: groupName,
//                                  invitationCode: UUID().uuidString,
//                                  image: "example",
//                                  hostID: userStores.user?.id ?? "N/A",
//                                  description: groupDescription,
//                                  scheduleID: [],
//                                  memberLimit: 8)
//                Task {
//                    let canCreate = await groupStores.canUseGroupsName(groupName: groupName)
//                    if canCreate {
//                        print("실행?")
//                        await groupStores.createGroup(userStores.user!, group: group, image: selectedPhotoData.first ?? UIImage())
//                        await groupStores.addGroupsInUser(userStores.user!, joinedGroupId: group.id)
//                        await userStores.fetchUser(userStores.user!.id)
//                        showToast.toggle()
//                        toastMessage = "동아리 생성이 완료되었습니다."
//                    }
//                    else {
//                        print("중복")
//                        showToast.toggle()
//                        toastMessage = "동아리 이름이 중복됩니다."
//                    }
//
//
//                    print("user의 groupid: \(userStores.user?.groupID)")
//                }
                
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
        if changedGroupName.isEmpty || changedGroupDescription.isEmpty {
            DispatchQueue.main.async{
                self.alertMessage = "한 글자 이상 입력해야 합니다!"
            }
            return false
        }
        
        if changedGroupName.count > maxGroupNameCount || changedGroupDescription.count > maxGroupDescriptionCount {
            DispatchQueue.main.async{
                self.alertMessage = "입력 가능한 글자 수를 넘었습니다!"
            }
            return false
        }
        
        return true
    } // - isCountValid
}

struct GroupEditView_Previews: PreviewProvider {
    @State static var showToast: Bool = false
    @State static var toastMessage: String = ""
    
    static var previews: some View {
        GroupEditView(showToast: $showToast, toastMessage: $toastMessage)
            .environmentObject(GroupStore())
    }
}
