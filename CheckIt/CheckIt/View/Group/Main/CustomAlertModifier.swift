//
//  CustomAlertModifier.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/06.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {

  @Binding var isPresented: Bool
  let title: String
    let textField: String
  let message: String
  let primaryButtonTitle: String
  let primaryAction: () -> Void
  let withCancelButton: Bool

  init(
    isPresented: Binding<Bool>,
    title: String,
    textField: String,
    message: String,
    primaryButtonTitle: String,
    primaryAction: @escaping () -> Void,
    withCancelButton: Bool)
  {
    _isPresented = isPresented
    self.title = title
    self.message = message
      self.textField = textField
    self.primaryButtonTitle = primaryButtonTitle
    self.primaryAction = primaryAction
    self.withCancelButton = withCancelButton
  }

  func body(content: Content) -> some View {
    ZStack {
      content

      ZStack {
        if isPresented {
          Rectangle()
            .fill(.black.opacity(0.3))
            .ignoresSafeArea()
            .transition(.opacity)

          CustomAlert(
            isPresented: _isPresented,
            title: self.title,
            textField: self.textField,
            message: self.message,
            primaryButtonTitle: self.primaryButtonTitle,
            primaryAction: self.primaryAction,
            withCancelButton: self.withCancelButton)
          .transition(
            .asymmetric(
              insertion: .move(edge: .leading).combined(with: .opacity),
              removal: .move(edge: .trailing).combined(with: .opacity)))
        }
      }
      .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
  }
}

extension View {

  func customAlert(
    isPresented: Binding<Bool>,
    title: String,
    textField: String,
    message: String,
    primaryButtonTitle: String,
    primaryAction: @escaping () -> Void,
    withCancelButton: Bool) -> some View
  {
    modifier(
      CustomAlertModifier(
        isPresented: isPresented,
        title: title,
        textField: textField,
        message: message,
        primaryButtonTitle: primaryButtonTitle,
        primaryAction: primaryAction,
        withCancelButton: withCancelButton))
  }
}

struct CustomAlertModifier_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Text("가즈아")
    }
    .modifier(
      CustomAlertModifier(
        isPresented: .constant(true),
        title: "제목",
        textField: "textField",
        message: "내용",
        primaryButtonTitle: "확인버튼",
        primaryAction: { },
        withCancelButton: true)
    )
  }
}
