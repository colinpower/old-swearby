//
//  FRE10.swift
//  SwearBy
//
//  Created by Colin Power on 1/18/25.
//


import Foundation
import SwiftUI

struct FRE10: View {
    
    @Binding var showFRE: Bool
    @Binding var page: Int
    
    @State private var animate_screen_1: Bool = false
    @State private var animate_screen_2: Bool = false
    @State private var show_button_1: Bool = false
    @State private var show_button_2: Bool = false
    
    @State private var show_headline_1: Bool = true
    
    @State private var isVisible: Bool = false
    
    @State private var bg_opacity: CGFloat = 0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                Text("Try it in Safari")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
            }
            .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
            .padding(.top, 90)
            
            Spacer()
            
            let w = UIScreen.main.bounds.width * 0.65
            let h = 2.1729015152 * w
            let button_w = UIScreen.main.bounds.width * 0.1
            
            
            ZStack(alignment: .bottom) {
                
                Image("fre_demo_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: w, height: h)
                
                if show_button_1 {
                    
                    AnimatedTapIndicator(w: button_w)
                        .offset(y: -1 * (0.025 * h))
                    
                }
                
                Color.black.opacity(bg_opacity)
                    .frame(width: w, height: h)
                
                Image("fre_demo_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: w, height: h, alignment: .bottom)
                    .offset(y: animate_screen_1 ? 0 : h)
                
                if show_button_2 {
                    
                    AnimatedTapIndicator(w: button_w)
                        .offset(x: 0.07 * w, y: -1 * (0.32 * h))
                    
                }
                
                Image("fre_demo_3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: w, height: h, alignment: .bottom)
                    .offset(y: animate_screen_2 ? 0 : h)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.09))
            .background(RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.09).stroke(Color("text.black"), lineWidth: 20))
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .padding(.vertical)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                
                Button {
                    showFRE = false
                    
                } label: {
                    Text("Skip")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 60, alignment: .center)
                }
                
                Button(action: {
                    showFRE = false
                    
                    if let url = URL(string: "https://www.goodstoneinc.com/products/tennis-bracelet-1-80mm") {
                       UIApplication.shared.open(url)
                    }
                    
                }) {
                    FRE_Button11_Safari()
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            
            show_button_1 = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                show_button_1 = false
                
                withAnimation(.linear(duration: 0.5)) {
                    animate_screen_1.toggle()
                    bg_opacity = 0.15
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                show_button_2 = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
                
                show_button_2 = false
                
                withAnimation(.linear(duration: 0.5)) {
                    animate_screen_2.toggle()
                    bg_opacity = 0.4
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))
    }
}

struct FRE_Button11_Safari: View {
    
    var body: some View {
        
        ZStack(alignment: .center) {
            Capsule()
                .foregroundColor(.blue)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 60)
            HStack(alignment: .center, spacing: 0){
                Image(systemName: "safari.fill")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.trailing, 4)
                Text("Open link")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 60, alignment: .leading)
    }
}




