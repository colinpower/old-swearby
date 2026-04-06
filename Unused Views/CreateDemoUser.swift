//
//  CreateDemoUser.swift
//  SwearBy
//
//  Created by Colin Power on 8/22/23.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct CreateDemoUser: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @StateObject private var user_profile_store = StorageManager()
    
    @Binding var showCreateDemoUserSheet:Bool
    
    @State var name: String = ""
    @State var bio: String = ""
    @State var ltk: String = ""
    @State var instagram: String = ""
    @State var tiktok: String = ""
    
    @FocusState private var name_focused: Bool
    @FocusState private var bio_focused: Bool
    @FocusState private var ltk_focused: Bool
    @FocusState private var instagram_focused: Bool
    @FocusState private var tiktok_focused: Bool
    
    //Setup image upload
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("CREATE DEMO USER")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .padding(.bottom)
            
            
            Button {
                showPicker.toggle()
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    if let croppedImage {
                        
                        Image(uiImage: croppedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                        
                    } else {
                        
                        if user_profile_store.user_url != "" {
                            WebImage(url: URL(string: user_profile_store.user_url)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                        }
                    }
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: 29, height: 29)
                        
                        Image(systemName: "camera.circle.fill")
                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("WebViewKeyboardGray"))
                    }
                    
                }.frame(height: 100)
                    .padding(.top, 10)
            }
            
            
            TextField("name", text: $name)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.black)
                .keyboardType(.default)
                .autocorrectionDisabled()
                .focused($name_focused)
                .submitLabel(.return)
                .onSubmit {
                    name_focused = false
                    bio_focused = true
                }
                .frame(height: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
            
            TextField("bio", text: $bio)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.black)
                .keyboardType(.default)
                .autocorrectionDisabled()
                .focused($bio_focused)
                .submitLabel(.return)
                .onSubmit {
                    bio_focused = false
                    ltk_focused = true
                }
                .frame(height: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
            
            TextField("ltk", text: $ltk)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.black)
                .keyboardType(.default)
                .autocorrectionDisabled()
                .focused($ltk_focused)
                .submitLabel(.return)
                .onSubmit {
                    ltk_focused = false
                    instagram_focused = true
                }
                .frame(height: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
            
            TextField("instagram", text: $instagram)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.black)
                .keyboardType(.default)
                .autocorrectionDisabled()
                .focused($instagram_focused)
                .submitLabel(.return)
                .onSubmit {
                    instagram_focused = false
                    tiktok_focused = true
                }
                .frame(height: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
            
            TextField("tiktok", text: $tiktok)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.black)
                .keyboardType(.default)
                .autocorrectionDisabled()
                .focused($tiktok_focused)
                .submitLabel(.return)
                .onSubmit {
                    tiktok_focused = false
                }
                .frame(height: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
            
            Spacer ()
            
            Button {
                
                var new_user_object = EmptyVariables().empty_user
                let user_id = UUID().uuidString
                
                new_user_object.user_id = user_id
                new_user_object.info.name = name
                new_user_object.info.bio = bio
                new_user_object.socials.ltk = ltk
                new_user_object.socials.instagram = instagram
                new_user_object.socials.tiktok = tiktok
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    uploadPhoto(user_id: new_user_object.user_id)
                    
                    UsersVM().createDemoUser(new_user_object: new_user_object)
                    
                    showCreateDemoUserSheet = false
                }
                
            } label: {
                Text("Submit")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.vertical)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .background(Capsule().foregroundStyle(.blue))
                    .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
            }
            .padding(.bottom, 60)
            
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.name_focused = true
        }
        .cropImagePicker(
            options: [.circle,.square,.rectangle,.custom(.init(width: 350, height: 450))],
            show: $showPicker,
            croppedImage: $croppedImage
        )
    }
    
    
    
    func uploadPhoto(user_id: String) {
        
        // Make sure that the selected image property isn't nil
        guard croppedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into data
        let imageData = croppedImage!.pngData()
        
        guard imageData != nil else {
            print("returned nil.. trying to do it as a png instead")

            return
        }
        
        //Specify the file path and name
        let fileRef = storageRef.child("user/\(user_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                
                print("successfully uploaded")
                // TODO: Save a reference to the file in Firestore DB
                // make call to Firebase here...
                
                // Update the user_profile_store by calling it again
                self.user_profile_store.getUser(user_id: users_vm.one_user.user_id)
                
            }
        }
    }
    
}
