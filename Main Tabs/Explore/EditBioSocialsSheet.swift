//
//  EditBioSocialsSheet.swift
//  SwearBy
//
//  Created by Colin Power on 1/23/25.
//

import Foundation
import SwiftUI

struct EditBioSocialsSheet: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var isPresented: Bool
    
    @FocusState private var txtFocused: Bool
    @State private var txt: String = ""
    
    @Binding var sheet_type: String          // instagram, tiktok, ltk, bio
    
    var sheet_strings: [String] {
        switch sheet_type {
        case "instagram":
            return ["Edit Instagram", "Enter your handle", "kathleen.post"]
        case "tiktok":
            return ["Edit TikTok", "Enter your handle", "kathleen.post"]
        case "ltk":
            return ["Edit LikeToKnowIt", "Enter your handle", "kathleen.post"]
        case "bio":
            return ["Edit your bio", "Tell your followers about yourself", "I post daily style, home decor & fitness. I'm 5'5\" and a size 26 in jeans, typically wear size small in dresses!"]
        default:
            return ["Edit", "Enter", ""]
        }
    }
    
    var body: some View {
        
            
        ZStack(alignment: .top) {
        
            Color("Background").ignoresSafeArea()
        
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text(sheet_strings[0])
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top)
                
                //Subtitle
                Text(sheet_strings[1])
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.vertical)
                    .padding(.bottom)
                
                //First Name textfield
                if sheet_type == "bio" {
                    TextField(sheet_strings[2], text: $txt, axis: .vertical)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("text.black"))
                        .lineLimit(5...10)
                        .padding(.all)
                        .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                        .focused($txtFocused)
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.sentences)
                        .disableAutocorrection(true)
                        .padding(.vertical)
                } else {
                    TextField(sheet_strings[2], text: $txt)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color("text.black"))
                        .frame(height: 48)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                        .onSubmit {
                            sendUpdates()
                            
                            isPresented = false
                        }
                        .focused($txtFocused)
                        .submitLabel(.done)
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.bottom)
                }
                
 
                Spacer()
                
                //Continue button
                Button {
                    
                    sendUpdates()
                    
                    isPresented = false
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Save")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(Color("SwearByGold")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }
                    
                
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            
            setupTxt()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                txtFocused = true
            }
        }
    }
    
    func setupTxt() {
        if sheet_type == "instagram" {
            self.txt = users_vm.one_user.socials.instagram
        } else if sheet_type == "tiktok" {
            self.txt = users_vm.one_user.socials.tiktok
        } else if sheet_type == "ltk" {
            self.txt = users_vm.one_user.socials.ltk
        } else if sheet_type == "bio" {
            self.txt = users_vm.one_user.info.bio
        }
    }
    
    func sendUpdates() {
        if sheet_type == "instagram" {
            users_vm.updateUserAccount(user_id: users_vm.one_user.user_id,
                                       name: users_vm.one_user.info.name,
                                       ltk: users_vm.one_user.socials.ltk,
                                       instagram: txt,
                                       tiktok: users_vm.one_user.socials.tiktok,
                                       bio: users_vm.one_user.info.bio)
                                       
        } else if sheet_type == "tiktok" {
            users_vm.updateUserAccount(user_id: users_vm.one_user.user_id,
                                       name: users_vm.one_user.info.name,
                                       ltk: users_vm.one_user.socials.ltk,
                                       instagram: users_vm.one_user.socials.instagram,
                                       tiktok: txt,
                                       bio: users_vm.one_user.info.bio)
            
        } else if sheet_type == "ltk" {
            users_vm.updateUserAccount(user_id: users_vm.one_user.user_id,
                                       name: users_vm.one_user.info.name,
                                       ltk: txt,
                                       instagram: users_vm.one_user.socials.instagram,
                                       tiktok: users_vm.one_user.socials.tiktok,
                                       bio: users_vm.one_user.info.bio)
            
        } else if sheet_type == "bio" {
            users_vm.updateUserAccount(user_id: users_vm.one_user.user_id,
                                       name: users_vm.one_user.info.name,
                                       ltk: users_vm.one_user.socials.ltk,
                                       instagram: users_vm.one_user.socials.instagram,
                                       tiktok: users_vm.one_user.socials.tiktok,
                                       bio: txt)
            
        }
    }
    
}
