//
//  ScheduleStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import FirebaseFirestore

class ScheduleStore: ObservableObject {
    @Published var scheduleList: [Schedule] = []
    
    let database = Firestore.firestore()
    
    // MARK: - fetchSchedule 함수
    func fetchSchedule() {
        database.collection("Schedule").whereField("id", isEqualTo: "허미니의또구동아리")
            .getDocuments { (snapshot, error) in
                self.scheduleList.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let groupName: String = docData["groupName"] as? String ?? ""
                        let lateFee: Int = docData["lateFee"] as? Int ?? 0
                        let absenteeFee: Int = docData["absenteeFee"] as? Int ?? 0
                        let location: String = docData["location"] as? String ?? ""
                        let agreeTime: Int = docData["agreeTime"] as? Int ?? 0
                        let memo: String = docData["memo"] as? String ?? ""
                        
                        let startTime: Timestamp = docData["startTime"] as? Timestamp ?? Timestamp()
                        let startTimestamp: Date = startTime.dateValue()
                        
                        let endTime: Timestamp = docData["endTime"] as? Timestamp ?? Timestamp()
                        let endTimestamp: Date = endTime.dateValue()
                        
                        let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo)
                        
                        self.scheduleList.append(schedule)
                    }
                }
            }
    }
    func fetchUserSchedule(scheduleID: String) {
        database.collection("Schedule").whereField("id", isEqualTo: scheduleID)
            .getDocuments { (snapshot, error) in
                self.scheduleList.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let groupName: String = docData["groupName"] as? String ?? ""
                        let lateFee: Int = docData["lateFee"] as? Int ?? 0
                        let absenteeFee: Int = docData["absenteeFee"] as? Int ?? 0
                        let location: String = docData["location"] as? String ?? ""
                        let agreeTime: Int = docData["agreeTime"] as? Int ?? 0
                        let memo: String = docData["memo"] as? String ?? ""
                        
                        let startTime: Timestamp = docData["startTime"] as? Timestamp ?? Timestamp()
                        let startTimestamp: Date = startTime.dateValue()
                        
                        let endTime: Timestamp = docData["endTime"] as? Timestamp ?? Timestamp()
                        let endTimestamp: Date = endTime.dateValue()
                        
                        let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo)
                        
                        self.scheduleList.append(schedule)
                    }
                }
            }
    }
    
    //schedule id 배열을 받아서 참석자 검증
    func fetchUserScheduleList(scheduleList: [String]) {
        Task {
            do {
                var userScheduleIDList: [String] = []
                for scheduleID in scheduleList {
                    print(scheduleList, "값이 전달?")
                    async let userScheduleId =  AttendanceStore().fetchUserAttendanceAsync(scheduleID: scheduleID) //uid를 확인해서 자신이 그 스케줄에 속해있는지 확인
                    await userScheduleIDList.append(userScheduleId) //속해있다면 추가
                    print("비동기 안되나")
                }
//                for scheduleID in userScheduleIDList {
//                    fetchUserSchedule(scheduleID: scheduleID)
//                    print(scheduleID, "ididididi")
//                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
//    func fetchUserSchedule(groupID: String) {
//        database.collection("Schedule").whereField("id", isEqualTo: groupID)
//            .getDocuments { (snapshot, error) in
//                self.scheduleList.removeAll()
//
//                if let snapshot {
//                    for document in snapshot.documents {
//                        let id: String = document.documentID
//                        let docData = document.data()
//
//                        let groupName: String = docData["groupName"] as? String ?? ""
//                        let lateFee: Int = docData["lateFee"] as? Int ?? 0
//                        let absenteeFee: Int = docData["absenteeFee"] as? Int ?? 0
//                        let location: String = docData["location"] as? String ?? ""
//                        let agreeTime: Int = docData["agreeTime"] as? Int ?? 0
//                        let memo: String = docData["memo"] as? String ?? ""
//
//                        let startTime: Timestamp = docData["startTime"] as? Timestamp ?? Timestamp()
//                        let startTimestamp: Date = startTime.dateValue()
//
//                        let endTime: Timestamp = docData["endTime"] as? Timestamp ?? Timestamp()
//                        let endTimestamp: Date = endTime.dateValue()
//
//                        let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo)
//
//                        self.scheduleList.append(schedule)
//                    }
//                }
//            }
//    }
    
    // MARK: - addSchedule 함수
    func addSchedule(_ schedule: Schedule) {
        database.collection("Schedule")
            .document(schedule.id)
            .setData(["groupName": schedule.groupName,
                      "lateFee": schedule.lateFee,
                      "absenteeFee": schedule.absenteeFee,
                      "location": schedule.location,
                      "agreeTime": schedule.agreeTime,
                      "memo": schedule.memo,
                      "startTime": schedule.startTime,
                      "endTime": schedule.endTime,
                      "id": schedule.id
                     ])
        
        fetchSchedule()
    }
}
