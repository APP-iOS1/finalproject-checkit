//
//  AttendancePickerView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendancePickerView: View {
    @Binding var selectedTap: AttendanceCategory
    var schedule: Schedule
    @EnvironmentObject var scheduleStore: ScheduleStore

    var body: some View {
        HStack {
            //출석
            Button {
                selectedTap = .attendanced
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.attendanced.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(scheduleStore.publishedAttendanceCount)")
                            .foregroundColor(.myGreen)
                    }
                    if selectedTap == .attendanced {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

            //지각
            Button {
                selectedTap = .lated
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.lated.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(scheduleStore.publishedLateCount)")
                            .foregroundColor(.myOrange)
                    }
                    if selectedTap == .lated {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

            //결석
            Button {
                selectedTap = .absented
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.absented.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(scheduleStore.publishedAbsentCount)")
                            .foregroundColor(.myRed)
                    }
                    if selectedTap == .absented {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

            //공결
            Button {
                selectedTap = .officiallyAbsented
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.officiallyAbsented.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(scheduleStore.publishedOfficiallyAbsentCount)")
                            .foregroundColor(.myBlack)
                    }
                    if selectedTap == .officiallyAbsented {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

        }
        .onAppear {
            print("AttendancePickerView온어피어")
            scheduleStore.fetchScheduleWithScheudleID(scheduleID: schedule.id)
        }
    }
}


//struct AttendancePickerView_Previews: PreviewProvider {
//    @State static var selectedTap = AttendanceCategory.attendanced
//    static var previews: some View {
//        AttendancePickerView(selectedTap: $selectedTap, schedule: <#Schedule#>)
//    }
//}
