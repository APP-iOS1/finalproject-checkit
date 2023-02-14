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
    
    //status별 출석 명단
    @Published var attendanceStatusList: [Attendance] = []
    @Published var latedStatusList: [Attendance] = []
    @Published var absentedStatusList: [Attendance] = []
    @Published var officiallyAbsentedStatusList: [Attendance] = []
    
    let database = Firestore.firestore()
    
    //출석부 추가(Add) 함수
    func addAttendance(attendance: Attendance) async {
        do {
            try await database.collection("Schedule").document(attendance.scheduleId).collection("Attendance").document(attendance.id)
                .setData([
                    AttendanceConstants.id : attendance.id,
                    AttendanceConstants.attendanceStatus : attendance.attendanceStatus,
                    AttendanceConstants.scheduleId : attendance.scheduleId,
                    AttendanceConstants.settlementStatus : attendance.settlementStatus
                ])
        }
        catch {
            print("addAttendance error: \(error.localizedDescription)")
        }
    }
    
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
    //출석 상태 fetch 함수
    func fetchStatusAttendance(scheduleID: String) async {
        do {
            DispatchQueue.main.async {
                self.attendanceStatusList.removeAll()
                self.latedStatusList.removeAll()
                self.absentedStatusList.removeAll()
                self.officiallyAbsentedStatusList.removeAll()

            }
            let querySnapshot = try await database.collectionGroup("Attendance").order(by: "settlement_status", descending: true).whereField(AttendanceConstants.scheduleId, isEqualTo: scheduleID)
                .getDocuments()
            
            for document in querySnapshot.documents {
                let docData = document.data()
                let id: String = docData[AttendanceConstants.id] as? String ?? ""
                let scheduleId: String = docData[AttendanceConstants.scheduleId] as? String ?? ""
                let attendanceStatus: String = docData[AttendanceConstants.attendanceStatus] as? String ?? ""
                let settlementStatus: Bool = docData[AttendanceConstants.settlementStatus] as? Bool ?? true
                
                let attendance = Attendance(id: id, scheduleId: scheduleId, attendanceStatus: attendanceStatus, settlementStatus: settlementStatus)
                DispatchQueue.main.async {
                    switch attendance.attendanceStatus {
                    case "출석":
                        self.attendanceStatusList.append(attendance)
                    case "지각":
                        self.latedStatusList.append(attendance)
                    case "결석":
                        self.absentedStatusList.append(attendance)
                    case "공결":
                        self.officiallyAbsentedStatusList.append(attendance)
                        
                    default:
                        print("에러")
                    }
                }
            }
        }
        catch {
            print("동아리 가져오기 에러: \(error.localizedDescription)")
        }
    }
    //출석부 상태 update 함수
    func updateAttendace(attendanceData: Attendance, scheduleID: String, uid : String) {
        database.collectionGroup("Attendance").order(by: "settlement_status", descending: true).whereField(AttendanceConstants.scheduleId, isEqualTo: attendanceData.scheduleId).whereField("id", isEqualTo: attendanceData.id).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let doc = snapshot?.documents else { return }
            doc.first!.reference.updateData([AttendanceConstants.attendanceStatus : attendanceData.attendanceStatus])
            
        }
    }
    func asyncUpdateAttendance(attendanceData: Attendance, scheduleID: String, uid : String) async {
        do {
            let querySnapshot = try await database.collectionGroup("Attendance").order(by: "settlement_status", descending: true).whereField(AttendanceConstants.scheduleId, isEqualTo: attendanceData.scheduleId).whereField("id", isEqualTo: attendanceData.id).getDocuments()
            if querySnapshot.isEmpty { return }
            
            try await querySnapshot.documents.first!.reference.updateData([AttendanceConstants.attendanceStatus : attendanceData.attendanceStatus])
        }
        catch {
            print("updateAttendace: \(error.localizedDescription)")
        }
    }
    //출석부 지각, 결석비 지불 상태 update
    func updateSettlementStatus(attendanceData: Attendance) {
        database.collectionGroup("Attendance").order(by: "settlement_status", descending: true).whereField(AttendanceConstants.scheduleId, isEqualTo: attendanceData.scheduleId).whereField("id", isEqualTo: attendanceData.id).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let doc = snapshot?.documents else { return }
            doc.first!.reference.updateData([AttendanceConstants.settlementStatus : attendanceData.settlementStatus])
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
    
    /// 출석에 해당하는 스케줄의 id를 얻는 메소드 입니다.
    /// - Parameter scheduleId: 가져올 출석이랑 연관된 일정
    /// - Returns: 출석의 id
    func getAttendanceId(_ scheduleId: String) async -> String {
        do {
           let querySnapshot = try await database.collection("Schedule").document(scheduleId)
                .collection("Attendance")
                .getDocuments()
            if querySnapshot.isEmpty { return "Error"}
            let document = querySnapshot.documents.first!
            return document.documentID
        } catch {
            print("getAttendance error: \(error.localizedDescription)")
        }
        return "error"
    }
    
    /// 일정을 삭제하는 메소드 입니다.
    /// - Parameter attendanceId: 삭제할 출석의 id
    func removeAttendance(_ scheduleId: String, attendanceId: String) async {
        do {
            try await database.collection("Schedule").document(scheduleId)
                .collection("Attendance")
                .document(attendanceId)
                .delete()
        } catch {
            print("removeAttendance error: \(error.localizedDescription)")
        }
    }
    
    ///QR스캔을 통해 스캔이 완료되면 자동으로 결과를 반영할 수 있는 AddListener 메소드
    private var listener: ListenerRegistration?
    func responseAttendanceListner(schedule : Schedule, uid: String, completion: @escaping (Bool) -> Void) {
        self.listener = database.collection("Schedule").document(schedule.id).collection("Attendance").whereField(AttendanceConstants.id, isEqualTo: uid).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching attendance: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach({ diff in
                switch diff.type {
                case .added:
                    print("New Attendance Data")
                case .modified:
                    print("Modify Attendance Data")
                    completion(true)
                case .removed:
                    print("Remove Attendance Data")
                }
            })
        })
    }
    
    //MARK: - Method(isCompleteAttendance)
    func isCompleteAttendance(schedule: Schedule, uid: String) async -> Bool {
        do {
            let snapshot = try await database.collection("Schedule").document(schedule.id)
                .collection("Attendance").whereField(AttendanceConstants.id, isEqualTo: uid)
                .getDocuments()
            
            if snapshot.documents.isEmpty { return false }
            let document = snapshot.documents.first!
            let attendance = document["attendance_status"] as? String ?? "N/A"
            if attendance  == "출석" || attendance == "지각" {
                return true
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        return false
    } // - isCompleteAttendance
    
    func resetData() {
        attendanceList.removeAll()
        entireAttendanceList.removeAll()
        
        attendanceStatusList.removeAll()
        latedStatusList.removeAll()
        absentedStatusList.removeAll()
        officiallyAbsentedStatusList.removeAll()
    }
}
