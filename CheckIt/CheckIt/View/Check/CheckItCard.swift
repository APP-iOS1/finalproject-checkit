//
//  CheckItCard.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItCard: View {
    @EnvironmentObject var scheduleStore: ScheduleStore
    @ObservedObject var extraData = ExtraData()
    
    @State private var schedules: [Schedule] = []
    
    var recentSchedule: Schedule { scheduleStore.recentSchedule }
    
    var group: Group
    var index: Int
    var card: [Card]
    
    var body: some View {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 330, height: 500)
                .foregroundColor(.white)
                .overlay {
                    VStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack {
                                TopSection
                                Spacer()
                            }
                            .padding(.top, -20)
                            
                            HStack {
                                //FIXME: 일정 데이터 연동 후 수정(디테일정보)
                                InformationSection
                                Spacer()
                            }
                        } // - VStack
                        .frame(width: 280)
                        .padding(10)
                        
                        
                        //동아리 사진
                        //                                group.image
                        Image("chocobi")
                            .resizable()
                            .frame(width: 246, height: 186.81)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(10)
                        
                        //                        // Check It 버튼
                        NavigationLink(destination: {
                            CheckMapView()
                        }, label: {
                            CheckItButtonLabel(isActive: card[index].isActiveButton, text: "Check It!")
                        })
                        .frame(width: 200)
                        .padding(10)
                        .disabled(!card[index].isActiveButton)
                        
                        Spacer()
                        
                    } // - VStack
                    .frame(
                        width: card[index].show ? UIScreen.main.bounds.width - 50 : UIScreen.main.bounds.width - 80,
                        height: card[index].show ? 580 : 400
                    )
                    .scaleEffect(card[index].show ? 1 : 0.7)
                    .background(Color.myLightGray)
                    .cornerRadius(25)
                } // - overlay
                .padding(.leading, 20)
                .onAppear {
                    Task {
                        await scheduleStore.fetchRecentSchedule(groupName: group.name)
                        print("schedule: \(scheduleStore.recentSchedule)")
                    }
                }
        
    }
    
    //    MARK: - View(TopSection)
    private var TopSection: some View {
        VStack(alignment: .leading) {
            // 모임 날짜 나타내는 라벨
            //FIXME: 일정 데이터 연동 후 수정(디데이)
            DdayLabel(dDay: "D-day")
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
                        Text("\(recentSchedule.startTime, format: .dateTime.year().day().month())")
                    } // - HStack
                    .padding(.vertical, 3)
    
                    // 시간
                    HStack {
                        customSymbols(name: "clock")
                        Text("\(recentSchedule.startTime, format: .dateTime.hour().minute())")
                    } // - HStack
                    .padding(.vertical, 3)
    
                    // 장소
                    HStack {
                        customSymbols(name: "mapPin")
                        Text("\(recentSchedule.location)")
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
