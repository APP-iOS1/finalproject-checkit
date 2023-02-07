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
            VStack(alignment:.leading) {
                Text(Date().yearMonthDayDateToString(date: schedule.startTime)) // 출석 날짜
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 15)
                
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
                
                Spacer()
            }
            .padding()
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.myLightGray)
                .frame(height: 120)
            
        }
        .frame(height: 120)
        .padding()
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
