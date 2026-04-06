////
////  MyNewView.swift
////  SwearBy
////
////  Created by Colin Power on 10/10/24.
////
//
//import SwiftUI
//
//struct MyNewView: View {
//    
//    var post: NewPosts
//    
//    @State private var showProfile = false
//    @State private var didTapCopy = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            
//            Spacer()
//            
//            // Profile pic, name, follow button
//            HStack(alignment: .center, spacing: 0) {
//                
//                pic
//                    .padding(.trailing, 8)
//                
//                name_and_following
//                
//            }
//            .padding(.bottom, 8)
//            .background(.red.opacity(0.1))
//            
////            post_photos
////                .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: UIScreen.main.bounds.width - 32)
////                .padding(.bottom, 8)
//            
//            post_text
//                .padding(.bottom, 8)
//            
////            pictures
////                .padding(.bottom, 8)
//            
//            post_referral
//                 
//            
//            Spacer()
//        }
//        .padding(.horizontal, 16)
//        .sheet(isPresented: $showProfile, content: {
//            //ProfileSheet(users_vm: users_vm, selected_profile_id: post.user._ID)
//            EmptyView()
//                .presentationDetents([.fraction(CGFloat(0.25))])
//                .presentationDragIndicator(.visible)
//                .presentationBackgroundInteraction(.disabled)
//                .presentationCornerRadius(20)
//        })
//    }
//    
//    var pic: some View {
//        
//        Circle()
//            .foregroundColor(.gray)
//            .frame(width: 25, height: 25)
//            .onTapGesture {
//                showProfile = true
//            }
//        
//    }
//    
//    var name_and_following: some View {
//        
//        HStack(alignment: .center, spacing: 0) {
//            
//            Group {
//                Text("Colin Power")
//                    .font(.system(size: 15, weight: .medium, design: .rounded))
//                    .foregroundColor(.black)
//                
//                Text("@" + "colinjpower1")
//                    .font(.system(size: 15, weight: .regular, design: .rounded))
//                    .foregroundColor(.gray)
//                    .padding(.leading, 3)
//                
//            }
//            .onTapGesture {
//                showProfile = true
//            }
//            
//            Spacer()
//            
//            Text("Following")
//                .font(.system(size: 15, weight: .regular, design: .rounded))
//                .foregroundColor(.gray)
//                .padding(.trailing)
//            
//            Menu {
//                
//                Button {
//                    haptics(.heavy)
//
//                } label: {
//
//                    Label("Delete", systemImage: "trash")
//                }
//
//            } label: {
//                
//                Image(systemName: "ellipsis")
//                    .font(.system(size: 17, weight: .regular, design: .rounded))
//                    .foregroundColor(.gray)
//                    .padding(.leading, 12)
//            }
//            
//        }
//        
//    }
//    
//    var post_photos: some View {
//
//        GeometryReader { geometry in
//            Image("swearby_icon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: geometry.size.width, height: geometry.size.width)
//                        .clipped()
//                        .cornerRadius(30)
////                        .overlay(
////                            HStack {
////                                Rectangle()
////                                    .fill(Color.black.opacity(0.5))
////                                    .frame(width: 20)
////                                Spacer()
////                                Rectangle()
////                                    .fill(Color.black.opacity(0.5))
////                                    .frame(width: 20)
////                            }
////                        )
//        }
//            
//    }
//    
//    var post_text: some View {
//        
//        Text("Testing the text here Testing the text here Testing the text here Testing the text here")
//            .font(.system(size: 14, weight: .regular, design: .rounded))
//            .foregroundColor(.black)
//            .opacity(0.8)
//            .multilineTextAlignment(.leading)
//            .lineLimit(5)
//    }
//    
//    var pictures: some View {
//        
//        ScrollView(.horizontal) {
//            HStack(alignment: .center, spacing: 0) {
//                
//                Rectangle()
//                    .frame(width: 72, height: 72)
//                    .cornerRadius(12)
//                    .foregroundColor(.gray)
//                    .padding(.trailing, 20)
//                
//                Rectangle()
//                    .frame(width: 72, height: 72)
//                    .cornerRadius(12)
//                    .foregroundColor(.gray)
//                    .padding(.trailing, 20)
//                
//                Rectangle()
//                    .frame(width: 72, height: 72)
//                    .cornerRadius(12)
//                    .foregroundColor(.gray)
//                    .padding(.trailing, 20)
//            }
//        }
//    }
//    
//    var post_referral: some View {
//        
//        
//        HStack(alignment: .center, spacing: 0) {
//            
//            var t1: String {
//                switch post.referral.offer_type {
//                case "$":
//                    return "$" + post.referral.offer_value + " off"
//                case "%":
//                    return post.referral.offer_value + "% off"
//                case "":
//                    return "Error"
//                default:
//                    return "None"
//                }
//            }
//            
//            var t2: String {
//                switch post.referral.code {
//                case "":
//                    return "Use this link"
//                default:
//                    return "Use code " + post.referral.code
//                }
//            }
//            
//            Image(systemName: "giftcard.fill")
//                .font(.system(size: 17, weight: .regular, design: .rounded))
//                .foregroundColor(Color("text.green"))
//                .padding(.trailing, 12)
//            
//            
//            VStack(alignment: .leading, spacing: 0) {
//                Group {
//                    Text("Get ")
//                        .font(.system(size: 16, weight: .medium, design: .rounded))
//                        .foregroundColor(Color("text.green"))
//                    +
//                    
//                    Text(t1)
//                        .font(.system(size: 16, weight: .semibold, design: .rounded))
//                        .foregroundColor(Color("text.green.highlight.text"))
//                }
//                .padding(.bottom, 1)
//                
//                Text(t2)
//                    .font(.system(size: 13, weight: .regular, design: .rounded))
//                    .foregroundColor(Color("text.green"))
//                
//            }
//            
//            Spacer(minLength: 20)
//            
//            if post.referral.code.isEmpty {
//                
//                let has_https = post.referral.link.lowercased().contains("https://") || post.referral.link.lowercased().contains("http://")
//                
//                Link(destination: URL(string: has_https ? post.referral.link : "https://" + post.referral.link)!) {
//                    Text("Open Link")
//                        .font(.system(size: 14, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 14)
//                        .background(Capsule().foregroundColor(Color("text.green.highlight")))
//                }
//                
//            } else {
//                Button {
//                    didTapCopy = true
//                    haptics(.medium)
//                    UIPasteboard.general.string = post.referral.code
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        didTapCopy = false
//                    }
//                } label: {
//                    Text(didTapCopy ? "Copied" : "Copy Code")
//                        .font(.system(size: 14, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 14)
//                        .background(Capsule().foregroundColor(Color("text.green.highlight")))
//                }
//            }
//        }
//        .padding(.vertical, 5)
//        .padding(.horizontal, 8)
//        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color("text.green.highlight").opacity(0.05)))
//    }
//    
//    
//    
//}
//
//struct MyNewView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyNewView(post: NewPosts(_ID: "abc", _STATUS: "ABC", access: Access(group: "group", list: ["abc"], is_private_account: false), image_url: "", isSwornBy: false, likes: [], override_url: "", photos: [], poll: Poll_Struct(prompt: "", text1: "", text2: "", text3: "", text4: "", votes1: [], votes2: [], votes3: [], votes4: [], expiration: 0), referral: Referral_Struct(code: "COLIN", link: "", commission_value: "10", commission_type: "DOLLARS", offer_value: "10", offer_type: "%", for_new_customers_only: false, minimum_spend: "0", expiration: 0), replies: [], title: "ABC123", text: "testing text", timestamp: NewTimestamps(archived: 0, created: 0, deleted: 0, expired: 0, updated: 0), url: Url_Struct(host: "", path: "", prefix: "", full: "", original: "", type: "", page_title: "", site_title: "", site_favicon: "", site_id: ""), user: User_Snippet(_ID: "123", name: Struct_Profile_Name(first: "", last: "", first_last: ""), email: "", phone: "")))
//    }
//}
