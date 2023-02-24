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

extension String {
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let _ = self.range(of: ".") {
            let numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString)
                else { return self }
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString)
                else {
                    return self
                }
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        }
        else {
            guard let doubleValue = Double(self)
            else {
                return self
            }
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
}


extension String {
    /// 첫번째 글자부터 지정한 글자까지 출력할 수 있는 메서드입니다. 
    // to는 출력할 글자 수 3글자 출력 시 to에 3 입력
    func subString(to: Int) -> String {
        var ans: String = ""
        var len: Int = self.count < to ? self.count : to
        
        for index in 0 ..< len {
            ans += String(self[String.Index(encodedOffset: index)])
        }
        
        return ans
    }
}

