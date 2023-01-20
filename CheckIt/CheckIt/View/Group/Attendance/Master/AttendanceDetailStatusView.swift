//
//  AttendanceDetailStatusView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceDetailStatusView: View {
    var attendanceStatus: [LateCost]
    
    var body: some View {
        ForEach(attendanceStatus, id: \.self) { item in
            LateCostCellView(data: item)
        }
    }
}

struct AttendanceDetailStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
