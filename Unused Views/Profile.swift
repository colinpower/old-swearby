//
//  Profile.swift
//  SwearBy
//
//  Created by Colin Power on 1/6/25.
//



import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI


enum FollowingState: String, Identifiable {
    case NOT_FOLLOWING, REQUESTED, FOLLOWING, NONE
    var id: String {
        return self.rawValue
    }
}

struct Profile: View {
    
    // Inherited from previous view
    @ObservedObject var users_vm: UsersVM
    @ObservedObject var new_posts_vm: NewPostsVM
    @ObservedObject var user_profile_store: StorageManager
    
    @Binding var path: NavigationPath
    var friend_user: Users
    
    // Get data for this view
    @StateObject private var private_friends_new_posts_vm = NewPostsVM()
    @StateObject private var private_friends_store = StorageManager()
    
    // Get Following / Not Following state
    @State var following_state:FollowingState = .NONE
    
    // Search / Filter
    @State private var query: String = ""
    @FocusState private var isSearchTextFieldFocused:Bool
    @State private var shouldScrollScreen: Bool = false

    // See Followers
    @State private var showFollowingList: Bool = false
    @State private var showFollowersList: Bool = false
    
    // Undo Following / Request / Follower
    @State private var isUndoFollowRequestSheetPresented:Bool = false
    @State private var isUnfollowSheetPresented:Bool = false
    @State private var isRemoveFollowerSheetPresented:Bool = false
    
    // Get Instagram / TikTok / LTK image
    @StateObject private var link_vm1 = LinkVM()
    @StateObject private var link_vm2 = LinkVM()
    @StateObject private var link_vm3 = LinkVM()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            header
            
            if friend_user.settings.isPublicAccount {
                fan_account_disclosure
            }
            
            //requested_to_follow_you
            
            profile_main
                .padding(.bottom)
            
            Text("Latest Posts")
                .foregroundColor(Color("text.black"))
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .padding(.leading)
                .padding(.top)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(private_friends_new_posts_vm.all_friend_posts) { p in
                        
                        Post(users_vm: users_vm, new_posts_vm: new_posts_vm, user_profile_store: user_profile_store, post: p, path: $path)
                        
                    }
                    Spacer()
                }
            }
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden)
        .onAppear {
            
            self.private_friends_new_posts_vm.getFriendPosts(friend_user_id: friend_user.user_id)
            
            self.private_friends_store.getUser(user_id: friend_user.user_id)
            
            if !friend_user.socials.instagram.isEmpty {
                self.link_vm1.getMetadata(link: "https://www.instagram.com/" + friend_user.socials.instagram)
            }
            
            if !friend_user.socials.tiktok.isEmpty {
                self.link_vm2.getMetadata(link: "https://www.tiktok.com/@" + friend_user.socials.tiktok)
            }
            
            if !friend_user.socials.ltk.isEmpty {
                self.link_vm3.getMetadata(link: "https://www.shopltk.com/explore/" + friend_user.socials.ltk)
            }
            
//            if friend_user.user_id == users_vm.one_user.user_id {
//                self.private_friends_new_posts_vm.all_friend_posts = new_posts_vm.all_my_posts
//                self.private_friends_store.user_url = user_profile_store.user_url
//            } else {
//                self.private_friends_new_posts_vm.getFriendPosts(friend_user_id: friend_user.user_id)
//                self.private_friends_store.getUser(user_id: friend_user.user_id)
//            }
            
        }
