//
//  Schedule.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation

struct Schedule: Identifiable, Hashable {
    var id: String
    var groupName: String // 동아리명
    var lateFee: Int
    var absenteeFee: Int
    var location: String
    var startTime: Date // 2023년 4월 10일 15시 00
    var endTime: Date  // 2023년 4월 10일 18시 00
    var agreeTime: Int
    var memo: String
    var attendanceCount: Int
    var lateCount: Int
    var absentCount: Int
    var officiallyAbsentCount: Int
}
