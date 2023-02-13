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
    
    @State var dDay: String = "D-day"
    @State private var schedules: [Schedule] = []
    
    var group: Group
    let groupImage: UIImage
    var index: Int
    var card: [Card]
    @Binding var recentScheduleList: [Schedule]
    @State var action: Int?
    
    
    @State var coordinate: CLLocationCoordinate2D?
    
    @State private var filterSchedule: Schedule = Schedule.sampleSchedule
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.myLightGray)
                .overlay {
                    VStack(alignment: .center) {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            HStack {
                                TopSection
                                Spacer()
                            }
                            .padding(.bottom)
                            
                            HStack {
                                InformationSection
                                Spacer()
                            }
                        } // - VStack
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        //동아리 사진
                        //groupImage
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: UIScreen.screenWidth * 0.7 , height: UIScreen.screenHeight / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            
                            Image(uiImage: groupImage)
                                .resizable()
                                .frame(width: UIScreen.screenWidth * 0.7 , height: UIScreen.screenHeight / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .onTapGesture {
                                    print("일정 전달 확인 \(recentScheduleList)")
                                    print("그룹 확인 \(groupStore.groups)")
                                }
                        }
                        
                        Spacer()
                        
                        // Check It 버튼
                        if let filterSchedule = recentScheduleList.first(where: { schedule in
                            schedule.groupName == group.name
                        }){
                            NavigationLink(destination: CheckMapView(group: group, schedule: filterSchedule, coordinate: coordinate)
                                .environmentObject(userStore)
                                .environmentObject(attendanceStore) ,tag: 0, selection: $action) {}
                        }
                        
                        CheckItButton(isActive: .constant(true), isAlert: .constant(false)) {
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
                        .frame(width: UIScreen.screenWidth * 0.7)
                        
                        Spacer()
                    } // - VStack
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 50)
        }
        
    }    //    MARK: - View(TopSection)
    private var TopSection: some View {
        VStack(alignment: .leading) {
            if let filterSchedule = recentScheduleList.first(where: { schedule in
                return schedule.groupName == group.name
            }) {
                // 모임 날짜 나타내는 라벨
                DdayLabel(dDay: D_days().days(to: filterSchedule.startTime))
                    .padding(.top, 10)
                
            } // - VStack
            
            // 동아리 이름
            Text("\(group.name)")
                .font(.title.bold())
                .foregroundColor(.black)
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
                        .foregroundColor(.black)
                } // - HStack
                .padding(.bottom, 7)
                
                // 시간
                HStack {
                    customSymbols(name: "clock")
                    
                    Text("\(filterSchedule.startTime, format: .dateTime.hour().minute())")
                        .foregroundColor(.black)
                } // - HStack
                .padding(.bottom, 7)
                
                // 장소
                HStack {
                    customSymbols(name: "mapPin")
                        .onTapGesture {
                            print("schedule: \(recentScheduleList)")
                            print("\(group.name)'s recent schedule: \(filterSchedule)")
                        }
                    Text("\(filterSchedule.location)")
                        .foregroundColor(.black)
                    
                } // - HStack
                .padding(.bottom, 7)
            } // - VStack
            //        }
        } // - InformationSection
    }
}



//struct CheckItCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItCard(data: <#Card#>)
//    }
//}
