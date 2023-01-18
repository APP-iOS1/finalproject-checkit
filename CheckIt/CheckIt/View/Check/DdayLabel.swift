//
//  DdayLabel.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct DdayLabel: View {
    var dDay: String = "D-day"
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 65, height: 35)
            .foregroundColor(.white)
            .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.myYellow)
                        .frame(width: 65, height: 35)
            }
            .overlay {
                Text("\(dDay)")
                    .font(.callout.bold())
                    .foregroundColor(.myYellow)
                    
            }
    }
}

struct DdayLabel_Previews: PreviewProvider {
    static var previews: some View {
        DdayLabel()
    }
}
