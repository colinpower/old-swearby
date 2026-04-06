//
//  Untitled.swift
//  SwearBy
//
//  Created by Colin Power on 1/20/25.
//
import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI


struct Post: View {
    
    @ObservedObject var users_vm: UsersVM
    @ObservedObject var new_posts_vm: NewPostsVM
    @ObservedObject var user_profile_store: StorageManager
    
    var post: NewPosts
    
    // To move to the next page
    @Binding var path: NavigationPath
    
    // To open the link in the browser tab
    
    @StateObject private var store = StorageManager()   // to get the user's profile pic
    @StateObject private var friend_user_vm = UsersVM()   // to get the user's profile pic
    
    @State private var isCopied: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                pic
                    .padding(.trailing, 12)
                    .onTapGesture {
                        path.append(friend_user_vm.get_user_by_id)
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(post.user.name)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.vertical, 2)
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        if !friend_user_vm.get_user_by_id.socials.instagram.isEmpty {
                            Image("instagram")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                        }
                        
                        if !friend_user_vm.get_user_by_id.socials.tiktok.isEmpty {
                            Image("tiktok")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                        }
                        
                        if !friend_user_vm.get_user_by_id.socials.ltk.isEmpty {
                            Image("ltk")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                        }
                    }
                }
                .onTapGesture {
                    path.append(friend_user_vm.get_user_by_id)
                }
                
                Spacer()
                
