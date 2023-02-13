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
    
    @State private var filterSchedule: Schedule = Schedule.sampleSchedule
    
    var body: some View {
        VStack {
            //            if let filterSchedule = recentScheduleList.first(where: { schedule in
            //                            return schedule.groupName == group.name
            //            }) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.65)
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
                        //.frame(width: 280)
                        .padding([.leading, .trailing, .bottom])
                        
                        //동아리 사진
                        //                        groupImage
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: UIScreen.screenWidth / 2, height: UIScreen.screenHeight / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .padding(10)
                            
                            Image(uiImage: groupImage)
                                .resizable()
                                .frame(width: UIScreen.screenWidth / 2, height: UIScreen.screenHeight / 5)
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
                        //.frame(width: 200)
                        .frame(width: UIScreen.screenWidth * 0.7)
                        .padding(.top)
                        
                        
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
                DdayLabel(dDay: days(to: filterSchedule.startTime))
                //.padding(.top, 10)
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
    func days(to date: Date) -> Int {
        //지금 날짜
        var nowComponents = DateComponents()
        nowComponents.day = calendar.dateComponents([.day], from: Date()).day
        nowComponents.month = calendar.dateComponents([.month], from: Date()).month
        nowComponents.year = calendar.dateComponents([.year], from: Date()).year
        
        let fromDate = calendar.date(from: nowComponents)
        
        //일정 날짜
        var components = DateComponents()
        components.day = calendar.dateComponents([.day], from: date).day
        components.month = calendar.dateComponents([.month], from: date).month
        components.year = calendar.dateComponents([.year], from: date).year
        
        let toDate = calendar.date(from: components)
        
        // 00시 00분을 기준으로 계산
        return (calendar.dateComponents([.day], from: fromDate!, to: toDate!).day ?? 0)
    }
}



//struct CheckItCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItCard(data: <#Card#>)
//    }
//}
