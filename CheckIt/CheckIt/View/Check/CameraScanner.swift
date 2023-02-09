//
//  CameraScanner.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/31.
//

import SwiftUI


struct CameraScanner: View {
    var schedule: Schedule
    @StateObject private var cameraScannerViewModel = CameraScannerViewModel()
    @State private var startScanning: Bool = false
    @State private var notCapacityScannerState: Bool = false
    @State var userID : String? = nil
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var attendanceStore: AttendanceStore

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
                            .foregroundColor(Color.myGray)
                        
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
                                .foregroundColor(Color.myGray)
                            
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
                //                    print(seminarID)
//                                    if let test1 = test1 {
//                                        attendanceStore.addAttendance(
//                                            seminarID: seminarID,
//                                            attendance: Attendance(id: scanIdResult, uid: scanUid ?? "", userNickname: scanUserNickname ?? ""))
//                                    } else { return }
                if let userID = userID {
                    //출첵하는 함수
                    print(userID, "userID")
                    print(schedule, "Schedule")
                    let attendanceStatus = Date.dateCompare(compareDate: schedule.startTime)
//                    let attendance = Attendance(id: userID, scheduleId: schedule.id, attendanceStatus: attendanceStatus, settlementStatus: false)
                    print(attendanceStatus, "출석이냐 지갹이냐 결석이냐")
                    
//                    attendanceStore.updateAttendace(attendanceData: attendance, scheduleID: schedule.id, uid: userID)
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
