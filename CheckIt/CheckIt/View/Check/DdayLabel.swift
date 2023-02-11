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
            .frame(width: 65, height: 35.16)
            .foregroundColor(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.myOrange)
                    .frame(width: 65, height: 35)
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
            .onTapGesture {
                print("d-day 결과 : \(dDay)")
            }
    }
}

struct DdayLabel_Previews: PreviewProvider {
    static var previews: some View {
        DdayLabel()
    }
}
