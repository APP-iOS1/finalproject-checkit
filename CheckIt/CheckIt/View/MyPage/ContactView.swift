//
//  ContactView.swift
//  CheckIt
//
//  Created by sole on 2023/02/27.
//

import SwiftUI
import UIKit
import MessageUI

struct ComposeMailData {
  let subject: String
  let recipients: [String]?
  let message: String
}

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct ContactView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentation
  @Binding var data: ComposeMailData
  let callback: MailViewCallback

  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentation: PresentationMode
    @Binding var data: ComposeMailData
    let callback: MailViewCallback

    init(presentation: Binding<PresentationMode>,
         data: Binding<ComposeMailData>,
         callback: MailViewCallback) {
      _presentation = presentation
      _data = data
      self.callback = callback
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
      if let error = error {
        callback?(.failure(error))
      } else {
        callback?(.success(result))
      }
      $presentation.wrappedValue.dismiss()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(presentation: presentation, data: $data, callback: callback)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<ContactView>) -> MFMailComposeViewController {
    let viewController = MFMailComposeViewController()
    viewController.mailComposeDelegate = context.coordinator
    viewController.setSubject(data.subject)
    viewController.setToRecipients(data.recipients)
    viewController.setMessageBody(data.message, isHTML: false)
    viewController.accessibilityElementDidLoseFocus()
    return viewController
  }

  func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                              context: UIViewControllerRepresentableContext<ContactView>) {
  }

  static var canSendMail: Bool {
    MFMailComposeViewController.canSendMail()
  }
}
