//
//  Report.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/26.
//

import Foundation

/// 신고 id
/// 신고한 동아리 Id
/// 신고자 id
/// 신고 내용
/// 신고 날짜
struct Report {
    var id: String
    var groupId: String
    var reporterId: String
    var content: String
    var date: Date
}
