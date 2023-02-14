//
//  AttendanceStatusLIstCell.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/01.
//

import SwiftUI

struct AttendanceStatusListCell: View {
    var schedule: Schedule?
    var attendance: Attendance?
    
    var attendanceColor: Color {
        switch attendance?.attendanceStatus {
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
    var userCost: String {
        switch attendance?.attendanceStatus {
        case "출석":
            return ""
        case "지각":
            if attendance?.settlementStatus == true {
                return ""
            }
            else {
                return "\(String(schedule?.lateFee ?? 0).insertComma) 원"
            }
        case "결석":
            if attendance?.settlementStatus == true {
                return ""
            }
            else {
                return "\(String(schedule?.absenteeFee ?? 0).insertComma) 원"
            }
        case "공결":
            return ""
        default:
            return ""
        }
    }
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.myLightGray)
                    .frame(height:100)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(Date().yearMonthDayDateToString(date: schedule?.startTime ?? Date()))
                        .foregroundColor(.black)
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 45, height: 25)
                        .foregroundColor(.white)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(attendanceColor, lineWidth: 1)
                            Text(attendance?.attendanceStatus ?? "")
                                .foregroundColor(attendanceColor)
                                .font(.caption)
                                .bold()
                        }
                }
                
                HStack {
                    Text("\(Date().hourMinuteDateToString(date: schedule?.startTime ?? Date())) ~ \(Date().hourMinuteDateToString(date: schedule?.endTime ?? Date()))")
                        .foregroundColor(.black)
                        .font(.subheadline)
                    Spacer()
                    
                    //수정 필요
                    Text(userCost)
                        .foregroundColor(.black)
                        .bold()
                }
            }
            .padding(.horizontal, 20)
        }
        //.padding(.horizontal, 20)
    }
}

struct AttendanceStatusListCell_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusListCell()
    }
}
