//
//  ScheduleStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation
import FirebaseFirestore

class ScheduleStore: ObservableObject {
    @Published var schedule: [Schedule] = []
    
    let database = Firestore.firestore()
    
    // MARK: - fetchSchedule 함수
    func fetchSchedule() {
        database.collection("Schedule").whereField("groupName", isEqualTo: "허미니의또구동아리")
            .getDocuments { (snapshot, error) in
                self.schedule.removeAll()
                
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
                        
                        self.schedule.append(schedule)
                    }
                }
            }
    }
    
    // MARK: - addSchedule 함수
    func addSchedule(_ schedule: Schedule, group: Group) async {
        do {
            try await database.collection("Schedule")
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
        } catch {
            print("add schedule error: \(error.localizedDescription)")
        }
        
        fetchSchedule()
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
