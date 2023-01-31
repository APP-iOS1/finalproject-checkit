//
//  AttendanceStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import FirebaseFirestore
import Firebase

class AttendanceStore: ObservableObject {
    // 출석 명단 배열
    @Published var attendanceList: [Attendance]
    
    let database = Firestore.firestore()
    
    init(attendances: [Attendance] = []) {
        self.attendanceList = attendances
    }
    
    // 출석부 Fetch 함수
    func fetchAttendance(scheduleID: String) {
        attendanceList.removeAll()
        database.collection("Schedule").document("\(scheduleID)").collection("Attendance")
            .getDocuments { (snapshot, error) in
                
                if let snapshot {
                    for document in snapshot.documents {
                        let docData = document.data()
                        let id: String = docData["id"] as? String ?? ""
                        let uid: String = docData["uid"] as? String ?? ""
                        let attendanceStatus: String = docData["attendance_status"] as? String ?? ""
                        let settlementStatus: Bool = docData["settlement_status"] as? Bool ?? true
                        
                        let attendance = Attendance(id: id, uid: uid, attendanceStatus: attendanceStatus, settlementStatus: settlementStatus)
                        
                        self.attendanceList.append(attendance)
                    }
                }
            }
    }
}
