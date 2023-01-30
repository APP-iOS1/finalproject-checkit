//
//  LateCostCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct LateCostCellView: View {
    var data: LateCost
    
    var attendanceColor: Color {
        switch data.attendance {
        case "출석":
            return Color.myGreen
        case "지각":
            return Color.myOrange
        case "결석":
            return Color.myRed
        case "공결":
            return Color.myBlack
        default:
            return Color.myBlack
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(data.name)
                
                Spacer()
                
                Text(data.attendance)
                    .foregroundColor(attendanceColor)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(attendanceColor, lineWidth: 1)
                    }
            }
        }
    }
}

struct LateCostCellView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceDetailView()
        //        LateCostCellView(data: LateCost(name: "이학진", attendance: "출석", cost: 0, isChecked: false))
    }
}
