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
    @Binding var cardArr: [Card]
    
    @State private var schedules: [Schedule] = []
    @State private var recentSchedule: Schedule = Schedule(id: "", groupName: "", lateFee: 0, absenteeFee: 0, location: "", startTime: Date(), endTime: Date(), agreeTime: 0, memo: "", attendanceCount: 0, lateCount: 0, absentCount: 0, officiallyAbsentCount: 0)
    
    var group: Group
    var index: Int

    var body: some View {
        VStack {
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
                                //                                        InformationSection
                                Text("디테일정보")
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


                        // Check It 버튼
                        NavigationLink(destination: CheckMapView()) {
                            CheckItButtonLabel(isActive: cardArr[index].isActiveButton, text: "Check It!")
                        }
                        .frame(width: 200)
                        .padding(10)
                        .disabled(!cardArr[index].isActiveButton)

                        Spacer()

                    } // - VStack
                    .frame(
                        width: cardArr[index].show ? UIScreen.main.bounds.width - 50 : UIScreen.main.bounds.width - 80,
                        height: cardArr[index].show ? 580 : 400
                    )
                    .scaleEffect(cardArr[index].show ? 1 : 0.7)
                    .background(Color.myLightGray)
                    .cornerRadius(25)
                } // - overlay
                .padding(.leading, 20)
                .onAppear {
                    scheduleStore.fetchSchedule(gruopName: group.name)
                    schedules = scheduleStore.scheduleList
                    print("schedules: \(schedules)")
//                    recentSchedule = schedules[0]
                }
        } // 이후 필요없으면 삭제
    }

    //MARK: - View(TopSection)
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
//        private var InformationSection: some View {
//            VStack(alignment: .leading) {
//                // 날짜
//                HStack {
//                    customSymbols(name: "calendar")
//                    Text(extraData.selectedDate(date: recentSchedule.startTime)[0])
//                } // - HStack
//                .padding(.vertical, 3)
//
//                // 시간
//                HStack {
//                    customSymbols(name: "clock")
//                    Text("\(data.time)")
//                } // - HStack
//                .padding(.vertical, 3)
//
//                // 장소
//                HStack {
//                    customSymbols(name: "mapPin")
//                    Text("\(data.place)")
//                } // - HStack
//                .padding(.vertical, 3)
//            } // - VStack
//        } // - InformationSection
}



//struct CheckItCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItCard(data: <#Card#>)
//    }
//}