//                if users_vm.one_user.user_id != post.user._ID {
//                    if users_vm.one_user.following.list.contains(post.user._ID) {
//                        Text("Following")
//                            .font(.system(size: 15, weight: .regular, design: .rounded))
//                            .foregroundColor(.gray)
//                    } else if users_vm.one_user.following.you_sent_follow_request.contains(post.user._ID) {
//                        Text("Requested")
//                            .font(.system(size: 15, weight: .regular, design: .rounded))
//                            .foregroundColor(.gray)
//                    } else {
//                        Text("+ Follow")
//                            .font(.system(size: 15, weight: .regular, design: .rounded))
//                            .foregroundColor(.black)
//                    }
//                }
                
                //Special menu button for admin account
                if users_vm.one_user.user_id == "Jb1nOzXJ49hH9Q5TyyTlT79328n1" {
                    Menu {
                        
                        Button {
                            //                    isEditMyNameSheetPresented = true
                        } label: {
                            Label("Report User", systemImage: "exclamationmark.triangle")
                        }
                        
                        Button {
                            NewPostsVM().delete(new_post_id: post._ID)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Text("Post: " + post._ID)
                        Text("User: " + post.user._ID)
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(Color("text.gray"))
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                } else {
                    if users_vm.one_user.user_id != post.user._ID {
                        
                        
                        Menu {
                            
                            Button {
                                //                    isEditMyNameSheetPresented = true
                            } label: {
                                Label("Report User", systemImage: "exclamationmark.triangle")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(Color("text.gray"))
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                    } else {
                        Menu {
                            Button {
                                NewPostsVM().delete(new_post_id: post._ID)
                            } label: {
                                Label("Delete" , systemImage: "trash")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(Color("text.gray"))
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                    }
                }
                
                
                
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                if !post.photo.isEmpty {
                    post_photos
                        .padding(.vertical, 8)
                }
                
                post_text
                    .padding(.vertical)
                 
                url_widget
                
                if !post.referral.code.isEmpty || !post.referral.link.isEmpty {
                    post_referral
                        .padding(.top)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10).padding(.bottom, 6)
        .onAppear {
            
            if !post.photo.isEmpty {
                self.store.getPhoto(post_id: post._ID)
            }
            
            if post.user._ID == post.user.pic {
                self.store.getUser(user_id: post.user._ID)
            }
            
            self.friend_user_vm.getUserByID(user_id: post.user._ID)
            
        }
    }
    
    var pic: some View {
        
        // Scenario 1: user.info.pic is their UUID      ->      retrieve from Store
        // Scenario 2: user.info.pic is a URL           ->      load URL
        // Scenario 3: user.info.pic == "instagram"     ->      load LinkPreview to grab the image
        // Scenario 4: user.info.pic == ""              ->      it's empty, ignore
        
        
        Group {
            if post.user._ID == post.user.pic {                     // Scenario 1: it's their UUID
                if store.user_url != "" {
                    WebImage(url: URL(string: store.user_url)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 36, height: 36)
                }
            } else {
                
                if let imageUrl = URL(string: post.user.pic) {      // Scenario 2: it's a URL
                    WebImage(url: imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                } else {
                    if post.user.pic == "instagram" {               // Scenario 3: it's "instagram" or "tiktok"
                        
                    } else {                                        // Scenario 4: no account
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 36, height: 36)
                    }
                }
            }
        }
    }
    
    var name_and_following: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            let isFollowing = users_vm.one_user.following.list.contains(post.user._ID)
            
            Text(post.user.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
            
            if isFollowing {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 3, height: 3)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 7)
                
                Text("Following")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
    
    var post_text: some View {
        
        Text(post.text)
            .font(.system(size: 15, weight: .regular, design: .rounded))
            .foregroundColor(Color("text.gray"))
            .multilineTextAlignment(.leading)
            .lineLimit(5)
    }
    
    var post_photos: some View {
        
            VStack(alignment: .leading, spacing: 0) {
                
                let w = UIScreen.main.bounds.width - 40
                
                if store.photo_url != "" {
                    WebImage(url: URL(string: store.photo_url)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: w, height: w)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
            }
    }
    
    var post_referral: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            var str1: String {
                switch post.referral.offer_type {
                case "$":
                    return "Get $" + post.referral.offer_value + (post.referral.link.isEmpty ? " with code " : " with my link")
                case "%":
                    return "Get " + post.referral.offer_value + "%" + (post.referral.link.isEmpty ? " with code " : " with my link")
                case "":
                    return post.referral.link.isEmpty ? "Shop with my code " : "Shop with my link"
                default:
                    return "Shop with my link"
                }
            }
            
            Group {
                Text(str1)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.green)
                
                +
                
                Text(post.referral.code.isEmpty ? "" : post.referral.code)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            if post.referral.code.isEmpty {
                
                let has_https = post.referral.link.contains("https://") || post.referral.link.contains("http://")
                
                Link(destination: URL(string: has_https ? post.referral.link : "https://" + post.referral.link)!) {
                    Text("Open link")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .underline()
                }

            } else {
                Button {
                    haptics(.medium)
                    UIPasteboard.general.string = post.referral.code
                    isCopied = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isCopied = false
                    }
                } label: {
                    Text(isCopied ? "Copied" : "Copy code" )
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .underline()
                }
            }
            
            Text("Details")
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .underline()
                .padding(.leading)
        }
    }
    
    var url_widget: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            let link1 = post.url.full.lowercased()
            
            Link(destination: URL(string: link1)!) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                                                
                        if !post.url.image_url.isEmpty {
                            if let imageUrl = URL(string: post.url.image_url) {
                                WebImage(url: imageUrl)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 64, height: 64)
                                .foregroundColor(.gray.opacity(0.2))
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text(post.url.page_title)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("text.black"))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .padding(.bottom, 2)
                            
                            Text(post.url.host)
                                .font(.system(size: 13, weight: .regular, design: .rounded))
                                .foregroundColor(Color("text.gray"))
                                .lineLimit(1)
                            
                        }
                        .padding(.leading)
                    }
                    .padding(.all, 12)
                }
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.gray.opacity(0.08)))
                .padding(.trailing, 60)
            }
            
            Spacer()
        }
    }
    
    var footer: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            let user_object = users_vm.one_user
            
            let hasLiked = post.likes.contains(user_object.user_id)
            let noLikes = post.likes.isEmpty
            
            Button {
                
                if users_vm.one_user.user_id.isEmpty {
                    
                } else {
                    
                    if hasLiked {
                        // Unlike on server
                        //NewPostsVM().unlike(new_post_id: post._ID, user_id: user_object.user_id)
                        
                        // Unlike on server
                        if let index = new_posts_vm.latest_25_public_posts.firstIndex(where: { $0.self._ID == post._ID }) {
                            
                            var temp_post = post
                            if let index2 = temp_post.likes.firstIndex(where: { $0 == user_object.user_id }) {
                                temp_post.likes.remove(at: index2)
                                new_posts_vm.latest_25_public_posts[index] = temp_post
                            }
                        }
                        
                    } else {
                        // Like on server
                        //NewPostsVM().like(new_post_id: post._ID, user_id: user_object.user_id)
                        
                        // Like on client
                        if let index = new_posts_vm.latest_25_public_posts.firstIndex(where: { $0.self._ID == post._ID }) {
                            
                            var temp_post = post
                            temp_post.likes.append(user_object.user_id)
                            
                            new_posts_vm.latest_25_public_posts[index] = temp_post
                        }
                    }
                }
            } label: {
                
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                        .foregroundColor(hasLiked ? .red : .gray)
                        .padding(.trailing, 7)
                    
                    Text(String(post.likes.count))
                        .font(.system(size: 14, weight: hasLiked ? .semibold : .medium, design: .rounded))
                        .foregroundColor(noLikes ? .clear : hasLiked ? .red : .gray)
                        .padding(.trailing)
                }
                .padding(.vertical, 10)
            }
            .padding(.trailing)
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "bubble.left.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
                    .padding(.trailing, 7)
                
//                Text(String(post.replies.count))
//                    .font(.system(size: 14, weight: .medium, design: .rounded))
//                    .foregroundColor(.gray)
//                    .padding(.trailing)
            }
            .padding(.trailing)
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "clock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
                    .padding(.trailing, 3)
                
                let postedToday = checkIfTimestampInLastDay(lastTimestamp: post.timestamp.created)
                let time_as_string = postedToday ? convertTimestampToMinOrHoursAgo(timestamp: post.timestamp.created) : convertTimestampToShortDate(timestamp: post.timestamp.created)
                
                Text(time_as_string)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            .padding(.trailing)
                
            Spacer()
            
        }
        
        
    }
}
