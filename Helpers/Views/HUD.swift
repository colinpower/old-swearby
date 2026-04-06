//
//  HUD.swift
//  SwearBy
//
//  Created by Colin Power on 7/13/23.
//

import Foundation
import SwiftUI


struct HUD: View {
    @ViewBuilder var body: some View {
        Text("Saved image")
            .foregroundColor(.gray)
            .padding(.horizontal, 10)
            .padding(14)
            .background(
                Blur(style: .systemMaterial)
                    .clipShape(Capsule())
                    .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
            )
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
