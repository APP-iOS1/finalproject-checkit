//
//  GroupScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI
import AlertToast
import SkeletonUI

struct GroupScheduleView: View {
    var group: Group
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var memberStore: MemberStore
    
    @State private var showToast = false
    @State var toastMessage = ""
    @State private var toastObj: ToastMessage = ToastMessage(message: "", type: .failed)
    
    @State private var isAddSheet: Bool = false
    @State private var isCheckScheduleEmpty: Bool = false
    
    @State private var isGroupManagerInfoLabel: String = "+ 버튼으로 일정을 추가해서\n 출석 현황을 관리해 보세요."
    @State private var isGroupMemberInfoLabel: String = "동아리 일정이 생성될 예정입니다."
    
    // @Binding var isGroupManager: Bool
    @Binding var isScheduleLoading: Bool
    
    var isHost: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    
                    if isHost {
                        Button {
                            isAddSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width:20, height:20)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 30)
                                .offset(y:-10)
                            //.padding([.bottom, .trailing], 5)
                        }
                    }
                }
                //.opacity(isGroupManager ? 1 : 0)
                //.disabled(isGroupManager ? false : true)
            }
            
            VStack {
                if scheduleStore.scheduleList.isEmpty && isCheckScheduleEmpty {
                    Spacer()
                    if isHost {
                        ScheduleEmptyView(infoLabel: $isGroupManagerInfoLabel)
                    } else {
                        ScheduleEmptyView(infoLabel: $isGroupMemberInfoLabel)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        SkeletonForEach(with: scheduleStore.scheduleList, quantity: 4) { loading, schedule in
                            NavigationLink(destination: ScheduleDetailView(showToast: $showToast, toastMessage: $toastMessage, toastObj: $toastObj, group: group, schedule: schedule ?? Schedule.sampleSchedule)) {
                                if schedule != nil {
                                    ScheduleDetailCellView(schedule: schedule ?? Schedule.sampleSchedule)
                                }
                                //ScheduleDetailCellView(schedule: schedule ?? Schedule.sampleSchedule)
                            }
                            .skeleton(with: isScheduleLoading)
                            .shape(type: .rectangle)
                            .cornerRadius(18)
                            .frame(height: UIScreen.screenHeight / 5.5)
                            .padding(.bottom, 8)
                        }
                        //.padding(.vertical)
                        .padding(.horizontal, 30)
                    }
                    
                    .refreshable {
                        await scheduleStore.fetchSchedule(groupName: groupStore.groupDetail.name)
                        print("refreshable 호출")
                    }
                }

            }
        }
        
//        .refreshable {
//            await scheduleStore.fetchSchedule(groupName: groupStore.groupDetail.name)
//        }
        
        //.padding(.horizontal, 20)
        //}
        
        
        .sheet(isPresented: $isAddSheet) {
            AddScheduleView(showToast: $showToast, toastObj: $toastObj, group: group)
        }
        
        .onAppear {
            print("GroupScheduleView onAppear호출")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isCheckScheduleEmpty = true
            }
        }
        .onDisappear {
            print("GroupScheduleView onDisappear 호출")
        }

        .toast(isPresenting: $showToast){
            switch toastObj.type {
            case .competion:
                return AlertToast(displayMode: .banner(.slide), type: .complete(.myGreen), title: toastObj.message)
            case .failed:
                return AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastObj.message)
            }
        }
    }
    
}


//struct GroupScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupScheduleView(group: Group.sampleGroup)
//    }
//}
