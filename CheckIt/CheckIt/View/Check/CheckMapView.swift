//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//
import CoreLocation
import SwiftUI
import MapKit
import AlertToast

struct CheckMapView: View {
    @StateObject var locationManager: LocationManager
    @State var showQR: Bool = false
    
    
    @State var showToast: Bool = false
    @State var toastMessage: String = ""
    
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    var group: Group
    var schedule: Schedule
    var isGroupHost: Bool {
        group.hostID == userStore.user?.id ?? ""
    }
    
    // 출석하기 버튼이 활성화 되는지 판단하는 변수
    @State var isActive: Bool = true
    // 경고창을 띄울지 판단하는 변수
    @State var isAlert: Bool = false
    // 경고창의 모드(장소,시간)를 판단하는 변수
    @State var alertMode: AlertMode = .time
    var coordinate: CLLocationCoordinate2D?
    
    init(group: Group, schedule: Schedule, coordinate: CLLocationCoordinate2D?) {
        self.group = group
        self.schedule = schedule
        self.coordinate = coordinate
        _locationManager = StateObject(wrappedValue: LocationManager(toCoordinate: coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)))
    }
    
    var body: some View {
        VStack {
            // MapView
            MapViewWithUserLocation(locationManager: locationManager)
            
                .overlay(alignment: .bottom) {
                    VStack {
                        // 토스트 알럿
                        CustomToastAlert(distance: $locationManager.distance, isPresented: $isAlert, mode: $alertMode)
                        
                        //Apple Map과 연결
                        HStack {
                            Spacer()
                            guideDirectionButton
                        }
                        .padding(.bottom, 10)
                        .padding(.trailing, 20)
                        .offset(y: -40)
                        
                        // 출석하기 버튼, isActive가 false면 자동으로 disable됨
                        CheckItButton(isActive: checkTimeAndPlaceInAttendance(), isAlert: $isAlert, text: "출석하기") {
                            guard let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime) else { return }
                            attendanceStore.updateAttendace(attendanceData: Attendance(id: userStore.user!.id, scheduleId: schedule.id, attendanceStatus: "\(timeCompareResult)", settlementStatus: false), scheduleID: schedule.id, uid: userStore.user!.id)
                        }
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
                        CameraScanner(schedule: schedule, showToast: $showToast, toastMessage: $toastMessage)
                            .environmentObject(attendanceStore)
                            .environmentObject(scheduleStore)
                    } else {
                        QRSheetView(schedule: schedule)
                            .presentationDetents([.medium])
//                            .environmentObject(userStore)
                            .environmentObject(attendanceStore)
                    }
                } // - sheet

        } // - VStack
        .padding(.bottom, 20)
        .animation(.easeOut(duration: 0.3), value: isAlert)
        .transition(.opacity)
        .toolbarBackground(Material.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .banner(.slide), type: .regular, title: toastMessage)
        }
    }
    
    //MARK: - View(guideDirectionButton)
    private var guideDirectionButton: some View {
        Button {
            let url = URL(string: "maps://?daddr=\(coordinate?.latitude ?? 0),\(coordinate?.longitude ?? 0)")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
            }
        } label: {
            Image(systemName: "location.square.fill")
                .resizable()
                .frame(width: 40, height: 40)
        }
    } // - guideDirectionButton
    
    
    func checkTimeAndPlaceInAttendance() -> Binding<Bool> {
        let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime)
        guard let timeCompareResult
        else {
            DispatchQueue.main.async {
                alertMode = .time
            }
            return .constant(false)
        }
        
        if !locationManager.isInAttendanceRegion {
            DispatchQueue.main.async {
                alertMode = .place
            }
            return .constant(false)
        }
        return .constant(true)
    }
    
}


