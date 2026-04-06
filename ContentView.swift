//
//  ContentView.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    // Observe
    //@EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var session: SessionManager
    @StateObject var users_vm = UsersVM()
    @StateObject var new_posts_vm = NewPostsVM()
    
    // Variables
    @State var email: String = ""
    @State var isInDemoMode:Bool = false
    @State var shouldUpdateUserProfilePic = false
    
    // App Storage
    @AppStorage("shouldShowEULA") var shouldShowEULA: Bool = true
    @AppStorage("showFRE") var showFRE: Bool = true
    @AppStorage("logout_and_force_phone_auth") var logout_and_force_phone_auth: Bool = true
    
    
    var body: some View {
        
        let currentSessionUID = session.currentUser?.uid ?? ""
        let currentSessionEmail = session.currentUser?.email ?? ""
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        switch session.appFlowState {
        case .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
        
        case .onboarding:
            //FRE(showFRE: $showFRE)
            FirstRunExperienceView()
        
        case .main:
            Explore(users_vm: users_vm, new_posts_vm: new_posts_vm)
        }
    }
}
