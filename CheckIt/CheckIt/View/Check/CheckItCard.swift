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
            // 카드 프레임
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.myLightGray)
                .overlay {
                    // 테두리 선
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.myGray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
                            .frame(width: 300, height: 100, alignment: .leading)
                            .padding(.leading, 2)
                            
                        } // - VStack
                        .padding(.leading, 30)
                        Spacer()
                        
                        
                        //동아리 사진
                        ZStack {
                            // 플레이스 홀더
                            Rectangle()
                                .fill(Color.myGray)
                                .frame(width: UIScreen.screenWidth * 0.7 , height: UIScreen.screenHeight / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .overlay {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .foregroundColor(.myLightGray)
                                }
                            
                            Image(uiImage: groupImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.screenWidth * 0.7 , height: UIScreen.screenHeight / 5)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .onTapGesture {
                                    print("일정 전달 확인 \(recentScheduleList)")
                                    print("그룹 확인 \(groupStore.groups)")
                                }
                        } // - ZStack
                        
                        Spacer()
                        
                        // Check It 버튼
                        if let filterSchedule = recentScheduleList.first(where: { schedule in
                            schedule.groupName == group.name
                        }){
                            NavigationLink(destination: CheckMapView(group: group, schedule: filterSchedule, coordinate: coordinate)
                                .environmentObject(userStore)
                                .environmentObject(attendanceStore) ,tag: 0, selection: $action) {}
                        }
                      
                        CheckItButton(isActive: .constant(card[index].isActiveButton), isAlert: .constant(false)) {
                            locationToCoordinate()
                        }
                        .frame(width: UIScreen.screenWidth * 0.7)
                        
                        Spacer()
                    } // - VStack
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 50)
        }
    }
    //    MARK: - View(TopSection)
    private var TopSection: some View {
        VStack(alignment: .leading) {
            if let filterSchedule = recentScheduleList.first(where: { schedule in
                return schedule.groupName == group.name
            }) {
                // 모임 날짜 나타내는 라벨
                DdayLabel(dDay: D_days().days(to: filterSchedule.startTime))
                    .padding(.top, 10)
                
            } else {
                nonDdayLabel()
                    .padding(.top, 10)
            }
            
            // 동아리 이름
            Text("\(group.name)")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.leading, 1)
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
                VStack(alignment: .leading) {
                    // 날짜
                    HStack {
                        customSymbols(name: "calendar")
                        
                        Text("\(filterSchedule.startTime, format: .dateTime.year().day().month())")
                            .foregroundColor(.black)
                    } // - HStack
                    // 시간
                    HStack {
                        customSymbols(name: "clock")
                        
                        Text("\(filterSchedule.startTime, format: .dateTime.hour().minute())")
                            .foregroundColor(.black)
                    } // - HStack
                    // 장소
                    HStack {
                        customSymbols(name: "mapPin")
                            
                        Text("\(filterSchedule.location)")
                            .foregroundColor(.black)
                        
                    } // - HStack
                }
                .font(.body)
                .padding(.bottom, 7)
            } else {
                HStack {
                    Spacer()
                    Text("예정된 일정이 없습니다.")
<<<<<<< Updated upstream
                        .font(.headline)
                        //.frame(width: 300, height: 150, alignment: .center)
                    
                    Spacer()
                }

=======
<<<<<<< Updated upstream
                        .font(.title3)
                    Spacer()
                }
//                        .frame(width: 300, height: 150, alignment: .center)
=======
                        .font(.headline)
                        //.frame(width: 300, height: 150, alignment: .center)
                    Spacer()
                }
>>>>>>> Stashed changes
>>>>>>> Stashed changes
            }
        } // - InformationSection
    }
    
    //MARK: - locationToCoordinate
    func locationToCoordinate() {
        Task {
            if let filterSchedule = recentScheduleList.first(where: { schedule in
                schedule.groupName == group.name
            }) {
                guard let coordinateString = await GeoCodingService.getCoordinateFromAddress(address: filterSchedule.location) else { return }
                self.coordinate = CLLocationCoordinate2D(latitude: Double(coordinateString[0]) ?? 0.0, longitude: Double(coordinateString[1]) ?? 0.0)
                action = 0
            }
        }
    } // - locationToCoordinate
}

