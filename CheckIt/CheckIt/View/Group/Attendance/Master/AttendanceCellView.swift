//
//  AttendanceCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct AttendanceCellView: View {
    @EnvironmentObject var attendanceStore: AttendanceStore
    var schedule: Schedule
    
    var body: some View {
        HStack {
            VStack(alignment:.leading, spacing: 0) {
                Text(Date().yearMonthDayDateToString(date: schedule.startTime)) // 출석 날짜
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.top, 21)
                    .padding(.leading, 21)
                
                Spacer()
                
                HStack {
                    Text("출석")
                    Text("\(schedule.attendanceCount)")   //출석 횟수
                        .foregroundColor(.myGreen)
                        .bold()
                    
                    Divider().frame(height:20)
                    
                    Text("지각")
                    Text("\(schedule.lateCount)")   //지각 횟수
                        .foregroundColor(.myOrange)
                        .bold()
                    
                    Divider().frame(height:20)
                    
                    Text("결석")
                    Text("\(schedule.absentCount)")   //결석 횟수
                        .foregroundColor(.myRed)
                        .bold()
                    
                    Text("공결")
                    Text("\(schedule.officiallyAbsentCount)")   //공결 횟수
                        .foregroundColor(.myBlack)
                        .bold()
                }
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .medium))
                .padding(.leading, 21)
                .padding(.bottom, 21)
                
                
                Spacer()
            }
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.myLightGray)
                .frame(height: 90)
            
        }
        .frame(height: 90)
        .onAppear {
            print(attendanceStore.entireAttendanceList, "dd")
        }
    }
}

//struct AttendanceCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendanceCellView(, schedule: <#Schedule#>)
//    }
//}
