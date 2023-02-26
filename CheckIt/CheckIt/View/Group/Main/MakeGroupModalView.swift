//
//  MakeGroupModalView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI
import PhotosUI
import AlertToast

struct MakeGroupModalView: View {
    @EnvironmentObject var groupStores: GroupStore
    @EnvironmentObject var userStores: UserStore
    
    @Environment(\.presentations) private var presentations
    
    @State private var groupName: String = ""
    @State private var groupDescription: String = ""
    @State private var isJoined: Bool = false
    @State private var text: String = ""
    @State private var isLoading: Bool = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotoData: [UIImage] = []
    
    @State private var isClicked: Bool = false
    @State private var isAgreeTerms: Bool = false
    @State private var isClickTerms: Bool = false
    
    @Binding var showToast: Bool
    
    var maxGroupNameCount: Int = 15
    var maxGroupDescriptionCount: Int = 40
    
    @State var showAlert: Bool = false
    @State var alertMessage = "글자수 조건을 확인하세요!"
    
    @Binding var toastObj: ToastMessage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("동아리 개설하기")
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
                    .font(.system(size: 17, weight: .medium))
                
                // MARK: - 동아리 이름 텍스트필드
                CustomTextField(
                    text: $groupName,
                    placeholder: "동아리 이름을 입력해주세요! (필수)",
                    maximumCount: maxGroupNameCount)
                .font(.system(size: 14, weight: .regular))
                
                // MARK: - 동아리 상세 내용 텍스트필드
                CustomTextField(
                    text: $groupDescription,
                    placeholder: "동아리의 상세 내용을 적어주세요. (필수)",
                    maximumCount: maxGroupDescriptionCount)
                .font(.system(size: 14, weight: .regular))
                // "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다."
                HStack {
                    Toggle(isOn: $isAgreeTerms) {
                        Text("동아리 개설 준수 사항 동의")
                    }
                    .toggleStyle(iOSCheckboxToggleStyle())
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        isClickTerms.toggle()
                    } label: {
                        if isClickTerms {
                            Image(systemName: "chevron.up")
                        } else {
                            Image(systemName: "chevron.down")
                        }
                    }
                    .foregroundColor(.black)
                }
                .padding(.bottom, 0)
                
                if isClickTerms {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("부적절하거나 불쾌감을 줄 수 있는 이미지 금지")
                        Text("부적절하거나 불쾌감을 줄 수 있는 이름 금지")
                        Text("부적절하거나 불쾌감을 줄 수 있는 상세 내용 금지")
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.top, 0)
                }
                
                
                
                // MARK: - 동아리 개설하기 버튼
                Button {
                    
                    let group = Group(id: UUID().uuidString,
                                      name: groupName,
                                      invitationCode: Group.randomCode,
                                      image: UUID().uuidString,
                                      //image: "example",
                                      hostID: userStores.user?.id ?? "N/A",
                                      description: groupDescription,
                                      scheduleID: [],
                                      memberLimit: 8,
                                      isStop: false
                    )
                    Task {
                        if isClicked {
                            return
                        }
                        let result = await groupStores.canUseGroupsName(groupName: groupName)
                        if !result {
                            print("여기로 이동")
                            self.alertMessage = "동아리 이름이 중복됩니다.!"
                            showAlert.toggle()
                            return
                        }
                        
                        
                        guard let user = userStores.user else { return }
                        isLoading.toggle()
                        isClicked.toggle()
                        
                        await groupStores.createGroup(user, group: group, image: selectedPhotoData.first ?? UIImage())
                        await groupStores.addGroupsInUser(user, joinedGroupId: group.id)
                        await userStores.fetchUser(user.id)
                        
                        toastObj.message = "동아리 생성이 완료되었습니다."
                        toastObj.type = .competion
                        
                        showToast.toggle()
                        
                        presentations.forEach {
                            $0.wrappedValue = false
                        }
                        let newGroups = Group.sortedGroup(groupStores.groups, userId: user.id)
                        groupStores.groups = newGroups
                        isClicked.toggle()
                        
                    }
                    
                } label: {
                    if isLoading {
                        ProgressView()
                            .modifier(GroupCreateButton(disable: false))
                    } else {
                        Text("동아리 개설하기")
                            .modifier(GroupCreateButton(disable: !isAgreeTerms))
                    }
                }
                .disabled(!isCountValid() || !isAgreeTerms)
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
    }
    
    //MARK: - isCountValid
    /// 글자수 조건이 맞는지 확인하는 메서드입니다.
    private func isCountValid() -> Bool {
        print("groupName: \(groupName)")
        print("groupDescription: \(groupDescription)")
        if groupName.isEmpty || groupDescription.isEmpty {
            DispatchQueue.main.async{
                self.alertMessage = "한 글자 이상 입력해야 합니다!"
            }
            print("1")
            return false
        }
        
        if groupName.count > maxGroupNameCount || groupDescription.count > maxGroupDescriptionCount {
            DispatchQueue.main.async{
                self.alertMessage = "입력 가능한 글자 수를 넘었습니다!"
            }
            print("2")
            return false
        }
        if !isAgreeTerms {
            DispatchQueue.main.async{
                self.alertMessage = "준수 사항을 동의해주세요."
            }
            return false
        }
        
        print("3")
        return true
    } // - isCountValid
}

//struct MakeGroupModalView_Previews: PreviewProvider {
//    @State static var showToast: Bool = false
//    @State static var toastMessage: String = ""
//    
//    static var previews: some View {
//        MakeGroupModalView(showToast: $showToast, toastMessage: $toastMessage, toastObj: .constant(ToastMessage(message: "", type: .competion)))
//            .environmentObject(GroupStore())
//    }
//}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")

                configuration.label
            }
        })
    }
}
