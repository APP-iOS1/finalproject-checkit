//
//  Ex+View.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/14.
//

import Foundation
import SwiftUI

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
