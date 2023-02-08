//
//  CheckItCard.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItCard: View {
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore

    @State var dDay: String = "D-day"
//    @State var groupName: String = "허니미니의 또구 동아리"
//    @State var place: String = "신촌 베이스볼클럽"
//    @State var date: String = "3월 24일"
//    @State var time: String = "오후 3:00 - 오후 7:00"
    @State var groupImage: Image = Image("chocobi")
//    var isActiveButton: Bool = true
    
    @State private var schedules: [Schedule] = []
    
    @State private var recentSchedule: Schedule = Schedule(id: "", groupName: "", lateFee: 0, absenteeFee: 0, location: "", startTime: Date(), endTime: Date(), agreeTime: 0, memo: "", attendanceCount: 0, lateCount: 0, absentCount: 0, officiallyAbsentCount: 0)
    
    var group: Group
    var index: Int
    var card: [Card]
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 330, height: 580)
                .foregroundColor(.myLightGray)
                .overlay {
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            HStack {
                                TopSection
                                Spacer()
                            }
                            HStack {
                                InformationSection
                                Spacer()
                            }
                        } // - VStack
                        .frame(width: 280)
                        .padding(10)
                        
                        //동아리 사진
                        groupImage
                            .resizable()
                            .frame(width: 246, height: 186.81)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(10)
                        
                        // Check It 버튼
                        NavigationLink(destination: CheckMapView()) {
                            CheckItButton(isActive: card[index].isActiveButton, isAlert: .constant(false)).buttonLabel
                        }
                        .frame(width: 200)
                        .disabled(!card[index].isActiveButton)
                    } // - VStack
                } // - overlay
        }
        .onAppear {
            Task {
                print("그룹명: \(group.name)")
                await scheduleStore.fetchRecentSchedule(groupName: group.name)
                print("schedule2: \(scheduleStore.recentSchedule)")
                self.recentSchedule = scheduleStore.recentSchedule
            }
        }
//        .onTapGesture {
//            print("schedule: \(scheduleStore.recentSchedule)")
//            print("\(group.name)'s recent schedule: \(scheduleStore.recentSchedule.groupName)")
//        }
    }
    
    //    MARK: - View(TopSection)
    private var TopSection: some View {
        VStack(alignment: .leading) {
            // 모임 날짜 나타내는 라벨
            DdayLabel(dDay: dDay)
                .padding(.top, 10)
            // 동아리 이름
            Text("\(group.name)")
                .font(.title.bold())
        } // - VStack
    } // - TopSection
    
    //    MARK: - View(InformationSection)
    private var InformationSection: some View {
        VStack(alignment: .leading) {
            // 날짜
            HStack {
                customSymbols(name: "calendar")
                Text("\(scheduleStore.recentSchedule.startTime, format: .dateTime.year().day().month())")
            } // - HStack
            .padding(.vertical, 3)
            
            // 시간
            HStack {
                customSymbols(name: "clock")
                Text("\(scheduleStore.recentSchedule.startTime, format: .dateTime.hour().minute())")
            } // - HStack
            .padding(.vertical, 3)
            
            // 장소
            HStack {
                customSymbols(name: "mapPin")
                Text("\(scheduleStore.recentSchedule.location)")
            } // - HStack
            .padding(.vertical, 3)
        } // - VStack
    } // - InformationSection
}



//struct CheckItCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItCard(data: <#Card#>)
//    }
//}
