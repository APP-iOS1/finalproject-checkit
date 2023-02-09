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
    @State var isLoading: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("\(Date().yearMonthDayDateToString(date: schedule.startTime)) 출석부")
                    .font(.system(size: 20, weight: .regular))
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                HStack(alignment: .center) {
                    Text("이름")
                    Spacer()
                    Text("출석 현황")
                    
                }
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 30)
                
                ScrollView {
                    ForEach(changedAttendancList.indices, id: \.self) { index in
                        EditScheduleAttendanceListCell(data: $changedAttendancList[index])
                        Divider()
                    }
                }

            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isLoading = true
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
                        }


                        Task {
                            await scheduleStore.updateScheduleAttendanceCount(schedule: schedule)
                            await scheduleStore.fetchSchedule(groupName: schedule.groupName)
                            isLoading = false
                            dismiss()
                        }
                    } label: {
                        Text("수정완료")
                    }

                }
                
            }
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.8)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .myGreen))
                        .scaleEffect(4)
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
    }
}

//struct EditScheduleAttendanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditScheduleAttendanceView(, schedule: <#Schedule#>)
//    }
//}
