//
//  CategoryView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct CategoryView: View {
    @State var clickedIndex: Int = 0
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var memberStore: MemberStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isCheckExsit: Bool = false
    @State private var isRemoveGroup: Bool = false
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    let categories: [String] = ["동아리 일정", "출석부", "동아리 정보"]
    var group: Group
    
    // FIXME: - 현재는 방장인지 아닌지만 여부를 나타내는데 운영진도 고려해야함
    /// 현재 동아리가 자신이 방장인지 확인하는 연산 프로퍼티
    /// true값이면 자신이 방장이며 fasle이면 방장이 아님
    var isHost: Bool {
        group.hostID == userStore.user?.id ?? ""
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(categories.indices, id: \.self) { i in
                    Button(action: {
                        clickedIndex = i
                    }, label: {
                        if i == 1 {
                            Text(categories[i])
                                .foregroundColor(i == clickedIndex ? .black : .gray)
                                .background(i == clickedIndex ?
                                            Color.black
                                    .frame(
                                        width: 60,
                                        height: 2)
                                        .offset(y: 17)
                                            :
                                                Color.white
                                    .frame(height: 2)
                                    .offset(y: 15)
                                )
                                .font(i == clickedIndex ? .system(size: 16).bold(): .system(size: 16))
                        } else {
                            Text(categories[i])
                                .foregroundColor(i == clickedIndex ? .black : .gray)
                                .background(i == clickedIndex ?
                                            Color.black
                                    .frame(
                                        width: 85,
                                        height: 2)
                                        .offset(y: 17)
                                            :
                                                Color.white
                                    .frame(height: 2)
                                    .offset(y: 15)
                                )
                                .font(i == clickedIndex ? .system(size: 16).bold(): .system(size: 16))
                        }
                    })
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .buttonStyle(NoAnimation())
                }
            } // - HStack
            .frame(width: 330)
            .padding(.bottom, 20)
            
            if clickedIndex == 0 {
                GroupScheduleView(group: groupStore.groupDetail)
            }
            if clickedIndex == 1 {
                AttendanceStatusView(scheduleIDList: group.scheduleID, hostId: group.hostID)
            }
            if clickedIndex == 2 {
                GroupInformationView(group: groupStore.groupDetail)
            }
            
            Spacer()
            
        } // - VStack
        .navigationTitle("\(group.name)")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if isHost {
                        Section {
                            Button {
                                
                            } label: {
                                Label("동아리 편집하기", systemImage: "highlighter")
                            }
                            
                            Button {
//                                ShareLink
                            } label: {
                                Label("초대 링크 공유하기", systemImage: "square.and.arrow.up")
                            }
                            
                            Button(role: .destructive) {
                                isRemoveGroup.toggle()
                            } label: {
                                Label("동아리 삭제하기", systemImage: "trash")
                                    .foregroundColor(.red)
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
        .alert("해당 동아리를 나가시겠습니까?", isPresented: $isCheckExsit, actions: {
            Button("취소하기", role: .cancel) { }
            Button("나가기", role: .destructive) {
                Task {
                    await groupStore.removeMember(userStore.user?.id ?? "ExitGroupError", groupdId: group.id)
                    self.groupStore.groups.removeAll { $0.id == group.id}
                    toastMessage = "동아리 탈퇴가 완료되었습니다."
                    
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
                    let uidList = memberStore.members.map { $0.uid }
                    await groupStore.removeGroup(groupId: group.id ,uidList: uidList)
                    self.groupStore.groups.removeAll { $0.id == group.id}
                    
                    toastMessage = "동아리 삭제가 완료되었습니다."
                    
                    showToast.toggle()
                    dismiss()
                }
            }
        }, message: {
            Text("해당 동아리를 삭제하면\n동아리에 대한 모든 정보가 사라집니다.")
                .multilineTextAlignment(.center)
        })
        
        
        
        .onAppear {
            print("Category onAppear 호출")
            groupStore.startGroupListener(group)
            print(group.name, "네임")
            print(group.scheduleID, "Sssss")
            
            memberStore.members.removeAll()
            Task {
                await scheduleStore.fetchSchedule(groupName: group.name)
                do {
                    try await memberStore.fetchMember(group.id)
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
}

struct NoAnimation: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(showToast: .constant(true), toastMessage: .constant("dd"), group: Group.sampleGroup)
            .environmentObject(ScheduleStore())
            .environmentObject(MemberStore())
            .environmentObject(GroupStore())
            .environmentObject(UserStore())
    }
}
