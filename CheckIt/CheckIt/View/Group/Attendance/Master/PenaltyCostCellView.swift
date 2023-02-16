//
//  PenaltyCostCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct PenaltyCostCellView: View {
    @EnvironmentObject var userStore: UserStore
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
                Button {
                    data.settlementStatus.toggle()
                    print(data, "ddddddddd")
                } label: {
                    Image(systemName: data.settlementStatus ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.primary)
                }
                .frame(width: 70)
                Text(" \(userName)")
                    .font(.system(size: 16, weight: .regular))
                    .offset(x:-5)
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
            .offset(x:-10)
        }
        .frame(height: 40)
        .onAppear {
            userName = userStore.userDictionaryList[data.id] ?? ""
        }
    }
}

//struct PenaltyCostCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendanceDetailView()
//        //        PenaltyCostCellView(data: LateCost(name: "이학진", attendance: "출석", cost: 0, isChecked: false))
//    }
//}
