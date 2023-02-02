//
//  DateExtension.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/01.
//

import Foundation

extension Date {
    func yearMonthDayDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    func monthDayDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    func hourMinuteDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
