//
//  CategoryView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI
import GoogleMobileAds
import AlertToast

struct CategoryView: View {
    @State var clickedIndex: Int = 0
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var memberStore: MemberStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isCheckExsit: Bool = false
    @State private var isRemoveGroup: Bool = false
    @State private var isEditGroup: Bool = false
    @State private var isGenerateCode: Bool = false
    @State var isGroupManager: Bool = false
    @State private var isScheduleLoading: Bool = true
    @State private var isFirstFetch: Bool = false
    @State var isLoading: Bool = false
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    @Binding var toastObj: ToastMessage
    
    var group: Group
    @State private var changedGroup: Group = Group.sampleGroup
    
    // FIXME: - 현재는 방장인지 아닌지만 여부를 나타내는데 운영진도 고려해야함
    /// 현재 동아리가 자신이 방장인지 확인하는 연산 프로퍼티
    /// true값이면 자신이 방장이며 fasle이면 방장이 아님
    var isHost: Bool {
        group.hostID == userStore.user?.id ?? ""
    }
    
    var body: some View {
        ZStack {
            VStack {
              admob()
                HStack(spacing: 20) {
              
     
                    VStack(spacing: 5) {
                        //동아리 일정
                        VStack {
                            Text("동아리 일정")
                        }
                        .onTapGesture {
                            clickedIndex = 0
                        }
                        .foregroundColor(clickedIndex == 0 ? .primary : .gray)
                        .font(clickedIndex == 0 ? .system(size: 16).bold(): .system(size: 16))
                        if clickedIndex == 0 {
                            Capsule()
                                .foregroundColor(.primary)
                                .frame(width: 90, height: 2)
                        } else {
                            Capsule()
                                .foregroundColor(.white)
                                .frame(width: 90, height: 2)
                        }
                    }
                    
                    VStack(spacing: 5) {
                        //출석부
                        VStack {
                            Text("출석부")
                        }
                        .onTapGesture {
                            clickedIndex = 1
                        }
                        .foregroundColor(clickedIndex == 1 ? .primary : .gray)
                        .font(clickedIndex == 1 ? .system(size: 16).bold(): .system(size: 16))
                        if clickedIndex == 1 {
                            Capsule()
                                .foregroundColor(.primary)
                                .frame(width: 60, height: 2)
                        } else {
                            Capsule()
                                .foregroundColor(.white)
                                .frame(width: 60, height: 2)
                        }
                    }
                    
                    VStack(spacing: 5) {
                        //동아리 정보
                        VStack {
                            Text("동아리 정보")
                        }
                        .onTapGesture {
                            clickedIndex = 2
                        }
                        .foregroundColor(clickedIndex == 2 ? .primary : .gray)
                        .font(clickedIndex == 2 ? .system(size: 16).bold(): .system(size: 16))
                        if clickedIndex == 2 {
                            Capsule()
                                .foregroundColor(.primary)
                                .frame(width: 90, height: 2)
                        } else {
                            Capsule()
                                .foregroundColor(.white)
                                .frame(width: 90, height: 2)
                        }
                    }
                }
                .padding(.vertical, 20)
                
                
                if clickedIndex == 0 {
                    GroupScheduleView(group: groupStore.groupDetail, isGroupManager: $isGroupManager, isScheduleLoading: $isScheduleLoading)
                } else if clickedIndex == 1 {
                    AttendanceStatusView(isGroupManager: $isGroupManager, group: group, scheduleIDList: group.scheduleID, hostId: group.hostID)
                } else if clickedIndex == 2 {
                    GroupInformationView(group: groupStore.groupDetail)
                }
                
                Spacer()
                
            } // - VStack
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.8)
                    LottieView(filename: "ThirdIndicator", completion: { value in
                        print(value, "로티애니메이션")
                    }, toFrame: 120)
                    .frame(width: 150, height: 150)
                }
            }
            
        }
        .navigationTitle("\(group.name)")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if isHost {
                        Section("동아리") {
                            Button {
                                isEditGroup.toggle()
                            } label: {
                                Label("동아리 정보 수정하기", systemImage: "highlighter")
                            }
                            
                            Button(role: .destructive) {
                                isRemoveGroup.toggle()
                            } label: {
                                Label("동아리 삭제하기", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Section("초대코드") {
                            ShareLink(item: group.invitationCode) {
                                Label("초대 링크 공유하기", systemImage: "square.and.arrow.up")
                            }
                            Button {
                                isGenerateCode.toggle()
                            } label: {
                                Label("초대 코드 재생성하기", systemImage: "arrow.triangle.2.circlepath")
                            }
                        }
                        
                    } else {
                        Section {
                            Button(role: .destructive) {
                                isCheckExsit.toggle()
                            } label: {
                                Label("동아리 나가기", systemImage: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .sheet(isPresented: $isEditGroup) {
            EditGroupView(showToast: $showToast, toastMessage: $toastMessage, toastObj: $toastObj, group: $changedGroup, oldGroupName: group.name)
                .presentationDetents([.height(600)])
        }
        .toast(isPresenting: $showToast){
            switch toastObj.type {
            case .competion:
                return AlertToast(displayMode: .banner(.slide), type: .complete(.myGreen), title: toastObj.message)
            case .failed:
                return AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastObj.message)
            }
            
            //AlertToast(displayMode: .banner(.slide), type: .complete(.myGreen), title: toastMessage)
        }
        
        .alert("해당 동아리를 나가시겠습니까?", isPresented: $isCheckExsit, actions: {
            Button("취소하기", role: .cancel) { }
            Button("나가기", role: .destructive) {
                Task {
                    let result = await groupStore.removeMember(userStore.user?.id ?? "ExitGroupError", groupdId: group.id)
                    switch result {
                    case .success(let success):
                        toastObj.message = success
                        toastObj.type = .competion
                        self.groupStore.groups.removeAll { $0.id == group.id}
                    case .failure(let failure):
                        toastObj.message = "서버 문제로 동아리 탈퇴가 실패했습니다."
                        toastObj.type = .failed
                        print("error: \(failure)")
                    }
                    
                    showToast.toggle()
                    dismiss()
                }
            }
        }, message: {
            Text("해당 동아리를 나가면\n동아리에 대한 모든 정보가 사라집니다.")
                .multilineTextAlignment(.center)
        })
        
        .alert("해당 동아리를 삭제하시겠습니까?", isPresented: $isRemoveGroup, actions: {
            Button("취소하기", role: .cancel) { }
            Button("삭제하기", role: .destructive) {
                Task {
                    isLoading = true //로티 애니메이션 시작
                    
                    // 동아리 내의 일정 및 연관된 출석부 컬렉션 삭제
                    for scheduleId in group.scheduleID {
                        async let attendanceList = await attendanceStore.getAttendanceList(scheduleId)
                        for id in await attendanceList {
                            await attendanceStore.removeAttendance(scheduleId, attendanceId: id)
                        }
                        await scheduleStore.removeSchedule(scheduleId)
                    }
                    
                    let uidList = memberStore.members.map { $0.uid }
                    await groupStore.removeGroup(group: group ,uidList: uidList)
                    self.groupStore.groups.removeAll { $0.id == group.id}
                    
                    toastObj.message = "동아리 삭제가 완료되었습니다."
                    toastObj.type = .competion
                    
                    // toastMessage = "동아리 삭제가 완료되었습니다."
                    isLoading = false //로티 애니메이션 종료
                    showToast.toggle()
                    dismiss()
                }
            }
        }, message: {
            Text("해당 동아리를 삭제하면\n동아리에 대한 모든 정보가 사라집니다.")
                .multilineTextAlignment(.center)
        })
        
        .alert("초대 코드를 재생성 하시겠습니까?", isPresented: $isGenerateCode, actions: {
            Button("취소하기", role: .cancel) { }
            Button("재생성 하기") {
                Task {
                    await groupStore.updateInvitationCode(group.id, newInvitationCode: Group.randomCode)
                    
                    toastObj.type = .competion
                    toastObj.message = "초대 코드가 재생성 되었습니다."
                    //toastMessage = "초대 코드가 재생성 되었습니다."
                    showToast.toggle()
                }
            }
        }, message: {
            Text("초대 코드를 재생성하면 이전 초대 코드는 사용하실 수 없습니다.")
                .multilineTextAlignment(.center)
        })
        
        .onAppear {
            print("Category onAppear 호출")
            if isFirstFetch {
                return
            }
            isFirstFetch.toggle()
            
            groupStore.startGroupListener(group)
            changedGroup = group
            
            memberStore.members.removeAll()
            Task {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isScheduleLoading.toggle()
                }
                
                await scheduleStore.fetchSchedule(groupName: group.name)
                scheduleStore.scheduleList.sort(by: { $0.startTime > $1.startTime})
                
                do {
                    try await memberStore.fetchMember(group.id)
                    for member in memberStore.members {
                        if  member.uid == userStore.user?.id && (member.position == "방장" || member.position == "운영진") {
                            isGroupManager = true
                            break
                        }
                        else {
                            isGroupManager = false
                        }
                    }
                    
                } catch MemberError.notFoundMember {
                    print("member를 못찾음")
                } catch {
                    print("not found error")
                }
            }
        }
        .onDisappear {
            //groupStore.detachListener()
            print(group.scheduleID, "---------")
        }
    }
    
    @ViewBuilder func admob() -> some View {
        // admob
        GoogleAdMobView()
            .frame(width: UIScreen.main.bounds.width, height: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width).size.height)
    }
}

struct NoAnimation: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(showToast: .constant(true), toastMessage: .constant("dd"), toastObj: .constant(ToastMessage(message: " ", type: .competion)),group: Group.sampleGroup)
            .environmentObject(ScheduleStore())
            .environmentObject(MemberStore())
            .environmentObject(GroupStore())
            .environmentObject(UserStore())
    }
}
