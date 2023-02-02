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
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.myLightGray)
                    .frame(width: .infinity, height:100)
                    .padding(.horizontal, 40)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(Date().hourMinuteDateToString(date: schedule?.startTime ?? Date()))
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 45, height: 25)
                        .foregroundColor(.white)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myBlack, lineWidth: 1)
                            Text(attendance?.attendanceStatus ?? "")
                                .foregroundColor(Color.myBlack)
                                .font(.caption)
                                .bold()
                        }
                }
                .padding(.bottom, 10)
                
                HStack {
                    Text("\(Date().hourMinuteDateToString(date: schedule?.startTime ?? Date())) ~ \(Date().hourMinuteDateToString(date: schedule?.endTime ?? Date()))")
                        .font(.subheadline)
                    Spacer()
                    
                    Text(String(schedule?.lateFee ?? 0))
                        .bold()
                }
            }
            .padding(.horizontal, 70)
        }
        .padding(.vertical, 10)
    }
}

struct AttendanceStatusListCell_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusListCell()
    }
}
