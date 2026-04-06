//
//  EULA.swift
//  SwearBy
//
//  Created by Colin Power on 7/6/23.
//

import Foundation
import SwiftUI


struct EULA: View {
    
    @Binding var shouldShowEULA: Bool
    
    var body: some View {
            
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    title_and_subtitle
                        .padding(.top, 80)
                    
                    Spacer()
                    
                    confirm_delete_button
                        .padding(.bottom, 60)
                    
                }
            }
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
    }
    
    
    var title_and_subtitle: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.blue)
                    Image(systemName: "star.fill")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
            }
            .padding(.bottom)
            .padding(.vertical)
                
            Text("User Agreement")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.bottom, 10)
                .padding(.bottom)
                
            Text("Your email and phone number are never shared outside of SwearBy. Your contacts are never stored.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            
            Text("You can report any objectionable content (posts, messages, comments) in the app.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            
            Text("You can unfriend other users or leave shared groups at any time.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            
            Text("You can delete your account and all of your data at any time.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            
            Text("Accounts generating objectionable content will be suspended.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
            
            Spacer()
            Text("I will respond to reports about objectionable content within 24 hours. You can also email me at colin@swearby.app!")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
            Spacer()
               
        }.padding(.horizontal).padding(.horizontal)
    }
    
    var confirm_delete_button: some View {
        
        VStack (alignment: .center, spacing: 0) {
            
            // CONFIRM DELETE BUTTON
            
            Button {
                //@AppStorage("shouldShowEULA") var shouldShowEULA:Bool = false
                self.shouldShowEULA = false
                
            } label: {
                
                HStack {
                    Spacer()
                    
                    Text("Agree to Terms")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(height: 50)
                .background(Capsule().foregroundColor(.blue))
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.horizontal, 8)
                
            }
        }
    }
    
    private func getHeaderText(content_type: String) -> [String] {
        
        if content_type == "COMMENT" {
            return ["Delete Comment?", "Your comment will be permanently deleted. Replies to your comment will still appear.", "bubble.left.circle", "text.black"]
        } else if content_type == "REQUEST" {
            return ["Delete Request?", "Your request and any comments will be permanently deleted.", "questionmark.diamond.fill", "sbBlue"]
        } else if content_type == "POST" {
            return ["Delete Post?", "The item you swore by and any comments will be permanently deleted.", "checkmark.seal.fill", "sbPurple"]
        } else if content_type == "MESSAGE" {
            return ["Delete Message?", "Your message will be permanently deleted.", "bubble.left.fill", "text.black"]
        } else if content_type == "CODE" {
            return ["Delete Code?", "Your referral code will be permanently deleted.", "qrcode", "sbGreen"]
        } else {
            return ["Delete?", "This item will be permanently deleted", "circle.fill", "text.gray"]
        }
    }
}
