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
