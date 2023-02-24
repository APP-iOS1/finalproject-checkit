//
//  Attendance.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation

struct Attendance: Identifiable, Equatable {
    var id: String
    var scheduleId: String
    var attendanceStatus: String
    var settlementStatus: Bool
}
