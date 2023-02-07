//
//  EditScheduleAttendanceListCell.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/06.
//

import SwiftUI

struct EditScheduleAttendanceListCell: View {
    @Binding var data: Attendance
    @EnvironmentObject var userStore: UserStore
    @State private var userName: String = ""
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
    var body: some View {
        VStack {
            HStack {
                Text(userName)
                Spacer()
                Menu {
                    Button {
                        data.attendanceStatus = "출석"
                    } label: {
                        Text("출석")
                    }
                    Button {
                        data.attendanceStatus = "지각"
                    } label: {
                        Text("지각")
                    }
                    Button {
                        data.attendanceStatus = "결석"
                    } label: {
                        Text("결석")
                    }
                    Button {
                        data.attendanceStatus = "공결"
                    } label: {
                        Text("공결")
                    }
                } label: {
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
        .onAppear {
            userName = userStore.userDictionaryList[data.id] ?? ""
        }
    }
}

//struct EditScheduleAttendanceListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        EditScheduleAttendanceListCell()
//    }
//}
