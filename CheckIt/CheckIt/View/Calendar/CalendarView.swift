//
//  CalendarView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

//MARK: - 샘플 일정 데이터
struct SampleTask: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [SampleTask]
    var taskDate: Date
}

func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [TaskMetaData] = [
    TaskMetaData(task: [
        SampleTask(title: "샘플1"),
        SampleTask(title: "샘플2"),
        SampleTask(title: "샘플3")
    ], taskDate: getSampleDate(offset: 1)),
    
    TaskMetaData(task: [
        SampleTask(title: "샘플4")
    ], taskDate: getSampleDate(offset: -3)),
    
    TaskMetaData(task: [
        SampleTask(title: "샘플5"),
        SampleTask(title: "샘플6")
    ], taskDate: getSampleDate(offset: -8)),
    
    TaskMetaData(task: [
        SampleTask(title: "샘플7"),
        SampleTask(title: "샘플8"),
        SampleTask(title: "샘플9"),
        SampleTask(title: "샘플10")
    ], taskDate: getSampleDate(offset: 20))
]

//MARK: - 메인 뷰
struct CalendarView: View {
    
    @State var currentDate: Date = Date()
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack {
            //달력섹션
            CustomDatePickerView(currentDate: $currentDate, currentMonth: $currentMonth)
            
            Divider()
            
            //일정섹션
            TaskView(currentDate: $currentDate)
            Spacer()
        }
        .padding(.vertical)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
