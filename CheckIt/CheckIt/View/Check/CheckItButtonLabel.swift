//
//  CheckItButton.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItButtonLabel: View {
    var isActive: Bool
    var text: String = "Check It!"
    // 
    private var inActiveLabel: some View {
        get {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.myGray)
        }
    }
    
    private var activeLabel: some View {
        get {
            LinearGradient(gradient: Gradient(colors: [.gradientLightGreen, .gradientGreen]),
                           startPoint: .top, endPoint: .bottom)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
    
    private var buttonLabel: some View {
        get {
            return isActive ? AnyView(activeLabel) : AnyView(inActiveLabel)
        }
    }
    var body: some View {
       buttonLabel
        .frame(height: 62)
        .overlay {
            Text("\(text)")
                .font(.title2.bold())
                .foregroundColor(.white)
        }
    }
}
//

//struct CheckItButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItButtonLabel()
//    }
//}
