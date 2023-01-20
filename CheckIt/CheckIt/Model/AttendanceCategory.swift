//
//  AttendanceCategory.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import Foundation

enum AttendanceCategory: CaseIterable, String {
    case attendanced = "출석"
    case lated = "지각"
    case absented = "결석"
    case officalyAbsented = "공결"
}
