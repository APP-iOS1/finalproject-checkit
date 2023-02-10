//
//  ScheduleEmptyView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/09.
//

import SwiftUI

struct ScheduleEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: UIScreen.screenHeight * 0.02) {
            Image("grayBox")
                .resizable()
                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.1)
                .padding()
                
            Text("아직 생성된 일정이 없어요.😥")
                .font(.system(size: 22, weight: .semibold))

            Text("+ 버튼으로 일정을 추가해서\n출석 현황을 관리해 보세요.")
                .font(.system(size: 18, weight: .regular))
        }
    }
}

struct ScheduleEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleEmptyView()
    }
}
