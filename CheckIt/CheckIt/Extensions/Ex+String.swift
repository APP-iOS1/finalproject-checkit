//
//  Ex+String.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/01.
//

import Foundation

extension String {
    /// 문자열을 2023-03-01 12:20으로 반환하는 메소드
    func getAllTimeInfo() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter.date(from: self)!
    }
}
