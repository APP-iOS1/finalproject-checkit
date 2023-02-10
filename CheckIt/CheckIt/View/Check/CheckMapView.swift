//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//
import CoreLocation
import SwiftUI
import MapKit

struct CheckMapView: View {
    @StateObject var locationManager: LocationManager

    @State var showQR: Bool = false
    
    @State private var isGroupHost: Bool = true //테스트용 추후에 서버에서 받은 값으로 변경 예정
    
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    var group: Group
    var schedule: Schedule
    var isHost: Bool {
        group.hostID == userStore.user?.id ?? ""
    }
    
    
    @State var isActive: Bool = true
    @State var isAlert: Bool = false
    var coordinate: CLLocationCoordinate2D?
    var body: some View {
        VStack {
            // MapView
            MapViewWithUserLocation(locationManager: locationManager)
            
                .overlay(alignment: .bottom) {
                    VStack {
                        // 토스트 알럿
                        CustomToastAlert(distance: $locationManager.distance, isPresented: $isAlert)
                        
                        //Apple Map과 연결
                        HStack {
                            Spacer()
                            Button {
                                
                                let url = URL(string: "maps://?daddr=\(coordinate?.latitude ?? 0),\(coordinate?.longitude ?? 0)")
                                if UIApplication.shared.canOpenURL(url!) {
                                    UIApplication.shared.open(url!)
                                }
                                print(schedule.location, "로케이션")
                            } label: {
                                Image(systemName: "location.square.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }

                        }
                        .padding(.bottom, 10)
                        .padding(.trailing, 20)
                        .offset(y: -40)
                        
                        // 출석하기 버튼, isActive가 false면 자동으로 disable됨
                        CheckItButton(isActive: $locationManager.isInAttendanceRegion, isAlert: $isAlert, text: "출석하기") {
                           // 출석 범위에 들어왔을 때 action
                
                            // 출석 시간인지 확인하는 로직
                            let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime)
                            // 출석 시간이면 db로 데이터 보냄
                            
                            //FIXME: db에서 잘못된 시간이 들어오고 있음
                            if timeCompareResult == "출석" || timeCompareResult == "지각" {
                                // 출석 상태 변경zr
                                attendanceStore.updateAttendace(attendanceData: Attendance(id: userStore.user!.id, scheduleId: schedule.id, attendanceStatus: "\(timeCompareResult)", settlementStatus: false), scheduleID: schedule.id, uid: userStore.user!.id)
                                print(schedule.id)
                            }
                           
                            // 아니면 불가능하다는 알럿 보여주기
    
                        }
//                        .frame(width: 338) //수정했습니다 to 혜민님
                        .padding(.horizontal, 20)
                        .padding(.bottom ,10)
                        .offset(y: -50)
                    } // - VStack
                } // - overlay
            
            
            // QR 시트 버튼
                .toolbar {
                    Button (action: {
                        showQR.toggle()
                    }) { QRButtonLabel() }
                } // - toolbar
            
            
            // QR 시트
                .sheet(isPresented: $showQR) {

                    if isGroupHost {
                        CameraScanner(schedule: schedule, userID: userStore.user?.id)
                            .environmentObject(userStore)
                    } else {
                        QRSheetView(schedule: schedule)
                            .presentationDetents([.medium])
                            .environmentObject(userStore)
                            .environmentObject(attendanceStore)
                    }
                    
                } // - sheet

        } // - VStack
        .animation(.easeOut(duration: 0.3), value: isAlert)
        .transition(.opacity)
        .toolbarBackground(Material.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            print(userStore.user?.id, "유저 아이디")
        }
    }
    
    

}


