//
//  ReactiveButtonStyle.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/06.
//

import SwiftUI

struct ReactiveButtonStyle: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
    configuration.label // 버튼의 내부 콘텐츠
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(.primary)
          .colorInvert() // 자기가 적용된 곳 위에 컬러를 반전 (단, 스코프까지)
          .shadow(
            color: .primary.opacity(0.2),
            radius: configuration.isPressed ? 2 : 6,
            x: configuration.isPressed ? -2 : 6,
            y: configuration.isPressed ? -2 : 6)
      )
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
  }
}

extension ButtonStyle where Self == ReactiveButtonStyle {

  /// 그림자로 만든 커스텀 뉴모피즘 버튼 스타일입니다.
  static var reative: ReactiveButtonStyle {
    .init()
  }
}

struct ReactiveButton_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Button(action: { }) {
        Text("안녕하세요")
      }
      .buttonStyle(ReactiveButtonStyle())
    }
  }
}
