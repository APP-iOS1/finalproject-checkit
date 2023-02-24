//
//  DdayLabel.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct DdayLabel: View {
    var dDay: Int = 0
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 60, height: 28.16)
            .foregroundColor(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.myOrange)
                    .frame(width: 60, height: 28)
            }
            .overlay {
                if dDay != 0 {
                    Text("D-\(dDay)")
                } else {
                    Text("D-day")
                }
            }
            .font(.system(size: 13).bold())
            .foregroundColor(.myOrange)
    }
}

struct nonDdayLabel: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 60, height: 28.16)
            .foregroundColor(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
                    .frame(width: 60, height: 28)
            }
            .overlay {
                    Text("-")
            }
            .font(.system(size: 13).bold())
            .foregroundColor(.gray)
    }
}

struct DdayLabel_Previews: PreviewProvider {
    static var previews: some View {
        DdayLabel()
    }
}
