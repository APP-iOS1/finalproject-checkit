//
//  AttendanceCategoryView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceCategoryView: View {
    @EnvironmentObject var attendanceStore: AttendanceStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @Binding var selection: AttendanceCategory
    var schedule : Schedule
//    @State var lateStatusAttendanceList: [Attendance] = []
    var body: some View {
        VStack {
//            switch selection {
//            case .attendanced:
//                AttendanceDetailStatusView(attendanceStatus: attendanceStore.attendanceStatusList, category: selection, schedule: schedule)
//            case .lated:
//                AttendanceDetailStatusView(attendanceStatus: attendanceStore.latedStatusList, category: selection, schedule: schedule)
//            case .absented:
//                AttendanceDetailStatusView(attendanceStatus: attendanceStore.absentedStatusList, category: selection, schedule: schedule)
//            case .officiallyAbsented:
//                AttendanceDetailStatusView(attendanceStatus: attendanceStore.officiallyAbsentedStatusList, category: selection, schedule: schedule)
//            }
            AttendanceDetailStatusView(category: selection, schedule: schedule)
        }
        .onAppear {

        }
    }
}

//struct AttendanceCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendanceCategoryView(selection: .attendanced)
//
//    }
//}
