//
//  DeleteSharedContentHalfSheet.swift
//  SwearBy
//
//  Created by Colin Power on 6/20/23.
//

import Foundation
import SwiftUI


struct DeleteSharedContentHalfSheet: View {
    
    var user_id: String
    
    var content_type: String
    var content_id: String
    
    @Binding var message_or_comment_content_id: String
    
    @Binding var isDeleteHalfSheetPresented:Bool
    
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
                    Image(systemName: getHeaderText(content_type: content_type)[2])
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
            }
            .padding(.bottom)
            .padding(.vertical)
                
            Text(getHeaderText(content_type: content_type)[0])
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.bottom, 10)
                
            
            Text(getHeaderText(content_type: content_type)[1])
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
               
        }.padding(.horizontal).padding(.horizontal)
    }
    
    var confirm_delete_button: some View {
        
        VStack (alignment: .center, spacing: 0) {
            
            // CONFIRM DELETE BUTTON
            Button {
                
                if content_type == "POST" {
                    
                    DeleteSharedContentVM().markDeleted(firebase_collection_name: "posts", firebase_doc_id: content_id)
                    
                } else if content_type == "REQUEST" {
                    
                    DeleteSharedContentVM().markDeleted(firebase_collection_name: "requests", firebase_doc_id: content_id)
                    
                } else if content_type == "CODE" {
                    
                    DeleteSharedContentVM().markDeleted(firebase_collection_name: "referral_codes", firebase_doc_id: content_id)
                    
                } else if content_type == "COMMENT" {
                    
                    DeleteSharedContentVM().markArchived(firebase_collection_name: "comments", firebase_doc_id: message_or_comment_content_id)
                    
                } else if content_type == "MESSAGE" {
                    
                    DeleteSharedContentVM().markArchived(firebase_collection_name: "messages", firebase_doc_id: message_or_comment_content_id)
                    
                }
                
                isDeleteHalfSheetPresented = false
                
            } label: {
                
                HStack {
                    Spacer()
                    
                    Text("Delete")
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
                isDeleteHalfSheetPresented = false
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
            return ["Delete Comment?", "Your comment and any replies will be permanently deleted.", "quote.closing", "sbBlue"]
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
