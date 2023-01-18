//
//  CheckItButton.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItButtonLabel: View {
    var isActive: Bool
    var buttonColor: Color {
        get{ isActive ? .myGreen : .myGray }
    }
    var text: String = "Check It!"
    var buttonText: String {
        get { text }
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(height: 62)
            .foregroundColor(buttonColor)
            .overlay{
                Text("\(buttonText)")
                    .foregroundColor(.white)
                    .font(.title2.bold())
            }
    }
}

//struct CheckItButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItButtonLabel()
//    }
//}
