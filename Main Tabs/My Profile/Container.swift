//
//  Container.swift
//  SwearBy
//
//  Created by Colin Power on 5/29/23.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct Container: View {
    
    // Inherited from prior view
    @ObservedObject var users_vm: UsersVM
    
    @Binding var isInDemoMode: Bool
    
    // Observe for entire app
    @StateObject var new_posts_vm = NewPostsVM()
    @StateObject var user_profile_store = StorageManager()
        
    // To check whether you should prompt the user to sign in
    @State var showSignInPage: Bool = false
    
    // Tab Navigation
    @State var path0 = NavigationPath()
    @State var path1 = NavigationPath()
    
    // Search
    @State var isSearching = false
    @State var query0 = ""
    
    // Settings / Logout
    @State var isSettingsOpen = false
    @Binding var email: String
    
    // Full Screen Modal
    @State var fullScreenPresented: FullScreenPresented? = nil
    
    // Device token
    @State private var device_token = UserDefaults.standard.string(forKey: "device_token")
    @State private var load_sign_in: String = ""
    
    // App Storage
    @Binding var shouldUpdateUserProfilePic: Bool
    @Binding var showFRE: Bool
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
                     
            //MARK: 3 main pages of the app
            
            ZStack(alignment: .top) {
                
//                Explore(users_vm: users_vm, new_posts_vm: new_posts_vm, user_profile_store: user_profile_store, path: $path0, isSearching: $isSearching, shouldUpdateUserProfilePic: $shouldUpdateUserProfilePic)
                
                if showFRE {
                    FRE(showFRE: $showFRE)
                }
                
                
                //need a version of this for the search experience
            }
            .onChange(of: users_vm.one_user.user_id) { newValue in
                
                if !newValue.isEmpty {
                    // MARK: Load all the personalized stuff for a user
                    self.new_posts_vm.getMyPosts(user_id: users_vm.one_user.user_id)    // MY PROFILE
                    self.user_profile_store.getUser(user_id: newValue)                  // MY PROFILE PIC
                    
                    // Dismiss the sign in page
                    //showSignInPage = false
                    
                    // Setup shared defaults data
                    UsersVM().updateDeviceToken(user_id: newValue, token: device_token ?? "NO_DEVICE_TOKEN")
                    let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
                    let shared_user_id = newValue
                    let shared_user_name = users_vm.one_user.info.name
                    sharedDefault.set(shared_user_id, forKey: "user_id")
                    sharedDefault.set(shared_user_name, forKey: "user_first_last")
                } else {
                    
                    let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
                    let shared_user_id = ""
                    let shared_user_name = ""
                    sharedDefault.set(shared_user_id, forKey: "user_id")
                    sharedDefault.set(shared_user_name, forKey: "user_first_last")
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            // MARK: Load all the stuff that a non-signed-in user will get
            
            
            // MARK: Check whether the user is coming from the "SIGN IN THROUGH APP" page of the SHARE SHEET
            let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
            let load_sign_in = sharedDefault.string(forKey: "load_sign_in") ?? ""
            
        }
        .onChange(of: load_sign_in) { newValue in
            
            if !newValue.isEmpty {
                if newValue == "load_sign_in" {
                    showSignInPage = true
                    
                    let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
                    sharedDefault.set("", forKey: "load_sign_in")
                }
            }
        }
        .sheet(isPresented: $showSignInPage, content: {
            PhoneLogin()
        })
    }
}
