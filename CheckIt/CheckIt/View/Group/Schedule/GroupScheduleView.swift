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
    @State private var isAddSheet: Bool = false
    @State private var isCheckScheduleEmpty: Bool = false
    
    @Binding var isGroupManager: Bool
    @Binding var isScheduleLoading: Bool
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        isAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width:20, height:20)
                            .foregroundColor(.black)
                            .padding([.bottom, .trailing], 5)
                    }
                }
                .opacity(isGroupManager ? 1 : 0)
                .disabled(isGroupManager ? false : true)
            }
            
            VStack {
                if scheduleStore.scheduleList.isEmpty && isCheckScheduleEmpty {
                    Spacer()
                    ScheduleEmptyView()
                    Spacer()
                } else {
                    ScrollView {
                        SkeletonForEach(with: scheduleStore.scheduleList.sorted(by: { $0.startTime < $1.startTime}), quantity: 4) { loading, schedule in
                            NavigationLink(destination: ScheduleDetailView(showToast: $showToast, toastMessage: $toastMessage, group: group, schedule: schedule ?? Schedule.sampleSchedule)) {
                                if schedule != nil {
                                    ScheduleDetailCellView(schedule: schedule ?? Schedule.sampleSchedule)
                                }
                                //ScheduleDetailCellView(schedule: schedule ?? Schedule.sampleSchedule)
                            }
                            .skeleton(with: isScheduleLoading)
                            .shape(type: .rectangle)
                            .frame(height: UIScreen.screenHeight / 5.5)
                        }
                    }
                    .onAppear {
                    }
                    .onDisappear{
                        //                    // 다른 동아리의 일정이 나타나는 현상 때문에 초기화
                        //                    scheduleStore.scheduleList = []
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
        
        .padding(.horizontal, 20)
        //}
        
        
        .sheet(isPresented: $isAddSheet) {
            AddScheduleView(showToast: $showToast, toastMessage: $toastMessage, group: group)
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
            
            // .alert is the default displayMode
            AlertToast(displayMode: .banner(.slide), type: .complete(Color.myGreen), title: toastMessage)
            
            //Choose .hud to toast alert from the top of the screen
            //AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
            
            //Choose .banner to slide/pop alert from the bottom of the screen
            //AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
        }
        
    }
    
}


//struct GroupScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupScheduleView(group: Group.sampleGroup)
//    }
//}
