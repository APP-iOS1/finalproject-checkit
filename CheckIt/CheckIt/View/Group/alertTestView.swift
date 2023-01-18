//
//  alertTestView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct alertTestView: View {
    @State private var quitGroupButtonToggle: Bool = false
    var body: some View {
        ZStack {
                VStack {
                    Button {
                        quitGroupButtonToggle = true
                    } label: {
                        Text("ss")
                    }

                }
            if quitGroupButtonToggle == true {
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.4))
                        .ignoresSafeArea()
                    QuitGroupAlert(cancelButtonTapped: $quitGroupButtonToggle)
                        .padding(.horizontal, 30)
                }
                .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
            }
        }
    }
}

struct alertTestView_Previews: PreviewProvider {
    static var previews: some View {
        alertTestView()
    }
}
