//
//  GroupPosition.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/20.
//

import SwiftUI

struct GroupPosition: View {
    @Binding var position: String
    var color: Color  {
        switch position {
        case "방장":
            return .myGreen
        case "운영진":
            return .myOrange
        case "구성원":
            return .black
        default:
            return .black
        }
    }
    var body: some View {
        Text(position)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(color)
            .frame(width: 46, height: 20)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: 1))
    }
}

struct GroupPosition_Previews: PreviewProvider {
    static var previews: some View {
        GroupPosition(position: .constant("방장"))
    }
}
