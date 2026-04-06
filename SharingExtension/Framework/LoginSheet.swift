//
//  Login.swift
//  SharingExtension
//
//  Created by Colin Power on 1/19/24.
//

import Foundation
import SwiftUI


struct LoginSheet: View {
    
    var enterEmailPages: [EnterEmailPage] = [.init(screen: "EnterEmail", content: ""),
                                             .init(screen: "EnterEmailAndPassword", content: "")]
    
    @State private var email: String = ""
    @State private var startpath = NavigationPath()
    
    let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .top) {
                    
                    Color(red: 193 / 255, green: 153 / 255, blue: 66 / 255).ignoresSafeArea()
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        Spacer()
                        
                        let w = UIScreen.main.bounds.width / 3 * 2
                        let h = w * 7 / 11
                        
                        // dimensions are 550w x 350h
                        Image("AppIcon_blank")
                            .resizable()
                            .frame(width: w, height: h)
                            .padding(.bottom, 16)
                        
                        Text("SwearBy")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        Text("Find influencers' discounts")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 12)
                        
                        HStack(spacing: 0) {
                            
                            Text("while you're literally shopping")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.white)
                                .underline()
                        }
                        
                        Spacer()
                        
                        Button {
                            //sharedDefault.set("load_sign_in", forKey: "load_sign_in")
                            self.open_app()
                        } label: {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Sign In Through SwearBy")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color.white)
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(Capsule().foregroundColor(Color.white.opacity(0.1)))
                            .padding(.horizontal).padding(.horizontal)
                        }
                        .padding(.bottom, 60)
                        
                    }
                }
        }
    }
    
    
    func open_app() {
        NotificationCenter.default.post(name: NSNotification.Name("open-app"), object: nil)
    }
}



struct EnterEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}

struct CheckEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}




