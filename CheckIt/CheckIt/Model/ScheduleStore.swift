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
    
    func fetchSchedule(gruopName: String) {
           database.collection("Schedule").whereField("group_name", isEqualTo: gruopName)
            .getDocuments { (snapshot, error) in
                self.scheduleList.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let groupName: String = docData["group_name"] as? String ?? ""
                        let lateFee: Int = docData["late_fee"] as? Int ?? 0
                        let absenteeFee: Int = docData["absentee_fee"] as? Int ?? 0
                        let location: String = docData["location"] as? String ?? ""
                        let agreeTime: Int = docData["agree_time"] as? Int ?? 0
                        let memo: String = docData["memo"] as? String ?? ""
                        
                        let startTime: Timestamp = docData["start_time"] as? Timestamp ?? Timestamp()
                        let startTimestamp: Date = startTime.dateValue()
                        
                        let endTime: Timestamp = docData["end_time"] as? Timestamp ?? Timestamp()
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
    func addSchedule(_ schedule: Schedule, group: Group) async {
        do {
            try await database.collection("Schedule")
                .document(schedule.id)
                .setData(["group_name": schedule.groupName,
                          "late_fee": schedule.lateFee,
                          "absentee_fee": schedule.absenteeFee,
                          "location": schedule.location,
                          "agree_time": schedule.agreeTime,
                          "memo": schedule.memo,
                          "start_time": schedule.startTime,
                          "end_time": schedule.endTime,
                          "id": schedule.id
                         ])
        } catch {
            print("add schedule error: \(error.localizedDescription)")
        }
        
        fetchSchedule(gruopName: group.name)
        await addScheduleInGroup(schedule.id, group: group)
        // FIXME: - 일정을 만들때 해당하는 출석부도 만들어야 한다.
        // 연속으로 일정을 만드는 경우 이전일정은 저장은 안되는 문제도 존재
    }
    
    // MARK: - addScheduleInGroup 함수
    func addScheduleInGroup(_ scheduleId: String, group: Group) async {
        var scheduleList = group.scheduleID
        scheduleList.append(scheduleId)
        let newScheduleList = scheduleList
        
        do {
            try await database.collection("Group")
                .document(group.id)
                .updateData([
                    "schedule_id": newScheduleList
                ])
                
        } catch {
            print("addScheduleInGroup error: \(error.localizedDescription)")
        }
    }
}
