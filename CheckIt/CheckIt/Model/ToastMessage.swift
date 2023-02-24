//
//  ToastMessage.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/13.
//

import Foundation

enum ToastType {
    case competion
    case failed
}

struct ToastMessage {
    var message: String
    var type: ToastType
}