//            .onChange(of: query, perform: { newValue in
//                filterTheirContent()
//            })
        .sheet(isPresented: $showFollowingList, content: {
//            FollowHalfSheet(users_vm: users_vm, isShowing: $showFollowingList, path: $path, follow_list: friend_user.following.list, title: "Following", subtitle: "\(friend_user.name.first) follows these users")
//                .presentationDetents([.medium, .large])
//                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $showFollowersList, content: {
//            FollowHalfSheet(users_vm: users_vm, isShowing: $showFollowersList, path: $path, follow_list: friend_user.followers.list, title: "Followers", subtitle: "These users follow \(friend_user.name.first)")
//                .presentationDetents([.medium, .large])
//                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $isUndoFollowRequestSheetPresented) {
            UndoFollowRequest(users_vm: users_vm, isUndoFriendRequestSheetPresented: $isUndoFollowRequestSheetPresented, my_friends_user_object: friend_user)
        }
        .sheet(isPresented: $isUnfollowSheetPresented) {
            Unfollow(users_vm: users_vm, isUnfriendSheetPresented: $isUnfollowSheetPresented, my_friends_user_object: friend_user)
        }
        .sheet(isPresented: $isRemoveFollowerSheetPresented) {
            RemoveFollower(users_vm: users_vm, isRemoveFollowerSheetPresented: $isRemoveFollowerSheetPresented, my_friends_user_object: friend_user)
        }
    }
    
    private var header: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 40, height: 40, alignment: .center)
            }
                
            Spacer()
            
            // It's you ->          Your profile
            // You follow ->        Following
            // You don't follow ->  Follow
            // You sent follow ->   Undo
            
