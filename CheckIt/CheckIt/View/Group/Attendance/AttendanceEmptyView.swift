//
//  AttendanceEmptyView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/10.
//

import SwiftUI

struct AttendanceEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: UIScreen.screenHeight * 0.02) {
            Image("grayBox")
                .resizable()
                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.1)
                .padding()
                
            Text("아직 성사된 만남이 없어요.🥹")
                .font(.system(size: 22, weight: .semibold))
            
            Text("출석부로 해당 일정의 출석 현황\n 및 정산 여부를 관리해 보세요.")
                .font(.system(size: 18, weight: .regular))
        }
    }
}

struct AttendanceEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceEmptyView()
    }
}
