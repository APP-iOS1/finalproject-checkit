//
//  PenaltyCostCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct PenaltyCostCellView: View {
    @Binding var data: Attendance
    var category: AttendanceCategory
    var attendanceColor: Color {
        switch data.attendanceStatus {
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
    @State var userName: String = {
        return ""
    }()
    var body: some View {
        VStack {
            HStack {
                //지각일 경우 정산 여부
                if category == .lated {
                    Button {
                        data.settlementStatus.toggle()
                        print(data, "ddddddddd")
                    } label: {
                        ZStack {
                            Image(systemName: "square")
                            if data.settlementStatus == true {
                                Image(systemName: "checkmark")
                            }
                        }
                    }

                }
                Text(userName)
                
                Spacer()
            
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 45, height: 25)
                    .foregroundColor(.white)
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(attendanceColor, lineWidth: 1)
                        Text(data.attendanceStatus)
                            .foregroundColor(attendanceColor)
                            .font(.caption)
                            .bold()
                    }
            }
        }
    }
}

//struct PenaltyCostCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendanceDetailView()
//        //        PenaltyCostCellView(data: LateCost(name: "이학진", attendance: "출석", cost: 0, isChecked: false))
//    }
//}
