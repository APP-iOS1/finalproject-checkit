//
//  LottieView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/09.
//

import Lottie
import SwiftUI
import UIKit
 
struct LottieView: UIViewRepresentable {
    
    //5.
    var filename: String
    var completion: LottieCompletionBlock?
    let animationView = LottieAnimationView()
    
    var toFrame: Int
    
    func makeUIView(context: Context) -> UIView {
        //3.
        let view = UIView(frame: .zero)

        animationView.animation = .named(filename)
        
        animationView.contentMode = .scaleAspectFit
        
        // send-invitation 로티 애니메이션만 사이즈 키우기
        if filename == "send-invitation" {
            animationView.contentMode = .scaleAspectFill
        }

//        animationView.loopMode = .playOnce
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.7

        
        animationView.play(fromFrame: 1, toFrame: AnimationFrameTime(toFrame), completion: completion)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        

        NSLayoutConstraint.activate([
//            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {

    }
    
}

