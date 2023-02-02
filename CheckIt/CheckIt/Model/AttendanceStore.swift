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
    @Published var attendanceList: [Attendance] = []
    
    let database = Firestore.firestore()
    
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
                        print(attendance, "들어가는중")
                    }
                    print("끝")
                }
            }
    }
    func fetchUserAttendance(scheduleID: String, completion: @escaping (String) -> Void) {
        attendanceList.removeAll()
        database.collection("Schedule").document(scheduleID).collection("Attendance").whereField("uid", isEqualTo: "7h0Fg6Z6rgoEkRt5udPH") //임시 uid
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
                        completion(scheduleID)
                        print(scheduleID, "나와라")
                        
                    }
                }
            }
    }
    func fetchUserAttendanceAsync(scheduleID: String) async -> String {
        return await withCheckedContinuation { continuation in
            fetchUserAttendance(scheduleID: scheduleID) { value in
                continuation.resume(returning: value)
            }
        }
    }
    
}
