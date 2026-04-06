//
//  MyProfile.swift
//  SwearBy
//
//  Created by Colin Power on 1/6/25.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI


struct MyProfile: View {
    
    // Inherited from prior view
    @ObservedObject var users_vm: UsersVM
    
    // Get Instagram / TikTok / LTK image
    @StateObject private var my_link_vm1 = LinkVM()
    @StateObject private var my_link_vm2 = LinkVM()
    @StateObject private var my_link_vm3 = LinkVM()
    
    @ObservedObject var new_posts_vm: NewPostsVM
    @ObservedObject var user_profile_store: StorageManager
    
    @Binding var path: NavigationPath
    @Binding var fullScreenPresented: FullScreenPresented?
    
    
    //Setup image upload
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    @Binding var showSignInPage: Bool
    @Binding var showFRE: Bool
    
    @State private var showCreateDemoUserSheet: Bool = false
    @State private var showDemoUserList: Bool = false
    
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            NavigationStack(path: $path) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    //StandardHeader(title: "Profile", hasSettingsButton: true, isSearching: Binding.constant(false), fullScreenPresented: $fullScreenPresented)
                    
                    profile_main
                    
                    Text("Latest Posts")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.leading)
                        .padding(.top)
                    
                    if users_vm.one_user.user_id == "Jb1nOzXJ49hH9Q5TyyTlT79328n1" {
                        
                        HStack {
                            Button {
                                showCreateDemoUserSheet = true
                            } label: {
                                Text("Create Demo User")
                                    .foregroundStyle(.purple)
                            }
                            
                            Spacer()
                            
                            
                            Button {
                                showFRE = true
                            } label: {
                                Text("Show FRE")
                                    .foregroundStyle(.green)
                            }
                            Spacer()
                            
                            Button {
                                showDemoUserList = true
                            } label: {
                                Text("Show Demo List")
                                    .foregroundStyle(.red)
                            }
                        }
                        Text("Num posts: \(String(new_posts_vm.public_account_posts.count))")
                    }
                    
                    Divider().foregroundColor(.gray).frame(height: 1)
                        .padding(.top, 12)
                    
                    latest_feed
                    
                }
                .background(Color("Background"))
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden)
                .navigationDestination(for: Users.self) { user in
                    Profile(users_vm: users_vm, new_posts_vm: new_posts_vm, user_profile_store: user_profile_store, path: $path, friend_user: user)
                }
                .onAppear {
                                        
//                    if !users_vm.one_user.instagram.isEmpty {
//                        self.my_link_vm1.getMetadata(link: "https://www.instagram.com/" + users_vm.one_user.instagram)
//                    }
//        
//                    if !users_vm.one_user.tiktok.isEmpty {
//                        self.my_link_vm2.getMetadata(link: "https://www.tiktok.com/@" + users_vm.one_user.tiktok)
//                    }
//        
//                    if !users_vm.one_user.twitter.isEmpty {
//                        self.my_link_vm3.getMetadata(link: "https://www.shopltk.com/explore/" + users_vm.one_user.twitter)
//                    }
                    
                    self.new_posts_vm.trackTotalPublicAccountPosts()
                }
                .sheet(isPresented: $showCreateDemoUserSheet) {
                    CreateDemoUser(users_vm: users_vm, showCreateDemoUserSheet: $showCreateDemoUserSheet)
                }
                .sheet(isPresented: $showDemoUserList) {
                    ChooseDemoUser(users_vm: users_vm, posts_vm: new_posts_vm, demoAccountSelected: .constant(EmptyVariables().empty_user))
                }
                        
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(.white)
        .onChange(of: croppedImage, perform: { newValue in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                uploadPhoto(user_id: users_vm.one_user.user_id)
            }
            
        })
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .cropImagePicker(
            options: [.circle,.square,.rectangle,.custom(.init(width: 350, height: 450))],
            show: $showPicker,
            croppedImage: $croppedImage
        )
    }
    
    var profile_main: some View {
        
        HStack(alignment: .top, spacing: 0) {
            
            profile_pic
                .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .bottom, spacing: 0) {
                    
                    Text(users_vm.one_user.info.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    
                    Spacer()
                    
                    Text("\(String(users_vm.one_user.followers.list.count)) followers")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                    
                }
                
                if users_vm.one_user.info.bio.isEmpty {
                    Button {
                        fullScreenPresented = .settings
                    } label: {
                        Text("Add a bio")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                } else {
                    Text(users_vm.one_user.info.bio)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                        .lineLimit(4)
                        .padding(.top, 4)
                }
                
                
                HStack(alignment: .center, spacing: 0) {
                    
                    if !users_vm.one_user.socials.instagram.isEmpty {
                        ProfileButton(link_vm: my_link_vm1, handle: users_vm.one_user.socials.instagram, img: "instagram", url: "https://www.instagram.com/")
                    } else {
                        Button {
                            fullScreenPresented = .settings
                        } label: {
                            ProfileButton_Empty(img: "instagram")
                        }
                    }
                    
                    if !users_vm.one_user.socials.tiktok.isEmpty {
                        ProfileButton(link_vm: my_link_vm2, handle: users_vm.one_user.socials.tiktok, img: "tiktok", url: "https://www.tiktok.com/@")
                    } else {
                        Button {
                            fullScreenPresented = .settings
                        } label: {
                            ProfileButton_Empty(img: "tiktok")
                        }
                    }
                    
                    if !users_vm.one_user.socials.ltk.isEmpty {
                        ProfileButton(link_vm: my_link_vm3, handle: users_vm.one_user.socials.ltk, img: "ltk", url: "https://www.shopltk.com/explore/")
                    } else {
                        Button {
                            fullScreenPresented = .settings
                        } label: {
                            ProfileButton_Empty(img: "ltk")
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding(.horizontal)
    }
    
    var profile_header: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                
                profile_pic
                    .padding(.trailing)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("User Name")
                    Text("add a bio")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                HStack {
                    VStack {
                        Text("12")
                        Text("Following")
                    }
                    .padding(.trailing, 8)
                    VStack {
                        Text("25")
                        Text("Followers")
                    }
                }
                
            }
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "plus")
                Text("Add your socials")
                    .foregroundColor(.blue)
            }
        }
    }
    
    var profile_pic: some View {
        // Profile Pic
        Button {
            showPicker.toggle()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                if let croppedImage {
                    
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                    
                } else {
                    
                    if user_profile_store.user_url != "" {
                        WebImage(url: URL(string: user_profile_store.user_url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 80, height: 80)
                    }
                }
                ZStack(alignment: .center) {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 29, height: 29)
//                                .background(Circle().strokeBorder(Color.white, lineWidth: 3))
                    Image(systemName: "camera.circle.fill")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray").opacity(0.7))
                }
                
            }.frame(height: 80)
        }
    }
    
    var latest_feed: some View {
            
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                Rectangle().frame(height: 10).foregroundColor(.clear)
                
                let feed = new_posts_vm.all_my_posts
                
                ForEach(feed) { p in
                    
                    Post(users_vm: users_vm, new_posts_vm: new_posts_vm, user_profile_store: user_profile_store, post: p, path: $path)
                    
                    Divider()
                    
                }
                Spacer()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
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
