//
//  FRE7.swift
//  SwearBy
//
//  Created by Colin Power on 1/18/25.
//

import Foundation
import SwiftUI


struct FRE7: View {
    
    @Binding var showFRE: Bool
    @Binding var page: Int
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("text.black"))
                        .frame(width: 68, height: 68)
                    Image(systemName: "gear")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.trailing)
                Text("Add SwearBy\nto the Share Sheet")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .padding(.top, 90)
            
            Text("STEP 2 OF 3")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.vertical, 20)
            
                
            Group {
                Text("Tap ")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                +
                Text("Edit")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            LottieView(url: Bundle.main.url(forResource: "Flow6", withExtension: "lottie")!)
                .padding(.vertical, 40)
            
            Spacer()
            
            Button {
                page = 8
            } label: {
                FRE_Button()
            }
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
    }
}
