//
//  AttendanceCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct AttendanceCellView: View {
//    var attendance: [Attendance?]
    @EnvironmentObject var attendanceStore: AttendanceStore
    var schedule: Schedule?

//    var attendanceStatusCount: Int {
//        switch attendance. {
//        case "출석":
//
//        }
//    }
//    var attendanceColor: Color {
//        switch data.attendance {
//        case "출석":
//            return Color.myGreen
//        case "지각":
//            return Color.myOrange
//        case "결석":
//            return Color.myRed
//        case "공결":
//            return Color.myBlack
//        default:
//            return Color.myBlack
//        }
//    }
    @State private var attendanceCount: Int = 0
    @State private var latenessCount: Int = 0
    @State private var absenteCount: Int = 0
    @State private var officialAbsenceeCount: Int = 0
    
    
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                Text(Date().yearMonthDayDateToString(date: schedule?.startTime ?? Date())) // 출석 날짜
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 15)
                
                Spacer()
                
                HStack {
                    Text("출석")
                    Text("\(attendanceCount)")   //출석 횟수
                        .foregroundColor(.myGreen)
                        .bold()
                    
                    Divider().frame(height:20)
                    
                    Text("지각")
                    Text("\(latenessCount)")   //지각 횟수
                        .foregroundColor(.myOrange)
                        .bold()
                    
                    Divider().frame(height:20)
                    
                    Text("결석")
                    Text("\(absenteCount)")   //결석 횟수
                        .foregroundColor(.myRed)
                        .bold()
                    
                    Text("공결")
                        
                    Text("\(officialAbsenceeCount)")   //공결 횟수
                        .foregroundColor(.myRed)
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
            if let id = schedule?.id {
                for attendance in attendanceStore.entireAttendanceList[id] ?? [] {
                    switch attendance.attendanceStatus {
                    case "출석":
                        attendanceCount += 1
                    case "지각":
                        latenessCount += 1
                    case "결석":
                        absenteCount += 1
                    case "공결":
                        officialAbsenceeCount += 1
                    default:
                        print("")
                    }
                }
            }
            print(attendanceStore.entireAttendanceList, "dd")
        }
    }
}

struct AttendanceCellView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceCellView()
    }
}
