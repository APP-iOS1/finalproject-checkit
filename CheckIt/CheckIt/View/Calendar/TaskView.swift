//
//  ScheduleView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var extraData = ExtraData()
    
    @Binding var currentDate: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                //MARK: - 일정 날짜
                Text("\(extraData.selectedDate(date: currentDate)[1]).\(extraData.selectedDate(date: currentDate)[2]) \(extraData.selectedDate(date: currentDate)[3])")
                    .font(.title2.bold())
                    .padding(.top, 25)
                
                ScrollView(showsIndicators: false) {
                    //MARK: - 일정 디테일
                    if let task = tasks.first(where: { task in
                        return extraData.isSameDay(date1: task.taskDate, date2: currentDate)
                    }){
                        ForEach(tasks){ task in
                            HStack(spacing: 30) {
                                ExDivider(color: .myRed)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(extraData.selectedDate(date: task.taskDate)[5]):\(extraData.selectedDate(date: task.taskDate)[6]) \(extraData.selectedDate(date: task.taskDate)[4])")
                                        .font(.body)
                                    Text(task.task[0].title)
                                        .font(.body.bold())
                                }
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            .padding(.top, 20)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
            }
            .padding(.horizontal,30)
            Spacer()
        }
    }
    
//    //MARK: - Day GET
//    ///현재 달(month) 받아오는 함수
//    func getCurrentDay() -> Date {
//        let calendar = Calendar.current
//
//        guard let currentDay = calendar.date(byAdding: .day, value: self.currentDay, to: Date()) else { return Date() }
//
//        return currentDay
//    }
}

//MARK: - 일정 구분선
///달력 뷰에서 일정별로 구분해주는 선을 그려주는 구조체입니다. Color를 인자로 받습니다.
///해당 색은 구분선의 색으로 사용됩니다.
struct ExDivider: View {
    let color: Color
    let width: CGFloat = 5
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .frame(width: width, height: 45)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
