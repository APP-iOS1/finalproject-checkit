//
//  ScheduleView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct TaskView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("01.17 수요일")
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
