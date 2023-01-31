//
//  CameraScanner.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/31.
//

import SwiftUI
import VisionKit

struct CameraScanner: View {
    @Binding var startScanning: Bool
    let notCapacityScanner: Bool
    
    @State private var notCapacityScannerState: Bool = false

    @State var test1 : String? = nil
    @State var test2 : String? = nil
    @State var test3 : String? = nil
    
    

//    @Binding var seminarID : String
//    var seminarID : String
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var attendanceStore : AttendanceStore
    var body: some View {
        NavigationView {

            CameraScannerViewController(
                startScanning: $startScanning,
                test1: $test1,
                test2: $test2,
                test3: $test3)
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("닫기")
                            .foregroundColor(.white)
                        
                    }
//                    if Datascann == false {
//                            Button {
//                                if let url = URL(string: UIApplication.openSettingsURLString) {
//                                    UIApplication.shared.open(url)
//                                }
//                            } label: {
//                                Text("권한 설정하기")
//                                    .foregroundColor(.white)
//
//                            }
//                        }


                    }
                }
                .interactiveDismissDisabled(true)
                .onAppear {
                    print("CameraScanner - OnAppear")
                    print(startScanning, "ddd")
                    
                    
                }
                .onDisappear {
//                    print(seminarID)
//                    if let test1 = test1 {
//                        attendanceStore.addAttendance(
//                            seminarID: seminarID,
//                            attendance: Attendance(id: scanIdResult, uid: scanUid ?? "", userNickname: scanUserNickname ?? ""))
//                    } else { return }
                }
        }
    }
}

struct CameraScanner_Previews: PreviewProvider {
    static var previews: some View {
        CameraScanner(startScanning: .constant(true), notCapacityScanner: false)
    }
}
