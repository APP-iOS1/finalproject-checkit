//
//  Modifiers.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI

// MARK: -Modifier : 동아리 탭에서 사용하는 버튼 속성
struct GruopCustomButtonModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 60)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .background(Color.myGreen)
            .cornerRadius(15)
    }
}
