//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//
import CoreLocation
import SwiftUI
import MapKit
import GoogleMobileAds
import AlertToast

struct CheckMapView: View {
    @StateObject var locationManager: LocationManager
    @State var showQR: Bool = false
    
    
    @State var showToast: Bool = false
    @State var toastMessage: String = ""
    @State var isCompleteAttendance: Bool = false
    
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
            // AD
            admob()
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
                        
                        .padding(.trailing, 20)
                        
                        
                        // 출석하기 버튼, isActive가 false면 자동으로 disable됨
                        CheckItButton(isActive: checkTimeAndPlaceInAttendance(attendanceStore: attendanceStore, userStore: userStore), isAlert: $isAlert, text: "출석하기") {
                            Task {
                                guard let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime) else { return }
                                // 이미 출석이 완료 되었으면
                                isCompleteAttendance = true
                                // 출석 상태를 변경
                                //스케줄 패치로 카운트 가져옥 -> 스케줄 업데이트
                                let attendance = Attendance(id: userStore.user?.id ?? "", scheduleId: schedule.id, attendanceStatus: timeCompareResult, settlementStatus: false)
                                await scheduleStore.asyncFetchScheduleCountWithScheduleID(scheduleID: schedule.id)
                                if timeCompareResult == "지각" {
                                    scheduleStore.publishedAbsentCount -= 1
                                    scheduleStore.publishedLateCount += 1
                                }
                                else { //출석
                                    scheduleStore.publishedAbsentCount -= 1
                                    scheduleStore.publishedAttendanceCount += 1
                                }
                                var scheduleValue = schedule
                                scheduleValue.attendanceCount = scheduleStore.publishedAttendanceCount
                                scheduleValue.lateCount = scheduleStore.publishedLateCount
                                scheduleValue.absentCount = scheduleStore.publishedAbsentCount
                                scheduleValue.officiallyAbsentCount = scheduleStore.publishedOfficiallyAbsentCount
                                await scheduleStore.updateScheduleAttendanceCount(schedule: scheduleValue)
                                
                                attendanceStore.updateAttendace(attendanceData: Attendance(id: userStore.user!.id, scheduleId: schedule.id, attendanceStatus: "\(timeCompareResult)", settlementStatus: false), scheduleID: schedule.id, uid: userStore.user!.id)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 25)
                        
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
                        QRSheetView(schedule: schedule, isCompleteAttendance: $isCompleteAttendance, showToast: $showToast, toastMessage: $toastMessage)
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
        .task {
            self.isCompleteAttendance = await attendanceStore.isCompleteAttendance(schedule: schedule, uid: userStore.user?.id ?? "N/A")
        }
    }
    
    @ViewBuilder func admob() -> some View {
        // admob
        GoogleAdMobView()
            .frame(width: UIScreen.main.bounds.width, height: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width).size.height)
    }
    
    //MARK: - View(guideDirectionButton)
    private var guideDirectionButton: some View {
        Button {
            let url = URL(string: "maps://?daddr=\(coordinate?.latitude ?? 0),\(coordinate?.longitude ?? 0)")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
            }
        } label: {
            Image(systemName: "location.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.myBlack)
        }
        .padding(.bottom, 15)
    } // - guideDirectionButton
    
    
    /// 출석하기 버튼을 활성화 시키는 메서드입니다.
    func checkTimeAndPlaceInAttendance(attendanceStore: AttendanceStore, userStore: UserStore) -> Binding<Bool> {
        if isCompleteAttendance {
            DispatchQueue.main.async {
                alertMode = .complete
            }
            return .constant(false)
        }
        guard let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime)
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


