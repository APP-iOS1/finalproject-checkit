//
//  GroupScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct GroupScheduleView: View {
    var group: Group
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        AddScheduleView(group: group)
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width:20, height:20)
                            .foregroundColor(.black)
                            .padding(5)
                    }
                }
                
                VStack {
                    List {
                        ForEach(scheduleStore.schedule) { schedule in
                            VStack {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.myLightGray)
                                        .frame(height: 150)
                                    
                                    VStack(alignment: .leading) {
                                        
                                        HStack {
                                            customSymbols(name: "calendar")
                                            // MARK: - 동아리 일정 날짜
                                            Text("\(schedule.startTime)")
                                        }
                                        
                                        HStack {
                                            customSymbols(name: "clock")
                                            // MARK: - 동아리 일정 시간
                                            Text("\(schedule.startTime)")
                                            Text("~")
                                            Text("\(schedule.endTime)")
                                        }
                                        
                                        HStack {
                                            customSymbols(name: "mapPin")
                                            // MARK: - 동아리 일정 장소
                                            Text(schedule.location)
                                        }
                                    }
                                    .padding(30)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    scheduleStore.fetchSchedule()
                }
                .refreshable {
                    scheduleStore.fetchSchedule()
                }
            }
            .padding(.horizontal, 40)
        }
    }
}


//struct GroupScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupScheduleView(group: Group.sampleGroup)
//    }
//}
