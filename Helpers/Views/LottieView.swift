//
//  LottieView.swift
//  SwearBy
//
//  Created by Colin Power on 1/20/25.
//

import Foundation
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var url: URL
    
    var isLooping: Bool = true
    
    var shouldPause: Bool = false
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
        ])
        
        DotLottieFile.loadedFrom(url: url) { result in
            switch result {
            case .success(let success):
                animationView.loadAnimation(from: success)
                animationView.loopMode = isLooping ? .loop : .playOnce
                if shouldPause {
                    animationView.pause()
                } else {
                    animationView.play()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
