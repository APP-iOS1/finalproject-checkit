//
//  GroupScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI
import AlertToast

struct GroupScheduleView: View {
    var group: Group
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var memberStore: MemberStore
    @State private var showToast = false
    
    @State private var isAddSheet: Bool = false
    @Binding var isGroupManager: Bool
    @State var toastMessage = ""
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
                if scheduleStore.scheduleList.isEmpty {
                    Spacer()
                    ScheduleEmptyView()
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(scheduleStore.scheduleList.sorted(by: { $0.startTime < $1.startTime})) { schedule in
                            NavigationLink(destination: ScheduleDetailView(showToast: $showToast, toastMessage: $toastMessage, group: group, schedule: schedule)) {
                                ScheduleDetailCellView(schedule: schedule)
                                    .onAppear {
                                        print("schedule: \(schedule)")
                                    }
                            }
                        }
                    }
                    .onAppear {
//                        scheduleStore.scheduleList.sort(by: <#T##(Schedule, Schedule) throws -> Bool#>)
                    }
                    .onDisappear{
                        //                    // 다른 동아리의 일정이 나타나는 현상 때문에 초기화
                        //                    scheduleStore.scheduleList = []
                    }
                    .refreshable {
                        await scheduleStore.fetchSchedule(groupName: groupStore.groupDetail.name)
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
