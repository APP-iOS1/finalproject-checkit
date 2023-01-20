//
//  ScheduleView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

//MARK: - 날짜 output class
class ExtraData: ObservableObject {
    let formatter = DateFormatter()
    var date: String = ""
    
    //MARK: - Date 데이터를 String으로 변환. 반환형식 예시: 2023 01 02 월요일 AM 01 22
    ///달력이 나타내는 날짜를 알려주기 위한 클래스. 현재 날짜(currentDate)변수의 데이터를 Date -> String 타입 변환,
    ///"MM DD"형식으로 반환. (예시: 01)
    func selectedDate(date: Date) -> [String] {
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "YYYY MM DD EEEE a HH mm"
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        self.date = formatter.string(from: date)
        print(type(of: formatter.locale))
        return self.date.components(separatedBy: " ")
    }
    
    //MARK: - 날짜 비교
    ///날짜를 비교하는 함수. date1, date2를 인수로 받는다.
    ///반환 타입은 Bool
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct TaskView: View {
    @ObservedObject var extraData = ExtraData()
    
    @Binding var currentDate: Date
    @Binding var currentMonth: Int
    
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
