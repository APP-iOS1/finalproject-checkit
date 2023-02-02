//
//  Card.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/01.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var id: Int
    var dDay: String
    var groupName: String
    var place: String
    var date: String
    var time: String
    var groupImage: Image
    var isActiveButton: Bool
    var show: Bool
}
