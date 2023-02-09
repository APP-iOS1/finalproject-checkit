//
//  Ex+Date.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/01.
//

import Foundation

enum Status: String {
    case attendance = "출석"
    case late = "지각"
    case absent = "결석"
}

extension Date {
    /// date 인스턴스를 시간과 분으로 반환하는 메소드
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
    /// date 인스턴스를 연도-월-일로 반환하는 메소드
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
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
    
    func dateCompare(compareDate: Date) -> String {
        let now = Date.now
        let lateTime = compareDate.addingTimeInterval(300) //5분까지는 출석
        let absentTime = compareDate.addingTimeInterval(600) //5분 지나면
        if now < lateTime {
            return Status.attendance.rawValue
        }
        else if lateTime < now && now <= absentTime {
            return Status.late.rawValue
        }
        else if now > absentTime {
            return Status.absent.rawValue
        }
        return Status.attendance.rawValue
    }
}

