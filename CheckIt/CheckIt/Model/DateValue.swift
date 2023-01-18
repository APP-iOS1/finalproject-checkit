//
//  DateValue.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import Foundation

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
