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
    // 출석 명단 배열 -> 현재 유저가 참가한 출석 명단만 받아옴
    @Published var attendanceList: [Attendance] = []
    // 전체 출석 명단
    @Published var entireAttendanceList: [Attendance] = []
    
    let database = Firestore.firestore()
    
    // 출석부 Fetch 함수
    func fetchAttendance(scheduleID: String) {
        attendanceList.removeAll()
        database.collectionGroup("Attendance").order(by: "settlement_status", descending: true).whereField(AttendanceConstants.scheduleId, isEqualTo: scheduleID)
            .getDocuments { (snapshot, error) in
                if let snapshot {
                    for document in snapshot.documents {
                        let docData = document.data()
                        let id: String = docData[AttendanceConstants.id] as? String ?? ""
                        let scheduleId: String = docData[AttendanceConstants.scheduleId] as? String ?? ""
                        let attendanceStatus: String = docData[AttendanceConstants.attendanceStatus] as? String ?? ""
                        let settlementStatus: Bool = docData[AttendanceConstants.settlementStatus] as? Bool ?? true
                        
                        let attendance = Attendance(id: id, scheduleId: scheduleId, attendanceStatus: attendanceStatus, settlementStatus: settlementStatus)
                        
                        self.attendanceList.append(attendance)
                        print(attendance, "들어가는중")
                    }
                    print("끝")
                }
            }
    }
    //출석부 update 함수
    func updateAttendace(attendanceData: Attendance, scheduleID: String, uid : String) {
        database.collectionGroup("Attendance").order(by: "settlement_status", descending: true).whereField(AttendanceConstants.scheduleId, isEqualTo: scheduleID).whereField("id", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let doc = snapshot?.documents else { return }
            doc.first!.reference.updateData([AttendanceConstants.attendanceStatus : attendanceData.attendanceStatus])
            
        }
    }
    func fetchHostAttendacneList(scheduleIdList: [String]) {
        Task {
            entireAttendanceList.removeAll()
            for scheduleId in scheduleIdList {
                await fetchHostAttendance(scheduleID: scheduleId)
            }
        }
    }
    func fetchHostAttendance(scheduleID: String) async {
        do {
            let querySnapshot = try await database.collection("Schedule").document(scheduleID).collection("Attendance").getDocuments()
            for document in querySnapshot.documents {
                let data = document.data()
                let id: String = data[AttendanceConstants.id] as? String ?? ""
                let scheduleId: String = data[AttendanceConstants.scheduleId] as? String ?? ""
                let attendanceStatus: String = data[AttendanceConstants.attendanceStatus] as? String ?? ""
                let settlementStatus: Bool = data[AttendanceConstants.settlementStatus] as? Bool ?? true
                
                let attendance = Attendance(id: id, scheduleId: scheduleId, attendanceStatus: attendanceStatus, settlementStatus: settlementStatus)
                DispatchQueue.main.async {
                    self.entireAttendanceList.append(attendance)
                    print(self.entireAttendanceList, "sss")
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func checkUserAttendance(scheduleID: String, id: String) async -> Bool {
        do {
            let querySnapshot = try await database.collection("Schedule").document(scheduleID).collection("Attendance").whereField(AttendanceConstants.id, isEqualTo: id)
                .getDocuments()
            if querySnapshot.documents.isEmpty {
                ///자신이 출석부에 없음
                return false
            }
            else {
                ///자신이 출석부에 있음
                for document in querySnapshot.documents {
                    let data = document.data()
                    let id: String = data[AttendanceConstants.id] as? String ?? ""
                    let scheduleId: String = data[AttendanceConstants.scheduleId] as? String ?? ""
                    let attendanceStatus: String = data[AttendanceConstants.attendanceStatus] as? String ?? ""
                    let settlementStatus: Bool = data[AttendanceConstants.settlementStatus] as? Bool ?? true
                    
                    let attendance = Attendance(id: id, scheduleId: scheduleId, attendanceStatus: attendanceStatus, settlementStatus: settlementStatus)
                    DispatchQueue.main.async {
                        self.attendanceList.append(attendance)
                    }
                }
                return true
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return false
    }

    
}
