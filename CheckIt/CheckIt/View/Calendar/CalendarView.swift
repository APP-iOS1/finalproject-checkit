//
//  CalendarView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    @State var currentDate: Date = Date()
    @State var currentMonth: Int = 0
    @State private var selectedGroup = "전체"
    @State private var totalSchedule: [Schedule] = []
    @State private var totalAttendance: [Attendance] = []
    
    var body: some View {
        VStack {
            CustomDatePickerView(currentDate: $currentDate, selectedGroup: $selectedGroup, totalSchedule: $scheduleStore.calendarSchedule, totalAttendance: $attendanceStore.attendanceList, currentMonth: $currentMonth)
                .padding(.horizontal)
            
            Divider()
            
            //일정섹션
            TaskView(currentDate: $currentDate, totalSchedule: $scheduleStore.calendarSchedule, totalAttendance: $attendanceStore.attendanceList, selectedGroup: $selectedGroup)
            //                .padding(.top, -8)
            Spacer()
        }
        .padding(.vertical)
        .onAppear {
            
        }
    }
}

//MARK: - 현재 달(month) 날짜들을 Date 타입으로 Get
extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        return range?.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        } ?? []
    }
    // MARK: - 날짜 비교
    public func dateCompare(fromDate: Date) -> String {
            var strDateMessage:String = ""
            let result:ComparisonResult = self.compare(fromDate)
            switch result {
            case .orderedAscending:
                strDateMessage = "Future"
                break
            case .orderedDescending:
                strDateMessage = "Past"
                break
            case .orderedSame:
                strDateMessage = "Same"
                break
            default:
                strDateMessage = "Error"
                break
            }
            return strDateMessage
        }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
