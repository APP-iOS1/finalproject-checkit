//
//  AttendanceCategoryView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceCategoryView: View {
    @EnvironmentObject var attendanceStore: AttendanceStore
    var selection: AttendanceCategory
    var schedule : Schedule
//    @State var lateStatusAttendanceList: [Attendance] = []
    var body: some View {
        VStack {
            switch selection {
            case .attendanced:
                AttendanceDetailStatusView(attendanceStatus: attendanceStore.attendanceList.filter {$0.attendanceStatus == selection.rawValue}, category: selection, schedule: schedule, lateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }), changedLateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }))
            case .lated:
                AttendanceDetailStatusView(attendanceStatus: attendanceStore.attendanceList.filter {$0.attendanceStatus == selection.rawValue}, category: selection, schedule: schedule, lateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }), changedLateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }))
            case .absented:
                AttendanceDetailStatusView(attendanceStatus: attendanceStore.attendanceList.filter {$0.attendanceStatus == selection.rawValue}, category: selection, schedule: schedule, lateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }), changedLateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }))
            case .officiallyAbsented:
                AttendanceDetailStatusView(attendanceStatus: attendanceStore.attendanceList.filter {$0.attendanceStatus == selection.rawValue}, category: selection, schedule: schedule, lateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }), changedLateStatusAttendanceList: attendanceStore.attendanceList.filter({ $0.attendanceStatus == "지각" }))
            }
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
