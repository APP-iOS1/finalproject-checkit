//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//
import CoreLocation
import SwiftUI
import UIKit
import MapKit
import GoogleMobileAds
import AlertToast

struct CheckMapView: View {
    @StateObject var locationManager: LocationManager
    @State var showQR: Bool = false
    
    @State var showToast: Bool = false
    @State var showAttendanceCompleteToast: Bool = false
    @State var toastMessage: String = ""
    @State var isCompleteAttendance: Bool = false
    @State var userTrackingMode: MKUserTrackingMode = .follow
    @State var isProcessing: Bool = false
    
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
    var coordinate: [Double]
    
    init(group: Group, schedule: Schedule, coordinate: [Double]) {
        self.group = group
        self.schedule = schedule
        if coordinate.isEmpty { self.coordinate = [0,0]
            _locationManager = StateObject(wrappedValue: LocationManager(toCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
        }
        else {
            self.coordinate = coordinate
            _locationManager = StateObject(wrappedValue: LocationManager(toCoordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1])))
            
        }
    }
    
    var body: some View {
        VStack {
            // AD
            admob()
            // MapView
            MapViewWithUserLocation(locationManager: locationManager, userTrackingMode: $userTrackingMode)
//            MapViewWithUserLocation(locationManager: locationManager)
            
                .overlay(alignment: .bottom) {
                    VStack {
                        //MARK: - 토스트 알럿
                        CustomToastAlert(distance: $locationManager.distance, isPresented: $isAlert, mode: $alertMode)
                        
                        //MARK: - 유저 포커싱 모드
                        HStack {
                            Spacer()
                            userFocusModeButton
                        }
                        .padding(.trailing, 20)
                        
                        
                        //MARK: - Apple Map과 연결(길찾기)
                        HStack {
                            Spacer()
                            guideDirectionButton
                        }
                        .padding(.trailing, 20)
                        
                        
                        //MARK: - 출석하기 버튼, isActive가 false면 자동으로 disable됨
                        CheckItButton(isActive: checkTimeAndPlaceInAttendance(schedule: schedule), isAlert: $isAlert, text: "출석하기") {
                            isProcessing = true
                            Task {

                                guard let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime, agreeTime: schedule.agreeTime, lateTime: schedule.lateTime) else { return }
                                
                                //스케줄 패치로 카운트 가져오고 -> 스케줄 업데이트
                                await attendanceListUpdateInSchedule(schedule: schedule, timeCompareResult: timeCompareResult)
                               
                                // 출석 상태를 변경                           
                                isCompleteAttendance = true
                                attendanceStore.updateAttendace(attendanceData: Attendance(id: userStore.user!.id, scheduleId: schedule.id, attendanceStatus: "\(timeCompareResult)", settlementStatus: false), scheduleID: schedule.id, uid: userStore.user!.id)
                                
                                // 출석완료 토스트 알럿 띄우기
                                toastMessage = "출석하기 완료"
                                showAttendanceCompleteToast = true
                                DispatchQueue.main.async {
                                    isProcessing = false
                                }
                            }
                        }
//                        .disabled(checkTimeAndPlaceInAttendance(schedule: schedule))
                        // 출석하기 버튼에 흰 테두리 추가
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white, lineWidth: 1.5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 25)
                        
                        
                    } // - VStack
                } // - overlay
            
            //MARK: - QR 시트 버튼
                .toolbar {
                    Button (action: {
                        showQR.toggle()
                    }) { QRButtonLabel() }
                } // - toolbar
            
            //MARK: - QR 시트
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
        .toast(isPresenting: $showAttendanceCompleteToast) {
            AlertToast(displayMode: .alert, type: .complete(.green), title: toastMessage)
        }
        .task {
            self.isCompleteAttendance = await attendanceStore.isCompleteAttendance(schedule: schedule, uid: userStore.user?.id ?? "N/A")
        }
    }
    
    //MARK: - View(admob)
    @ViewBuilder func admob() -> some View {
        // admob
        GoogleAdMobView()
            .frame(width: UIScreen.main.bounds.width, height: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width).size.height)
    } // - admob
    
    //MARK: - Button(userFocusModeButton)
    private var userFocusModeButton: some View {
        Button(action: {
            switch userTrackingMode {
            case .none:
                userTrackingMode = .follow
            case .follow:
                userTrackingMode = .none
            default:
                return
            }
        }) {
            switch userTrackingMode {
            case .none:
                Image(systemName: "viewfinder.circle.fill")
                    .resizable()
                    .foregroundColor(.myGray)
                    .frame(width: 40, height: 40)
            case .follow:
                Image(systemName: "viewfinder.circle.fill")
                    .resizable()
                    .foregroundColor(.myBlack)
                    .frame(width: 40, height: 40)
            case .followWithHeading:
                Image(systemName: "viewfinder.circle.fill")
                    .resizable()
                    .foregroundColor(.myBlack)
                    .frame(width: 40, height: 40)
            }
        }
    } // - userFocusModeButton

    
    //MARK: - View(guideDirectionButton)
    /// 길찾기 버튼입니다.
    private var guideDirectionButton: some View {
        Button {
            let url = URL(string: "maps://?daddr=\(coordinate[0] ?? 0),\(coordinate[1] ?? 0)")
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
    
    //MARK: - Method(checkTimeAndPlaceInAttendance)
    /// 출석하기 버튼을 활성화 시키는 메서드입니다.
    func checkTimeAndPlaceInAttendance(schedule: Schedule) -> Binding<Bool> {
        if self.isProcessing {
            return .constant(false)
        }
        
        if isCompleteAttendance {
            DispatchQueue.main.async {
                alertMode = .complete
            }
            return .constant(false)
        }
        guard let timeCompareResult = Date.dateCompare(compareDate: schedule.startTime, agreeTime: schedule.agreeTime, lateTime: schedule.lateTime)
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
    } // - checkTimeAndPlaceInAttendance
    
    
    //MARK: - Method(attendanceListUpdateInSchedule)
    func attendanceListUpdateInSchedule(schedule: Schedule, timeCompareResult: String) async {
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
    } // - attendanceListUpdateInSchedule
    
}



