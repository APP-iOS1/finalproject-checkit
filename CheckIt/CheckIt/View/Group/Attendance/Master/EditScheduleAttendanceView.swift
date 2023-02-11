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
    @State private var changedAttendance: Bool = false
    @State private var lottieAnimationCompletion: Bool = false
    @State private var idDismiss: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("\(Date().yearMonthDayDateToString(date: schedule.startTime)) 출석부")
                    .font(.system(size: 20, weight: .regular))
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                HStack(alignment: .center) {
                    Text("이름")
                        .offset(x:10)
                    Spacer()
                    Text("출석 현황")
                }
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.bottom)
                
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
                        changedAttendance = false
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
                            print(lottieAnimationCompletion, "컴플리션")

                        }
                    } label: {
                        Text("수정완료")
                    }
                    .disabled(!changedAttendance)

                }
                
            }
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.8)
                    LottieView(filename: "ThirdIndicator", completion: { value in
                        lottieAnimationCompletion = value
                        print(value, "로티애니메이션")
                    })
                        .frame(width: 150, height: 150)
                    }

                }
            }
        .onAppear {
            changedAttendancList = attendanceStore.attendanceList
            
            print(changedAttendancList, "생성")
            print(attendanceStore.attendanceList, "원래")
        }
        .onChange(of: changedAttendancList) { _ in
            if changedAttendancList != attendanceStore.attendanceList {
                changedAttendance = true
            }
            else {
                changedAttendance = false
            }
        }
//        .onChange(of: lottieAnimationCompletion) { newValue in
//            isLoading = false
//            dismiss()
//        }
    }
}

//struct EditScheduleAttendanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditScheduleAttendanceView(, schedule: <#Schedule#>)
//    }
//}

