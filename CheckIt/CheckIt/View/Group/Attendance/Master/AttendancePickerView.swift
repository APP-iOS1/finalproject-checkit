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
            VStack(spacing: 8) {
                HStack(spacing: 3) {
                    Text(AttendanceCategory.attendanced.rawValue)
                        .foregroundColor(.primary)
                    Text("\(scheduleStore.publishedAttendanceCount)")
                        .foregroundColor(.myGreen)
                }
                .onTapGesture {
                    selectedTap = .attendanced
                }
                .font(.system(size: 18, weight: selectedTap == .attendanced ? .semibold : .medium))
                if selectedTap == .attendanced {
                    Capsule()
                        .foregroundColor(.primary)
                        .frame(height: 2)
                }
                else {
                    Capsule()
                        .foregroundColor(.white)
                        .frame(height: 0)
                }
                
            }

            //지각
            VStack(spacing: 8) {
                HStack(spacing: 3) {
                    Text(AttendanceCategory.lated.rawValue)
                        .foregroundColor(.primary)
                    Text("\(scheduleStore.publishedLateCount)")
                        .foregroundColor(.myOrange)
                }
                .font(.system(size: 18, weight: selectedTap == .lated ? .semibold : .medium))
                .onTapGesture {
                    selectedTap = .lated
                }
                if selectedTap == .lated {
                    Capsule()
                        .foregroundColor(.primary)
                        .frame(height: 2)
                }
                else {
                    Capsule()
                        .foregroundColor(.white)
                        .frame(height: 0)
                }
                
            }


            //결석
            VStack(spacing: 8) {
                HStack(spacing: 3) {
                    Text(AttendanceCategory.absented.rawValue)
                        .foregroundColor(.primary)
                    Text("\(scheduleStore.publishedAbsentCount)")
                        .foregroundColor(.myRed)
                }
                .font(.system(size: 18, weight: selectedTap == .absented ? .semibold : .medium))
                .onTapGesture {
                    selectedTap = .absented
                }
                if selectedTap == .absented {
                    Capsule()
                        .foregroundColor(.primary)
                        .frame(height: 2)
                }
                else {
                    Capsule()
                        .foregroundColor(.white)
                        .frame(height: 0)
                }
                
            }

            //공결
            VStack(spacing: 8) {
                HStack(spacing: 3) {
                    Text(AttendanceCategory.officiallyAbsented.rawValue)
                        .foregroundColor(.primary)
                    Text("\(scheduleStore.publishedOfficiallyAbsentCount)")
                        .foregroundColor(.primary)
                }
                .font(.system(size: 18, weight: selectedTap == .officiallyAbsented ? .semibold : .medium))
                .onTapGesture {
                    selectedTap = .officiallyAbsented
                }
                if selectedTap == .officiallyAbsented {
                    Capsule()
                        .foregroundColor(.primary)
                        .frame(height: 2)
                }
                else {
                    Capsule()
                        .foregroundColor(.white)
                        .frame(height: 0)
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
