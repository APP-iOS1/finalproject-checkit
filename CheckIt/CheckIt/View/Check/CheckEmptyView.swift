//
//  CheckEmptyView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/11.
//

import SwiftUI

struct CheckEmptyView: View {
    @EnvironmentObject var userStore: UserStore
    
    var userName: String {
        "\(userStore.user?.name ?? " ")"
    }
    
    var isUserLogin: String {
        if let user = userStore.user {
            return "님"
        } else { return ""}
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: UIScreen.screenHeight * 0.02) {
            Text("환영합니다. \(userName) \(isUserLogin) 🙌🏻")
                .font(.system(size: 22, weight: .semibold))

            HStack(spacing: 2) {
                Text("Check It")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.myGreen)
                
                Text("으로 동아리를 시작해 보세요!")
                    .font(.system(size: 18, weight: .regular))
            }
        }
    }
}

struct CheckEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        CheckEmptyView()
    }
}
