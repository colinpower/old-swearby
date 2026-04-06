//
//  UndoFriendRequest.swift
//  SwearBy
//
//  Created by Colin Power on 6/29/23.
//

import Foundation
import SwiftUI


struct UndoFollowRequest: View {
    
    @ObservedObject var users_vm: UsersVM
    
    //Used for sign-out
    @Binding var isUndoFriendRequestSheetPresented:Bool
    
    var my_friends_user_object: Users
    
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
                    Image(systemName: "person.fill.xmark")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
            }
            .padding(.bottom)
            .padding(.vertical)
                
            Text("Undo Follow Request")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.bottom, 10)
                
            
            Text("Remove your follow request.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 9)
               
        }.padding(.horizontal).padding(.horizontal)
    }
    
    var confirm_delete_button: some View {
        
        VStack (alignment: .center, spacing: 0) {
            
            // CONFIRM DELETE BUTTON
            Button {
                
                // remove the friend request
                UsersVM().undoFollowRequest(my_user_object: users_vm.one_user, my_friends_user_object: my_friends_user_object)
                
                // dismiss the window
                isUndoFriendRequestSheetPresented = false
                
                
            } label: {
                
                HStack {
                    Spacer()
                    
                    Text("Undo")
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
                isUndoFriendRequestSheetPresented = false
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
}
