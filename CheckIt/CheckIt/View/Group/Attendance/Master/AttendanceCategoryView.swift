//
//  AttendanceCategoryView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceCategoryView: View {
    var selection: AttendanceCategory
    
    @State private var tempCostData: [LateCost] = [
        LateCost(name: "허혜민", attendance: "출석", cost: 0),
        LateCost(name: "윤예린", attendance: "출석", cost: 0),
        LateCost(name: "류창휘", attendance: "결석", cost: 5000),
        LateCost(name: "황예리", attendance: "출석", cost: 0),
        LateCost(name: "조현호", attendance: "공결", cost: 0),
        LateCost(name: "이학진", attendance: "지각", cost: 500),
        LateCost(name: "허혜민", attendance: "출석", cost: 0),
        LateCost(name: "윤예린", attendance: "출석", cost: 0),
        LateCost(name: "류창휘", attendance: "결석", cost: 5000),
        LateCost(name: "황예리", attendance: "출석", cost: 0),
        LateCost(name: "조현호", attendance: "공결", cost: 0),
        LateCost(name: "이학진", attendance: "지각", cost: 500)
    ]
    
    var body: some View {
        VStack {
            switch selection {
            case .attendanced:
                AttendanceDetailStatusView(attendanceStatus: tempCostData.filter {$0.attendance == selection.rawValue}, category: selection)
            case .lated:
                AttendanceDetailStatusView(attendanceStatus: tempCostData.filter {$0.attendance == selection.rawValue}, category: selection)
            case .absented:
                AttendanceDetailStatusView(attendanceStatus: tempCostData.filter {$0.attendance == selection.rawValue}, category: selection)
            case .officalyAbsented:
                AttendanceDetailStatusView(attendanceStatus: tempCostData.filter {$0.attendance == selection.rawValue}, category: selection)
            }
        }
    }
}

struct AttendanceCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceCategoryView(selection: .attendanced)
        
    }
}
