//
//  LateCostView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI


struct AttendanceDetailView: View {
    @State private var selectedTap: AttendanceCategory = .attendanced
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    var schedule: Schedule
    var body: some View {
        VStack {
            Text("\(Date().yearMonthDayDateToString(date: schedule.startTime)) 출석부")
                .font(.system(size: 20, weight: .regular))
                .padding(.top, 10)
                .padding(.bottom, 20)
            AttendancePickerView(selectedTap: $selectedTap, schedule: schedule)
            AttendanceDetailStatusView(category: selectedTap, schedule: schedule)
            
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditScheduleAttendanceView(schedule: schedule)
                } label: {
                    Text("수정하기")
                }

            }
        }
        .onAppear {
            print(schedule.id, "스케줄 아이디")
            attendanceStore.fetchAttendance(scheduleID: schedule.id)
        }
        
    }
}

//struct LateCostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendanceDetailView()
//    }
//}
