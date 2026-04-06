//
//  FRE3.swift
//  SwearBy
//
//  Created by Colin Power on 1/18/25.
//



import Foundation
import SwiftUI


struct FRE3: View {
    
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
            
            if show_headline_1 {
                HStack(alignment: .center, spacing: 0) {
                    Text("Just tap")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.trailing, 12)
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }
                .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
                .padding(.top, 90)
            } else {
                HStack(alignment: .center, spacing: 0) {
                    Text("Then tap")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.bottom, 9)
                        .padding(.trailing, 12)
                    VStack(alignment: .center, spacing: 0) {
                        Image("SwearByIcon")
                            .resizable()
                            .frame(width: 48, height: 48)
                        Text("SwearBy")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(Color("text.black"))
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
                .padding(.top, 90)
            }
            
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
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            animate_screen_1.toggle()
                            bg_opacity = 0.15
                        }
                        
                        show_button_1 = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            show_headline_1 = false
                            show_button_2 = true
                        }
                        
                    } label: {
                        AnimatedTapIndicator(w: button_w)
                            
                    }
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
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            animate_screen_2.toggle()
                            bg_opacity = 0.4
                        }
                        show_button_2 = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            isVisible = true
                        }
                    } label: {
                        AnimatedTapIndicator(w: button_w)
                    }
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
            
            Button {
                page = 6
            } label: {
                FRE_Button2(isVisible: $isVisible)
            }
            .disabled(!isVisible)
            .padding(.bottom, 50)
        }
        .onAppear {
            show_button_1 = true
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))
    }
}




struct AnimatedTapIndicator: View {
    @State private var isAnimating = false // Controls the animation state

    var w: CGFloat
    
    var body: some View {
        ZStack {
            // Pulsating background circle
            Circle()
                .stroke(Color.blue, lineWidth: 10)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                //.opacity(isAnimating ? 0 : 1)
                .animation(
                    Animation.easeOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Icon inside the circle
            Circle()
                .foregroundColor(Color.blue.opacity(0.2))
        }
        .frame(width: w, height: w) // Circle size
        .onAppear {
            isAnimating = true
        }
    }
}
