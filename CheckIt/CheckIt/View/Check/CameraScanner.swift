//
//  CameraScanner.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/31.
//

import SwiftUI
import AlertToast

struct CameraScanner: View {
    var schedule: Schedule
    @StateObject private var cameraScannerViewModel = CameraScannerViewModel()
    @State private var startScanning: Bool = false
    @State private var notCapacityScannerState: Bool = false
    @State var userID : String? = nil
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    @EnvironmentObject var scheduleStore: ScheduleStore

    var body: some View {
        NavigationView {
            CameraScannerViewController(
                startScanning: $startScanning,
                userID: $userID)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("닫기")
                        
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if cameraScannerViewModel.dataScannerAccessStatus == .cameraAccessNotGranted {
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("권한 설정하기")
                        }
                    }
                }
            }
            .interactiveDismissDisabled(true)
            .onAppear {
                print("CameraScanner - OnAppear")
                print(startScanning, "starScanningStatus")
                print(cameraScannerViewModel.dataScannerAccessStatus, "scannerAccessStatus")
                
                
            }
            .onDisappear {
                print(startScanning, "dss")
                print(userID, "userID")
                print(schedule, "Schedule")
                print(attendanceStore, "attendanceStore")
                if let userID = userID {
                    //출첵하는 함수
                    print(userID, "userID")
                    let attendanceStatus = Date.dateCompare(compareDate: schedule.startTime)
                    guard let attendanceStatus = attendanceStatus else {
                        showToast.toggle()
                        toastMessage = "결석처리 되었습니다."
                        return 
                    }
                    print(attendanceStatus, "어텐던스 스테이터스")
                    
                    
                    if attendanceStatus == "이전" {
                        //이전 토스트 메시지
                        showToast.toggle()
                        toastMessage = "아직 출석체크 시간이 아닙니다."
                    }
                    else if attendanceStatus == "지각" || attendanceStatus == "출석" {
                        Task {
                            //스케줄 패치로 카운트 가져오기 -> 스케줄 업데이트
                            let attendance = Attendance(id: userID, scheduleId: schedule.id, attendanceStatus: attendanceStatus, settlementStatus: false)
                            await scheduleStore.asyncFetchScheduleCountWithScheduleID(scheduleID: schedule.id)
                            if attendanceStatus == "지각" {
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
                            await                         attendanceStore.asyncUpdateAttendance(attendanceData: attendance, scheduleID: schedule.id, uid: userID)
                            
                            //큐알 토스트 메세지
                            showToast.toggle()
                            toastMessage = "출석체크를 완료했습니다."
                        }
                    }

                } else { return }
            }
        }
        .task {
            await cameraScannerViewModel.requestDataScannerAccessStatus()
            print(cameraScannerViewModel.dataScannerAccessStatus)
            if cameraScannerViewModel.dataScannerAccessStatus == .scannerAvailable {
                startScanning = true
            }
        }
    }
}

//struct CameraScanner_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraScanner()
//    }
//}
