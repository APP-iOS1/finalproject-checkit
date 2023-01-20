//
//  AttendanceDetailStatusView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceDetailStatusView: View {
    var attendanceStatus: [LateCost]
    var category: AttendanceCategory
    
    var body: some View {
        VStack(alignment: .center) {
            makeView(.attendanced)
                .padding(.bottom)
            
            ForEach(attendanceStatus, id: \.self) { item in
                LateCostCellView(data: item)

                Divider()
                    .frame(minWidth: UIScreen.main.bounds.width)
            }
            .padding(.vertical, 5)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    func makeView(_ status: AttendanceCategory) -> some View {
        HStack {
            switch status {
            case .attendanced:
                Text("이름")
                Spacer()
                Text("출석현황")
            case .lated:
                Text("이름")
                Spacer()
                Text("출석현황")
            case .absented:
                Text("이름")
                Spacer()
                Text("출석현황")
            case .officalyAbsented:
                Text("이름")
                Spacer()
                Text("출석현황")
            }
        }
        .font(.title3)
    }
}

struct AttendanceDetailStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
