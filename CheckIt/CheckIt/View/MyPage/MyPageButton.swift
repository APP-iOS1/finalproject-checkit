//
//  MyPageButton.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct MyPageButton: View {
    @Binding var buttonTitle : String
    @Binding var buttonImage : String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: buttonImage)
            
            Text(buttonTitle)
                .font(.system(size: 20, weight: .semibold))
        }
        .foregroundColor(.primary)
        .frame(minHeight: 30, maxHeight: 58)
    }
}

struct MyPageButton_Previews: PreviewProvider {
    static var previews: some View {
        MyPageButton(buttonTitle: .constant("프리미엄 요금제 알아보기"), buttonImage: .constant("checkmark.seal"))
            .previewLayout(.sizeThatFits)
    }
}
