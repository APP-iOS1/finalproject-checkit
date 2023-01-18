//
//  ScheduleView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct TaskView: View {
    @Binding var currentDate: Date
    @Binding var currentMonth: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(extraData_MonthDay()[0]).\(extraData_MonthDay()[1]) \(extraData_MonthDay()[2])")
                    .font(.title2.bold())
                    .padding(.top, 25)
                
                ScrollView {
                    //MARK: 일정 디테일
                    HStack(spacing: 30) {
                        ExDivider(color: .myRed)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("3 : 20 PM")
                                .font(.body)
                            Text("신촌 베이스볼 모임")
                                .font(.body.bold())
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                    
                    HStack(spacing: 30) {
                        ExDivider(color: .myYellow)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("9 : 50 PM")
                                .font(.body)
                            Text("또리의 이력서 클럽")
                                .font(.body.bold())
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal,30)
            Spacer()
        }
    }
    
    //MARK: 현재 날짜의 달, 일(day), 요일만 String으로 변환. 반환형식 예시: 01
    ///달력이 나타내는 달, 일(day)을 알려주기 위한 함수. 현재 날짜(currentDate)변수의 데이터를 Date -> String 타입 변환,
    ///"MM DD"형식으로 반환. (예시: 01)
        func extraData_MonthDay() -> [String] {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "MM DD EEEE"
            
            let date = formatter.string(from: currentDate)
            
            return date.components(separatedBy: " ")
        }
}

//MARK: 일정 구분선
///달력 뷰에서 일정별로 구분해주는 선을 그려주는 구조체입니다. Color를 인자로 받습니다.
///해당 색은 구분선의 색으로 사용됩니다.
struct ExDivider: View {
    let color: Color
    let width: CGFloat = 5
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .frame(width: width, height: 45)
//            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
