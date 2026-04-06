//
//  DeleteMyAccountSheet.swift
//  SwearBy
//
//  Created by Colin Power on 6/23/23.
//

import Foundation
import SwiftUI


struct DeleteMyAccountSheet: View {
    
    @ObservedObject var users_vm: UsersVM
    
    //Used for sign-out
    @EnvironmentObject var viewModel: AppViewModel
    @Binding var email: String
    
    @Binding var isDeleteMyAccountPresented:Bool
    
    var body: some View {
                
        VStack(alignment: .leading, spacing: 0) {
            
            title_and_subtitle
                .padding(.top, 80)
            
            Spacer()
            
            confirm_delete_button
                .padding(.bottom, 60)
        
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
                        .foregroundColor(.red)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
            }
            .padding(.bottom)
            .padding(.vertical)
                
            Text("Delete My Account")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.bottom, 10)
                
            
            Text("Permanently erase all of your content (posts, messages, comments...) and your personal information.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 9)
            
            Text("This action cannot be undone.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .multilineTextAlignment(.leading)
               
        }.padding(.horizontal).padding(.horizontal)
    }
    
    var confirm_delete_button: some View {
        
        VStack (alignment: .center, spacing: 0) {
            
            // CONFIRM DELETE BUTTON
            Button {
                
                // send signal to delete account
                BackendTriggerVM().deleteAccount(user1: users_vm.one_user.user_id)
                
                // dismiss the window
                isDeleteMyAccountPresented = false
                
                // sign out user
                let signOutResult = SessionManager().signOut(users_vm: users_vm)

                // remove email
                email = ""
                
                if !signOutResult {
                    //error signing out here.. handle it somehow?
                }
                
                
                
            } label: {
                
                HStack {
                    Spacer()
                    
                    Text("Delete My Account")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(height: 50)
                .background(Capsule().foregroundColor(.red))
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.horizontal, 8)
                
            }
            
            
            // CANCEL BUTTON
            Button {
                isDeleteMyAccountPresented = false
            } label: {
            
                HStack {
                    Spacer()
                    
                    Text("Cancel")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    
                    Spacer()
                }
                .frame(height: 50)
                .background(Capsule().foregroundColor(.clear))
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.horizontal, 8)
            }
            .padding(.top)
            
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
