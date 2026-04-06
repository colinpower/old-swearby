//
//  Explore.swift
//  SwearBy
//
//  Created by Colin Power on 5/29/23.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseStorage
import SDWebImageSwiftUI
import Mixpanel


enum DashboardTab: String, CaseIterable, Identifiable {
    case alerts = "Your Alerts"
    case posts = "Your Posts"
    case requests = "Top Requests"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .alerts:
            return "You will receive a notification when discounts are added for any of the sites in this list."
        case .posts:
            return "View and manage the posts you’ve shared with other shoppers."
        case .requests:
            return "See the most requested sites and discounts from the SwearBy community."
        }
    }
}


struct Explore: View {
    
    @EnvironmentObject var session: SessionManager
    
    // Inherited from prior view
    @ObservedObject var users_vm: UsersVM
    @ObservedObject var new_posts_vm: NewPostsVM
    
    
    @StateObject var user_profile_store = StorageManager()
    
    @State var shouldUpdateUserProfilePic: Bool = false   // Trigger a reload of the profile picture when it's been changed
    
    @State private var selectedTab: DashboardTab = .alerts
    
    @State private var showSettings: Bool = false

    
    
    var body: some View {
            
        VStack(alignment: .leading, spacing: 0) {
            
            home_header
            
            profile_capsule
                .padding(.horizontal)
            
            Divider().foregroundColor(.gray).frame(height: 1)
                .padding(.top, 12)
                .padding(.horizontal)
            
            //Text(session.currentUser?.uid ?? "")
            Text("FAQs")
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray)
                .frame(width: UIScreen.main.bounds.width - 36, height: 80, alignment: .center)
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 12) {
                
                // Top segmented buttons
                HStack(spacing: 8) {
                    ForEach(DashboardTab.allCases) { tab in
                        tabButton(for: tab)
                    }
                }
                
                // Gray description text under buttons
                Text(selectedTab.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                // ScrollView content that changes with selection
                    VStack(alignment: .leading, spacing: 12) {
                        switch selectedTab {
                        case .alerts:
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(0..<10) { index in
                                        row(title: "Alerted Site #\(index + 1)",
                                            subtitle: "You’ll be notified when new discounts are found.")
                                    }
                                }
                            }
                        case .posts:
//                            ForEach(0..<8) { index in
//                                row(title: "Post #\(index + 1)",
//                                    subtitle: "A short summary of your shared post.")
//                            }
                            TabTwoView()
                            
                        case .requests:
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(0..<12) { index in
                                        row(title: "Requested Site #\(index + 1)",
                                            subtitle: "Users want discounts here.")
                                    }
                                }
                            }
                        }
                    
                }.padding(.top, 8)
            }
            .padding()
            
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showSettings, content: {
            Settings(users_vm: users_vm)
        })
        .onAppear {
            if shouldUpdateUserProfilePic {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    
                    self.user_profile_store.getUser(user_id: users_vm.one_user.user_id)
                    
                }
            }
            
            
            
            
//            let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
//            let cameFrom = "APP"
//            sharedDefault.set(cameFrom, forKey: "cameFrom")
            
            
        }
        .onChange(of: users_vm.one_user.user_id) { newValue in
            
            // Setup shared defaults data
            if !newValue.isEmpty {
                let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!
                let shared_user_id = newValue
                let shared_user_name = users_vm.one_user.info.name
                sharedDefault.set(shared_user_id, forKey: "user_id")
                sharedDefault.set(shared_user_name, forKey: "user_first_last")
                
                LoadedAppVM().log(user_id: users_vm.one_user.user_id, type: "loaded-explore-signed-in")
                
                Mixpanel.mainInstance().identify(distinctId: users_vm.one_user.user_id)
                 
                Mixpanel.mainInstance().people.set(properties: [ "$name": users_vm.one_user.info.name,
                                                                 "$instagram": users_vm.one_user.socials.instagram])
                 
                Mixpanel.mainInstance().track(event:"Load Main Page", properties: [
                    "# Notifications Set": 0,
                ])
            }
        }
    }
    
    private func tabButton(for tab: DashboardTab) -> some View {
            let isSelected = (tab == selectedTab)

            return Button {
                selectedTab = tab
            } label: {
                Text(tab.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .frame(minWidth: 0)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(isSelected ? Color.accentColor : Color(.systemGray5))
                    )
                    .foregroundColor(isSelected ? .white : .black)
            }
            .buttonStyle(.plain)
        }

        private func row(title: String, subtitle: String) -> some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Divider()
            }
        }
    
    var home_header: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Text("SwearBy")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 5)
                
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "arrowshape.turn.up.right")
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color.blue)
                Text("Invite friends")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.blue)
            }
             
        }
        .padding(.horizontal)
        .frame(height: 40)
        .padding(.top, 60)
        .padding(.bottom, 10)
        .frame(height: 110)
        .background(Color("Background"))
    }
    
    var latest_feed: some View {
            
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                Rectangle().frame(height: 10).foregroundColor(.clear)
                
                //let feed = new_posts_vm.latest_25_public_posts
                
                let feed = new_posts_vm.latest_posts
                
                ForEach(feed) { p in
                    
                    if p.isPublicPost {
                        
                        //Post(users_vm: users_vm, new_posts_vm: new_posts_vm, user_profile_store: user_profile_store, post: p, path: $path)
                        
                        Divider()
                    }
                    
                }
                Spacer()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var profile_capsule: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(.gray)
            Text("@colinjpower1")
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 3)
            
            Text("15")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.trailing, 3)
        }
        .padding(.all, 1)
        .background(
            Capsule().fill(Color(.systemGray5))
        )
        .onTapGesture {
            showSettings = true
        }
    }
    
    
    
}

struct TabTwoView: View {
    @StateObject private var viewModel = TabTwoViewModel()
    
    var body: some View {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.load()
                        }
                    }
                } else if viewModel.items.isEmpty {
                    Text("No items yet.")
                        .foregroundColor(.secondary)
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Rectangle().frame(height: 10).foregroundColor(.clear)
                            
                            let feed = viewModel.items
                            
                            ForEach(feed) { p in
                                
                                if p.isPublicPost {
                                    
                                    VStack {
                                        Text(p.text)
                                        Text(p.referral.code)
                                        Text(p.user.name)
                                    }
                                    Divider()
                                }
                                
                            }
                            Spacer()
                            
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
    }
}

final class TabTwoViewModel: ObservableObject {
    @Published var items: [NewPosts] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repo: FirestoreRepositoryProtocol
    
    init(repo: FirestoreRepositoryProtocol = FirestoreRepository()) {
        self.repo = repo
        load()
    }
    
    func load() {
        isLoading = true
        errorMessage = nil
        
        repo.fetchTabTwoItems { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let items):
                    self?.items = items
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
