//
//  NotPenaltyCostCellView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/07.
//

import SwiftUI

struct NotPenaltyCostCellView: View {
    @EnvironmentObject var userStore: UserStore
    var data: Attendance
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
    @State var userName: String = ""
    var body: some View {
        HStack {
            Text(userName)
                .font(.system(size: 16, weight: .regular))
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
        .onAppear {
            userName = userStore.userDictionaryList[data.id] ?? ""
        }
    }
}

//struct NotPenaltyCostCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotPenaltyCostCellView()
//    }
//}
