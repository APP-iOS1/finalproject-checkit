//
//  EditScheduleAttendanceView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/06.
//

import SwiftUI

struct EditScheduleAttendanceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var attendanceStore: AttendanceStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @State private var changedAttendancList: [Attendance] = []
    @State private var attendanceStatus: [Int] = [0, 0, 0, 0]
    @State var schedule: Schedule
    var body: some View {
        VStack {
            ScrollView {
                ForEach(changedAttendancList.indices, id: \.self) { index in
                    EditScheduleAttendanceListCell(data: $changedAttendancList[index])
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    for index in 0..<attendanceStore.attendanceList.count {
                        //schedule update함수
                            switch changedAttendancList[index].attendanceStatus {
                            case "출석":
                                attendanceStatus[0] += 1
                            case "지각":
                                attendanceStatus[1] += 1
                            case "결석":
                                attendanceStatus[2] += 1
                            case "공결":
                                attendanceStatus[3] += 1
                            default:
                                print("error")
                                break
                            }
                            schedule.attendanceCount = attendanceStatus[0]
                            schedule.lateCount = attendanceStatus[1]
                            schedule.absentCount = attendanceStatus[2]
                            schedule.officiallyAbsentCount = attendanceStatus[3]
//                        
                        
                        //attendance update함수
                        if changedAttendancList[index] != attendanceStore.attendanceList[index] {
                            print(attendanceStore.attendanceList[index], "바뀐거")
                            attendanceStore.updateAttendace(attendanceData: changedAttendancList[index], scheduleID: schedule.id, uid: attendanceStore.attendanceList[index].id)
                        }
                        //todo 스케줄 컬렉션에 멤버 채우기
//                            attendanceStore.fetchAttendance(scheduleID: schedule.id)
//                            dismiss()
                    }
                    scheduleStore.updateScheduleAttendanceCount(schedule: schedule)
                    scheduleStore.fetchSchedule(gruopName: schedule.groupName)
                    attendanceStore.fetchAttendance(scheduleID: schedule.id)
                } label: {
                    Text("수정완료")
                }

            }
            
        }
        .onAppear {
            changedAttendancList = attendanceStore.attendanceList
            print(changedAttendancList, "생성")
            print(attendanceStore.attendanceList, "원래")
        }
        .onDisappear {
        }
        .navigationTitle("\(Date().yearMonthDayDateToString(date: schedule.startTime)) 출석부")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct EditScheduleAttendanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditScheduleAttendanceView(, schedule: <#Schedule#>)
//    }
//}
