//
//  CheckItButton.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItButton: View {
    @Binding var isActive: Bool
    @Binding var isAlert: Bool
    var text: String = "Check It!"
    var action: () -> () = {}
    
    var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .disabled(!isActive)
        .onTapGesture { isAlert = true }
    }
    
    var buttonLabel: some View {
        displayLabel
            .frame(height: 62)
            .overlay {
                Text("\(text)")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
    }
    
    
    //MARK: - ButtonLabel
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
    
    var displayLabel: some View {
        get {
            isActive ? AnyView(activeLabel) : AnyView(inActiveLabel)
        }
    }
}