//            if friend_user.user_id == users_vm.one_user.user_id {
//                HStack(alignment: .center, spacing: 0) {
//                    
//                    Image(systemName: "info.circle")
//                        .font(.system(size: 14, weight: .medium, design: .rounded))
//                        .foregroundColor(Color("sbPurple"))
//                        .padding(.trailing, 8)
//                    
//                    Text("Your Profile")
//                        .font(.system(size: 14, weight: .medium, design: .rounded))
//                        .foregroundColor(Color("sbPurple"))
//                    
//                }
//                .padding(.vertical, 6).padding(.horizontal, 18)
//                .background(Capsule().foregroundColor(Color("sbPurple").opacity(0.1)))
//                
//            }
            
            Spacer()
            
            if users_vm.one_user.user_id == friend_user.user_id {
                Text("Your Profile")
                    .foregroundStyle(.clear)
            } else if users_vm.one_user.following.you_sent_follow_request.contains(friend_user.user_id) {
                Button {
                    isUndoFollowRequestSheetPresented = true
                } label: {
                    Text("Sent follow request")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)
                }
            } else if !users_vm.one_user.following.list.contains(friend_user.user_id) {
                Button {
                    if friend_user.followers.manually_accept_followers {
                        UsersVM().sendFollowRequest(my_user_object: users_vm.one_user, my_friends_user_object: friend_user)
                    } else {
                        UsersVM().sendFollowRequestAndAutoFollow(my_user_object: users_vm.one_user, my_friends_user_object: friend_user)
                    }
                } label: {
                    Text("Follow")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                }
            } else if users_vm.one_user.following.list.contains(friend_user.user_id) {
                Button {
                    isUnfollowSheetPresented = true
                } label: {
                    Text("Following")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)
                }
            }
            
            
            
            if friend_user.user_id != users_vm.one_user.user_id {
                Menu {
                    
                    Button {
                        
                    } label: {
                        Label("Report User", systemImage: "exclamationmark.triangle")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .frame(width: 40, height: 40)
                }
                .padding(.leading, 12)
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
        .padding(.top, 60)
        .padding(.bottom, 10)
        .frame(height: 110)
        .background(Color("Background"))
        
    }
    
    
    var requested_to_follow_you: some View {
        
        VStack {
            if users_vm.one_user.followers.list.contains(friend_user.user_id) {
                
                Button {
                    isRemoveFollowerSheetPresented = true
                } label: {
                    
                    Text("Follows You")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color("SwearByGold"))
                        .padding(.vertical, 4).padding(.horizontal, 18)
                        .background(Capsule().foregroundColor(Color("SwearByGold").opacity(0.2)))
                }
                
            } else if users_vm.one_user.followers.follow_requests.contains(friend_user.user_id) {
                
                HStack(alignment: .center, spacing: 0) {
                    
                    Text("Sent Follow Request")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                        .padding(.vertical, 6).padding(.horizontal, 11)
                        .background(Capsule().foregroundColor(Color("text.gray").opacity(0.1)))
                        .padding(.trailing, 8)
                    
                    Button {
                        
                        UsersVM().acceptFollowRequest(my_user_object: users_vm.one_user, my_friends_user_object: friend_user)
                        
                    } label: {
                        
                        Text("Accept")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 6).padding(.horizontal, 13)
                            .background(Capsule().foregroundColor(Color("sbGreen")))
                    }
                }
            }
        }
        
        
    }
    
    var fan_account_disclosure: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "info.circle")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color("SwearByGold"))
                .padding(.trailing)
            
            Text("This profile is updated by the SwearBy community to track \(friend_user.info.name)'s discounts. All links and codes are theirs.")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(Color("SwearByGold"))
                .lineLimit(4)
            
        }
        .padding(.vertical, 6).padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("SwearByGold_light")))
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var profile_main: some View {
        
        HStack(alignment: .top, spacing: 0) {
            
            profile_pic
                .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .bottom, spacing: 0) {
                    
                    Text(friend_user.info.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                    
                    Spacer()
                    
                    Text("\(String(friend_user.followers.list.count)) followers")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                    
                }
                
                Text(friend_user.info.bio)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .lineLimit(4)
                    .padding(.top, 4)
                
                HStack(alignment: .center, spacing: 0) {
                    
                    if !friend_user.socials.instagram.isEmpty {
                        ProfileButton(link_vm: link_vm1, handle: friend_user.socials.instagram, img: "instagram", url: "https://www.instagram.com/")
                    }
                    
                    if !friend_user.socials.tiktok.isEmpty {
                        ProfileButton(link_vm: link_vm2, handle: friend_user.socials.tiktok, img: "tiktok", url: "https://www.tiktok.com/@")
                    }
                    
                    if !friend_user.socials.ltk.isEmpty {
                        ProfileButton(link_vm: link_vm3, handle: friend_user.socials.ltk, img: "ltk", url: "https://www.shopltk.com/explore/")
                    }
                }
                .padding(.top)
            }
        }
        .padding(.horizontal)
    }
    
    var profile_pic: some View {
        
        // Scenario 1: user.info.pic is their UUID      ->      retrieve from Store
        // Scenario 2: user.info.pic is a URL           ->      load URL
        // Scenario 3: user.info.pic == "instagram"     ->      load LinkPreview to grab the image
        // Scenario 4: user.info.pic == ""              ->      it's empty, ignore
        
        Group {
            if friend_user.user_id == friend_user.info.pic {                     // Scenario 1: it's their UUID
                if private_friends_store.user_url != "" {
                    WebImage(url: URL(string: private_friends_store.user_url)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)
                }
            } else {
                
                if let imageUrl = URL(string: friend_user.info.pic) {      // Scenario 2: it's a URL
                    WebImage(url: imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    if friend_user.info.pic == "instagram" {               // Scenario 3: it's "instagram" or "tiktok"
                        
                    } else {                                                // Scenario 4: no account
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
    }
        
}






struct ProfileButton: View {
    
    @Environment(\.openURL) var openURL
    @ObservedObject var link_vm: LinkVM
    
    var handle: String
    var img: String
    var url: String
    
    var body: some View {
        
        Button {
            let temp_url = url + handle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                openURL(URL(string: temp_url)!)
            }
        } label: {
            ZStack(alignment: .bottomTrailing) {
                
                if let uiImage = link_vm.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .padding(.trailing, 5)
                        .padding(.bottom, 4)
                } else {
                    
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 36, height: 36)
                        .padding(.trailing, 5)
                        .padding(.bottom, 4)
                }
                
                Image(img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .cornerRadius(6)
                
            }
            .frame(width: 41, height: 40)
            .padding(.trailing)
        }
    }
}

struct ProfileButton_Empty: View {
    
    var img: String
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 36, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.trailing, 5)
                .padding(.bottom, 4)
            
            Image(img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .cornerRadius(6)
            
        }
        .frame(width: 41, height: 40)
        .padding(.trailing)
    }
}
