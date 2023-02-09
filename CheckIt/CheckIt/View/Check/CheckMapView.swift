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
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var userStore: UserStore
    ///카메라 띄우기 위한 설정
    @State private var showCameraScannerView = false
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
    
    var body: some View {
        VStack {
            // MapView
            MapViewWithUserLocation(locationManager: locationManager)
            
                .overlay(alignment: .bottom) {
                    VStack {
                        // 토스트 알럿
                        CustomToastAlert(isPresented: $isAlert)
                        
                        // 출석하기 버튼, isActive가 false면 자동으로 disable됨
                        CheckItButton(isActive: isActive, isAlert: $isAlert, text: "출석하기") {
                           // 출석 범위에 들어왔을 때 action
                            print(Date())
                            // 출석 시간인지 확인하는 로직
                            
                            // 출석 범위인지 확인하는 로직
//                            print(locationManager.location?.coordinate.latitude, locationManager.location?.coordinate.longitude)
                            print(isInAttendanceRegion(from: CLLocationCoordinate2D(latitude: 0, longitude: 0), to: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)))
                        }
                        .frame(width: 338)
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
                        QRSheetView()
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
    
    
    func isInAttendanceRegion(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Bool {
        // meter 단위로 계산
        let distance = CLLocationCoordinate2D.distance(from: from, to: to)
        return distance <= 10 ? true : false
    }
}
