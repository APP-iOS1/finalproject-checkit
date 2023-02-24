//
//  CustomTextField.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/26.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    let placeholder: String
    let maximumCount: Int

    var body: some View {
      VStack {
        TextField("", text: $text, prompt: Text(placeholder))
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .stroke(isOverCount ? .red : .secondary)
          )
          .shakeEffect(trigger: isOverCount)
  //        .onChange(of: text) { newValue in
  //          if newValue.count > maximumCount {
  //            text = String(newValue.prefix(maximumCount))
  //          }
  //        }

        HStack {
          if isOverCount {
            Text("최대 \(maximumCount) 글자 까지만 입력해주세요.")
              .foregroundColor(.red)
          }

          Spacer()

          Text("\(text.count) / \(maximumCount)")
            .foregroundColor(isOverCount ? .red : .primary)
        }
        .font(.footnote)
      }
    }

    private var isOverCount: Bool {
      text.count > maximumCount
    }
  }

  // MARK: - 쉐이크 이펙트
  struct ShakeEffect: ViewModifier {

    var trigger: Bool

    @State private var isShaking = false

    func body(content: Content) -> some View {
      content // 수정자가 적용되는 곳 '위' 까지의 View
        .offset(x: isShaking ? -6 : .zero)
        .animation(.default.repeatCount(3).speed(6), value: isShaking)
        .onChange(of: trigger) { newValue in
          guard newValue else { return }
          isShaking = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isShaking = false
          }
        }
    }
  }

  extension View {

    /// 흔들리는 효과를 줍니다! 트리거가 true 가 되면 흔들림
    func shakeEffect(trigger: Bool) -> some View {
      modifier(ShakeEffect(trigger: trigger))
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(
          text: .constant("12341"),
          placeholder: "플레이스홀더",
          maximumCount: 5)
      }
}
