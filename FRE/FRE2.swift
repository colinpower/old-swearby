//
//  FRE1.swift
//  SwearBy
//
//  Created by Colin Power on 1/18/25.
//

import Foundation
import SwiftUI


struct FRE_PAGES: Hashable {
    let n: Int
}


struct FRE2: View {
    
//    var fre_pages: [FRE_PAGES] = [.init(n: 0), .init(n: 1), .init(n: 2), .init(n: 3), .init(n: 4), .init(n: 5), .init(n: 6), .init(n: 7), .init(n: 8), .init(n: 9), .init(n: 10)]
    
    @Binding var showFRE: Bool
    
    @Binding var page: Int
    
    @State private var never: Bool = false
    @State private var forget: Bool = false
    @State private var an: Bool = false
    @State private var influencers: Bool = false
    @State private var discount: Bool = false
    @State private var code: Bool = false
    @State private var again: Bool = false

    @State private var isVisible: Bool = false
    
    
    var body: some View {
        
        ZStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("FIND").foregroundColor(never ? Color("text.black") : .clear)
                    Text("INFLUENCER").foregroundColor(forget ? Color("text.black") : .clear)
                    Text("DISCOUNTS").foregroundColor(an ? Color("text.black") : .clear)
                    Text("WHILE").foregroundColor(influencers ? Color("text.black") : .clear)
                    Text("YOU'RE").foregroundColor(discount ? Color("text.black") : .clear)
                    Text("LITERALLY").underline().foregroundColor(code ? Color("text.black") : .clear)
                    Text("SHOPPING").underline().foregroundColor(again ? Color("text.black") : .clear)
                }
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .padding(.leading)
                .padding(.leading)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .padding(.bottom, 50)
                
                Spacer()
                
                Button {
                    page = 3
                } label: {
                    FRE_Button2(isVisible: $isVisible)
                }
                .padding(.bottom, 50)
                
            }
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.linear(duration: 0.05)) {
                    never = true
                    haptics(.medium)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.linear(duration: 0.05)) {
                    forget = true
                    haptics(.medium)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.linear(duration: 0.05)) {
                    an = true
                    haptics(.medium)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.linear(duration: 0.05)) {
                    influencers = true
                    haptics(.medium)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                withAnimation(.linear(duration: 0.05)) {
                    discount = true
                    haptics(.medium)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.linear(duration: 0.05)) {
                    code = true
                    haptics(.medium)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.linear(duration: 0.05)) {
                    again = true
                    haptics(.medium)
                }
            }
            
            // Disappear block text
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                isVisible = true
            }
        }
    }
}


struct FRE_Button: View {
    var body: some View {
        
        ZStack(alignment: .center) {
            Capsule()
                .foregroundColor(.blue)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
            Text("Next")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
    }
}

struct FRE_Button2: View {
    
    @Binding var isVisible: Bool
    var body: some View {
        
        ZStack(alignment: .center) {
            Capsule()
                .foregroundColor(isVisible ? .blue : .clear)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
            Text("Next")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(isVisible ? .white : .clear)
        }
        .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
    }
}
struct FRE_Button_Gray: View {
    
    @Binding var isGray: Bool
    var body: some View {
        
        ZStack(alignment: .center) {
            Capsule()
                .foregroundColor(isGray ? .blue : Color("TextFieldGray"))
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
            Text("Next")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(isGray ? .white : Color("text.gray"))
        }
        .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
    }
}


struct FRE_Button8: View {
    @State private var isAnimating = false
    
    var body: some View {
        
        ZStack(alignment: .center) {
            Capsule()
                .foregroundColor(Color("SwearByGold"))
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
            HStack(alignment: .center, spacing: 0){
                Image(systemName: "wand.and.sparkles")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.trailing, 6)
                Text("Add to Share Sheet")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .overlay(
            Capsule()
                .stroke(Color("SwearByGold").opacity(0.5), lineWidth: 10)
                .scaleEffect(isAnimating ? 1.05 : 1)
                .opacity(isAnimating ? 0 : 1)
                .animation(
                    Animation.easeOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        )
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
        .onAppear {
            isAnimating = true // Start animation when the view appears
        }
    }
}
