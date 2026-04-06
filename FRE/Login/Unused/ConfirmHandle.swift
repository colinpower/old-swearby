//
//  ConfirmHandle.swift
//  SwearBy
//
//  Created by Colin Power on 4/11/24.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct ConfirmHandle: View {
    @Environment(\.openURL) var openURL
    
    // first name = NAME                        account_name
    // last name = BLANK
    // twitter / instagram / tiktok = ??        account_type
    // picture = link_vm.image                  link_vm
    // handle = colinjpower                     handle
    
    
    @State var link_vm = LinkVM()
    
    @ObservedObject var link_vm1: LinkVM
    @ObservedObject var link_vm2: LinkVM
    @ObservedObject var link_vm3: LinkVM
    @ObservedObject var users_vm: UsersVM
    @Binding var appear_path: NavigationPath
    @Binding var account_type: String
    @Binding var account_name: String
    @Binding var handle: String
    
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var preloaded_text: String = ""
    @State private var url: String = ""
    @State private var button_name: String = ""
    
    @State private var isUpdatingNameAndPicture: Bool = false
    
    @Binding var shouldUpdateUserProfilePic: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.top)
                
                //Subtitle
                Text(subtitle)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.gray)
                    .padding(.vertical)
                    .padding(.bottom)
                
                //Email textfield
                
                HStack(spacing: 0) {
                    your_profile
                    
                    ZStack(alignment: .center) {
                        Line_Dotted()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 1)
                        
                        Image(systemName: "paperplane")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 5)
                            .background(Rectangle().foregroundColor(Color("Background")))
                        
                    }
                    .frame(minWidth: 80)
                
                    swearby_profile
                    
                }
                
                Spacer()
                
                if isUpdatingNameAndPicture {
                    
                    ProgressView()
                        .padding(.bottom, 60)
                    
                } else {
                    //Continue button
                    Button {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isUpdatingNameAndPicture = true
                            
                            uploadPhoto(user_id: users_vm.one_user.user_id)
                            
                            updateName()
                            
                            shouldUpdateUserProfilePic = true
                            
                            if let url = URL(string: url) {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text(button_name)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(Color.black))
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                    }
                    
                    //I'll send a DM later button
                    Button {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isUpdatingNameAndPicture = true
                            
                            uploadPhoto(user_id: users_vm.one_user.user_id)
                            
                            updateName()
                            
                            shouldUpdateUserProfilePic = true
                        }
                        
                        
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text("I'll send a DM later")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.black)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(.clear))
                        .padding(.horizontal)
                        
                    }
                    .padding(.bottom, 40)
                }
                
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .onAppear(perform: {
            
            if account_type == "x" {
                title = "Confirm X Account"
                subtitle = "In the next 24 hours, send a DM to @SwearBy_App on X. Say anything you want!"
                url = "https://www.twitter.com/swearby_app"
                button_name = "DM SwearBy on X"
                self.link_vm = link_vm1
            } else if account_type == "instagram" {
                title = "Confirm Instagram Account"
                subtitle = "In the next 24 hours, send a DM to @SwearBy_App on Instagram. Say anything you want!"
                url = "https://www.instagram.com/swearby_app"
                button_name = "DM SwearBy on Instagram"
                link_vm = link_vm2
            } else if account_type == "tiktok" {
                title = "Confirm TikTok Account"
                subtitle = "In the next 24 hours, send a DM to @SwearBy_App on Instagram. Say anything you want!"
                url = "https://www.tiktok.com/@swearby_app"
                button_name = "DM SwearBy on TikTok"
                link_vm = link_vm3
            }
        })
    }
    
    var your_profile: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                if let uiImage = link_vm.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 4)
                        .padding(.bottom, 4)
                        .clipShape(Circle())
                } else {
                    
                    Circle()
                        .foregroundColor(.blue.opacity(0.4))
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 4)
                        .padding(.bottom, 4)
                }
                
                Image(account_type)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                
                Text(account_name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.vertical, 1)
                
                Text("@" + handle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
        }
        .frame(maxWidth: .infinity)
        
    }
    
    
    var swearby_profile: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                Image("swearby_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 4)
                    .padding(.bottom, 4)
                    .clipShape(Circle())
                
                Image(account_type)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                
                Text("SwearBy App")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.vertical, 1)
                
                Text("@swearby_app")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
                     
        }
        .frame(maxWidth: .infinity)
    }
    
    
    var send_dm_button: some View {
        
        Button {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                uploadPhoto(user_id: users_vm.one_user.user_id)
            }
            
            updateName()
            
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
            
        } label: {
            Text(button_name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.white)
                .padding(.horizontal, 16)
                .frame(height: 24)
                .background(Color.blue)
                .clipShape(Capsule())
        }
        
    }
    
    
    func updateName() {
        
//        if account_type == "x" {
//            UsersVM().updateUserAccount(user_id: users_vm.one_user.user_id, first_name: account_name, last_name: "", twitter: handle, instagram: "", tiktok: "")
//        } else if account_type == "instagram" {
//            UsersVM().updateUserAccount(user_id: users_vm.one_user.user_id, first_name: account_name, last_name: "", twitter: "", instagram: handle, tiktok: "")
//        } else if account_type == "tiktok" {
//            UsersVM().updateUserAccount(user_id: users_vm.one_user.user_id, first_name: account_name, last_name: "", twitter: "", instagram: "", tiktok: handle)
//        }
    }
    
    
    func uploadPhoto(user_id: String) {
        
        // Make sure that the selected image property isn't nil
        guard link_vm.image != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into data
        let imageData = link_vm.image!.pngData()
        
        guard imageData != nil else {
            print("returned nil.. trying to do it as a png instead")

            return
        }
        
        //Specify the file path and name
        //let fileRef = storageRef.child("photos/\(new_post._ID).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        let fileRef = storageRef.child("user/\(users_vm.one_user.user_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                
                print("successfully uploaded")
                // TODO: Save a reference to the file in Firestore DB
                // make call to Firebase here...
            }
        }
    }
        
        
    
    
}




struct Line_Dotted: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
