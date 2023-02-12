//
//  CheckItCard.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import CoreLocation

struct CheckItCard: View {
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    var locationManager: LocationManager { LocationManager(toCoordinate: coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)) }
    
    @State var dDay: String = "D-day"
    @State private var schedules: [Schedule] = []
    
    var group: Group
    let groupImage: UIImage
    var index: Int
    var card: [Card]
    @Binding var recentScheduleList: [Schedule]
    @State var action: Int?
 
    let calendar = Calendar.current
    @State var coordinate: CLLocationCoordinate2D?
    
    @State private var filterSchedule: Schedule = Schedule(id: "", groupName: "", lateFee: 0, absenteeFee: 0, location: "", startTime: Date(), endTime: Date(), agreeTime: 0, memo: "", attendanceCount: 0, lateCount: 0, absentCount: 0, officiallyAbsentCount: 0)
    
    var body: some View {
        VStack {
            //            if let filterSchedule = recentScheduleList.first(where: { schedule in
            //                            return schedule.groupName == group.name
            //            }) {
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
                        //                        groupImage
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 246, height: 186.81)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .padding(10)
                            
                            Image(uiImage: groupImage)
                                .resizable()
                                .frame(width: 246, height: 186.81)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .padding(10)
                                .onTapGesture {
                                    print("일정 전달 확인 \(recentScheduleList)")
                                    print("그룹 확인 \(groupStore.groups)")
                                }
                        }
                        
                        // Check It 버튼
                        if let filterSchedule = recentScheduleList.first(where: { schedule in
                            schedule.groupName == group.name
                        }){
                            NavigationLink(destination: CheckMapView(locationManager: locationManager, group: group, schedule: filterSchedule, coordinate: coordinate)
                                .environmentObject(userStore)
                                .environmentObject(attendanceStore) ,tag: 0, selection: $action) {}
                        }
                            
                            
                            
                        CheckItButton(isActive: .constant(card[index].isActiveButton), isAlert: .constant(false)) {
                                guard let filterSchedule = recentScheduleList.first(where: { schedule in
                                                return schedule.groupName == group.name
                                }) else { return }
                            Task {
                                if let filterSchedule = recentScheduleList.first(where: { schedule in
                                    schedule.groupName == group.name
                                }) {
                                    guard let coordinateString = await GeoCodingService.getCoordinateFromAddress(address: filterSchedule.location) else { return }
                                    self.coordinate = CLLocationCoordinate2D(latitude: Double(coordinateString[0]) ?? 0.0, longitude: Double(coordinateString[1]) ?? 0.0)
                                    action = 0
                                }
                            }
                                
                            }
                            .frame(width: 200)
      
                       
                    } // - VStack
                } // - overlay
            //        .onAppear {
            //            if let temp = recentScheduleList.first(where: { schedule in
            //                return schedule.groupName == group.name
            //            }) {
            //                self.filterSchedule = temp
            //            }
            //            print("filter: \(self.filterSchedule)")
            //        }
        }
        

    }
    //        .onAppear {
    //            Task {
    //                print("그룹명: \(group.name)")
    //                let temp = await scheduleStore.fetchRecentSchedule(groupName: group.name)
    //
    //                self.recentSchedule = temp
    //                print("recentSchedule: \(recentSchedule)")
    //            }
    //        }
    
    //}
    
    //    MARK: - View(TopSection)
        private var TopSection: some View {
            VStack(alignment: .leading) {
                if let filterSchedule = recentScheduleList.first(where: { schedule in
                    return schedule.groupName == group.name
                }) {
                    // 모임 날짜 나타내는 라벨
                    DdayLabel(dDay: days(from: Date.now, to: filterSchedule.startTime))
                        .padding(.top, 10)
                } // - VStack
                
                // 동아리 이름
                Text("\(group.name)")
                    .font(.title.bold())
                //        }
            } // - TopSection
        }
    
    //    MARK: - View(InformationSection)
        private var InformationSection: some View {
            VStack(alignment: .leading) {
                if let filterSchedule = recentScheduleList.first(where: { schedule in
                    return schedule.groupName == group.name
                })
                {
                    // 날짜
                    HStack {
                        customSymbols(name: "calendar")
                        Text("\(filterSchedule.startTime, format: .dateTime.year().day().month())")
                    } // - HStack
                    .padding(.vertical, 3)
                    
                    // 시간
                    HStack {
                        customSymbols(name: "clock")
                        Text("\(filterSchedule.startTime, format: .dateTime.hour().minute())")
                    } // - HStack
                    .padding(.vertical, 3)
                    
                    // 장소
                    HStack {
                        customSymbols(name: "mapPin")
                            .onTapGesture {
                                print("schedule: \(recentScheduleList)")
                                print("\(group.name)'s recent schedule: \(filterSchedule)")
                            }
                        Text("\(filterSchedule.location)")
                    } // - HStack
                    .padding(.vertical, 3)
                } // - VStack
                //        }
            } // - InformationSection
        }
    
    //MARK: - 일정 디데이 계산해주는 함수
    func days(from date1: Date, to date2: Date) -> Int {
        return calendar.dateComponents([.day], from: date1, to: date2).day! + 1
    }
}



//struct CheckItCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItCard(data: <#Card#>)
//    }
//}
