//
//  GroupEmptyView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/03.
//

import SwiftUI

struct GroupEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: UIScreen.screenHeight * 0.02) {
            Image("grayBox")
                .resizable()
                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.1)
                .padding()
                
            Text("아직 가입된 동아리가 없어요.😢")
                .font(.system(size: 22, weight: .semibold))
            
            Text("+ 버튼으로 동아리를 개설하거나\n초대된 동아리에 가입해 보세요.")
                .font(.system(size: 18, weight: .regular))
        }
    }
}

struct GroupEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        GroupEmptyView()
    }
}
