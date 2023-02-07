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
    @Published var userScheduleList: [Schedule] = [] ///유저가 속해있는 스케줄 리스트
    @Published var recentSchedule: Schedule = Schedule(id: "", groupName: "", lateFee: 0, absenteeFee: 0, location: "", startTime: Date(), endTime: Date(), agreeTime: 0, memo: "", attendanceCount: 0, lateCount: 0, absentCount: 0, officiallyAbsentCount: 0)
    
    
    //출석부 카운트
    @Published var publishedAttendanceCount: Int = 0
    @Published var publishedLateCount: Int = 0
    @Published var publishedAbsentCount: Int = 0
    @Published var publishedOfficiallyAbsentCount: Int = 0
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
                        
                        let groupName: String = docData[ScheduleConstants.groupName] as? String ?? ""
                        let lateFee: Int = docData[ScheduleConstants.lateFee] as? Int ?? 0
                        let absenteeFee: Int = docData[ScheduleConstants.absenteeFee] as? Int ?? 0
                        let location: String = docData[ScheduleConstants.location] as? String ?? ""
                        let agreeTime: Int = docData[ScheduleConstants.agreeTime] as? Int ?? 0
                        let memo: String = docData[ScheduleConstants.memo] as? String ?? ""
                        let attendanceCount: Int = docData[ScheduleConstants.attendanceCount] as? Int ?? 0
                        let lateCount: Int = docData[ScheduleConstants.lateCount] as? Int ?? 0
                        let absentCount: Int = docData[ScheduleConstants.absentCount] as? Int ?? 0
                        let officiallyAbsentCount: Int = docData[ScheduleConstants.officiallyAbsentCount] as? Int ?? 0
                        
                        let startTime: Timestamp = docData["start_time"] as? Timestamp ?? Timestamp()
                        let startTimestamp: Date = startTime.dateValue()
                        
                        let endTime: Timestamp = docData["end_time"] as? Timestamp ?? Timestamp()
                        let endTimestamp: Date = endTime.dateValue()
                        
                        let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo, attendanceCount: attendanceCount, lateCount: lateCount, absentCount: absentCount, officiallyAbsentCount: officiallyAbsentCount)
                        
                        self.scheduleList.append(schedule)
                        print("fetchstore: \(self.scheduleList)")
                    }
                }
            }
    }

    //스케줄 id를 가지고 패치
    func fetchScheduleWithScheudleID(scheduleID: String) {

        database.collection("Schedule").whereField(ScheduleConstants.id, isEqualTo: scheduleID)
            .getDocuments { [self] (snapshot, error) in
                self.publishedAttendanceCount = 0
                self.publishedLateCount = 0
                self.publishedAbsentCount = 0
                self.publishedOfficiallyAbsentCount = 0
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let groupName: String = docData[ScheduleConstants.groupName] as? String ?? ""
                        let lateFee: Int = docData[ScheduleConstants.lateFee] as? Int ?? 0
                        let absenteeFee: Int = docData[ScheduleConstants.absenteeFee] as? Int ?? 0
                        let location: String = docData[ScheduleConstants.location] as? String ?? ""
                        let agreeTime: Int = docData[ScheduleConstants.agreeTime] as? Int ?? 0
                        let memo: String = docData[ScheduleConstants.memo] as? String ?? ""
                        let attendanceCount: Int = docData[ScheduleConstants.attendanceCount] as? Int ?? 0
                        let lateCount: Int = docData[ScheduleConstants.lateCount] as? Int ?? 0
                        let absentCount: Int = docData[ScheduleConstants.absentCount] as? Int ?? 0
                        let officiallyAbsentCount: Int = docData[ScheduleConstants.officiallyAbsentCount] as? Int ?? 0
                        
                        let startTime: Timestamp = docData["start_time"] as? Timestamp ?? Timestamp()
                        let startTimestamp: Date = startTime.dateValue()
                        
                        let endTime: Timestamp = docData["end_time"] as? Timestamp ?? Timestamp()
                        let endTimestamp: Date = endTime.dateValue()
                        
                        let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo, attendanceCount: attendanceCount, lateCount: lateCount, absentCount: absentCount, officiallyAbsentCount: officiallyAbsentCount)
                        
                        print(schedule, "반영이 되나")
                        
                        self.publishedAttendanceCount = schedule.attendanceCount
                        self.publishedLateCount = schedule.lateCount
                        self.publishedAbsentCount = schedule.absentCount
                        self.publishedOfficiallyAbsentCount = schedule.officiallyAbsentCount
                                    
                    }
                }
            }
    }

    // MARK: - updateSchedule 함수
    func updateScheduleAttendanceCount(schedule: Schedule) {
        
        print("updateScheduleAttendanceCount실행")
        database.collection("Schedule").whereField(ScheduleConstants.groupName, isEqualTo: schedule.groupName).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let doc = snapshot?.documents else { return }
            doc.first!.reference.updateData([
                ScheduleConstants.attendanceCount: schedule.attendanceCount,
                ScheduleConstants.lateCount : schedule.lateCount,
                ScheduleConstants.absentCount : schedule.absentCount,
                ScheduleConstants.officiallyAbsentCount : schedule.officiallyAbsentCount
            ])
        }
    }

    

    
    /// schedule id 배열을 받아서 참석자 검증 - 개인
    func fetchUserScheduleList(scheduleList: [Schedule], userID : String, attendanceStore: AttendanceStore) {
        Task {
            userScheduleList.removeAll()
            attendanceStore.attendanceList.removeAll()
            for schedule in scheduleList {
                let validId = await  attendanceStore.checkUserAttendance(scheduleID: schedule.id, id: userID)
                print(validId, " valid")
                if validId == true {
                    DispatchQueue.main.async {
                        self.userScheduleList.append(schedule)
                    }
                    
                }
            }
            
        }
    }
    
    
    // MARK: - addSchedule 함수
    func addSchedule(_ schedule: Schedule, group: Group) async {
        do {
            try await database.collection("Schedule")
                .document(schedule.id)
                .setData([
                    "id": schedule.id,
                    ScheduleConstants.groupName : schedule.groupName,
                    ScheduleConstants.lateFee : schedule.lateFee,
                    ScheduleConstants.absenteeFee: schedule.absenteeFee,
                    ScheduleConstants.location: schedule.location,
                    ScheduleConstants.agreeTime: schedule.agreeTime,
                    ScheduleConstants.memo : schedule.memo,
                    ScheduleConstants.startTime: schedule.startTime,
                    ScheduleConstants.endTime: schedule.endTime,
                    ScheduleConstants.attendanceCount: schedule.attendanceCount,
                    ScheduleConstants.lateCount: schedule.lateCount,
                    ScheduleConstants.absentCount: schedule.absentCount,
                    ScheduleConstants.officiallyAbsentCount: schedule.officiallyAbsentCount
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
    
    // MARK: - 동아리 카드 디테일 정보
    func fetchRecentSchedule(groupName: String) async {
        do {
            self.scheduleList.removeAll()
            
            let querySnapshot = try await database.collection("Schedule")
                .whereField("group_name", isEqualTo: groupName)
                .order(by: "start_time", descending: true)
                .getDocuments()
            if querySnapshot.isEmpty {
                print("fetchRecentSchedule 실패(동아리 처음 개설)")
                return
            }
            
            let id: String = querySnapshot.documents[0].documentID
            let docData = querySnapshot.documents[0].data()
            
            let groupName: String = docData[ScheduleConstants.groupName] as? String ?? ""
            let lateFee: Int = docData[ScheduleConstants.lateFee] as? Int ?? 0
            let absenteeFee: Int = docData[ScheduleConstants.absenteeFee] as? Int ?? 0
            let location: String = docData[ScheduleConstants.location] as? String ?? ""
            let agreeTime: Int = docData[ScheduleConstants.agreeTime] as? Int ?? 0
            let memo: String = docData[ScheduleConstants.memo] as? String ?? ""
            let attendanceCount: Int = docData[ScheduleConstants.attendanceCount] as? Int ?? 0
            let lateCount: Int = docData[ScheduleConstants.lateCount] as? Int ?? 0
            let absentCount: Int = docData[ScheduleConstants.absentCount] as? Int ?? 0
            let officiallyAbsentCount: Int = docData[ScheduleConstants.officiallyAbsentCount] as? Int ?? 0
            
            let startTime: Timestamp = docData["start_time"] as? Timestamp ?? Timestamp()
            let startTimestamp: Date = startTime.dateValue()
            
            let endTime: Timestamp = docData["end_time"] as? Timestamp ?? Timestamp()
            let endTimestamp: Date = endTime.dateValue()
            
            let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo, attendanceCount: attendanceCount, lateCount: lateCount, absentCount: absentCount, officiallyAbsentCount: officiallyAbsentCount)
            
            DispatchQueue.main.async {
                self.recentSchedule = schedule
                print(schedule.startTime)
            }
        }
        catch {
            print("fetch group image error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 캘린더
    func fetchCalendarSchedule(groupName: String) async {
        do {
            self.scheduleList.removeAll()
            
            let querySnapshot = try await database.collection("Schedule")
                .whereField("group_name", isEqualTo: groupName)
                .getDocuments()
            
            for document in querySnapshot.documents {
                let id: String = document.documentID
                let docData = document.data()
                
                let groupName: String = docData[ScheduleConstants.groupName] as? String ?? ""
                let lateFee: Int = docData[ScheduleConstants.lateFee] as? Int ?? 0
                let absenteeFee: Int = docData[ScheduleConstants.absenteeFee] as? Int ?? 0
                let location: String = docData[ScheduleConstants.location] as? String ?? ""
                let agreeTime: Int = docData[ScheduleConstants.agreeTime] as? Int ?? 0
                let memo: String = docData[ScheduleConstants.memo] as? String ?? ""
                let attendanceCount: Int = docData[ScheduleConstants.attendanceCount] as? Int ?? 0
                let lateCount: Int = docData[ScheduleConstants.lateCount] as? Int ?? 0
                let absentCount: Int = docData[ScheduleConstants.absentCount] as? Int ?? 0
                let officiallyAbsentCount: Int = docData[ScheduleConstants.officiallyAbsentCount] as? Int ?? 0
                
                let startTime: Timestamp = docData["start_time"] as? Timestamp ?? Timestamp()
                let startTimestamp: Date = startTime.dateValue()
                
                let endTime: Timestamp = docData["end_time"] as? Timestamp ?? Timestamp()
                let endTimestamp: Date = endTime.dateValue()
                
                let schedule: Schedule = Schedule(id: id, groupName: groupName, lateFee: lateFee, absenteeFee: absenteeFee, location: location, startTime: startTimestamp, endTime: endTimestamp, agreeTime: agreeTime, memo: memo, attendanceCount: attendanceCount, lateCount: lateCount, absentCount: absentCount, officiallyAbsentCount: officiallyAbsentCount)
                
                DispatchQueue.main.async {
                    self.scheduleList.append(schedule)
                }
            }
        }
        catch {
            print("fetch group image error: \(error.localizedDescription)")
        }
    }
}
