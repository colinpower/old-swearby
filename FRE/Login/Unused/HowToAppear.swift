//
//  HowToAppear.swift
//  SwearBy
//
//  Created by Colin Power on 4/9/24.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct HowToAppear: View {
    
    var howToAppearNavigation: [HowToAppearNavigation] = [.init(page: "AddHandle"), .init(page: "EnterName")]
    
    @StateObject private var link_vm1 = LinkVM()
    @StateObject private var link_vm2 = LinkVM()
    @StateObject private var link_vm3 = LinkVM()
    @ObservedObject var users_vm: UsersVM
    @Binding var shouldUpdateUserProfilePic: Bool
    
    @State var appear_path = NavigationPath()
    
    @State var account_type: String = ""
    
    @State private var handle = ""
    @State private var account_name: String = ""
    
    var body: some View {
        
        NavigationStack(path: $appear_path) {
            ZStack(alignment: .top) {
                
                Color("Background").ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    //Title
                    Text("Choose Profile Appearance")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black)
                        .padding(.top)
                    
                    //Subtitle
                    Text("Keep your username from other apps & let your followers find you. Or create a custom profile.")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.gray)
                        .padding(.vertical)
                        .padding(.bottom)
 
                    Spacer()
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            Button {
                                account_type = "x"
                                appear_path.append(howToAppearNavigation[0])
                            } label: {
                                twitter
                            }
                            
                            Button {
                                account_type = "instagram"
                                appear_path.append(howToAppearNavigation[0])
                            } label: {
                                instagram
                                    .padding(.vertical)
                            }
                            
                            Button {
                                account_type = "tiktok"
                                appear_path.append(howToAppearNavigation[0])
                            } label: {
                                tiktok
                            }
                            
                            Button {
                                account_type = ""
                                appear_path.append(howToAppearNavigation[1])
                            } label: {
                                custom
                                    .padding(.vertical)
                            }
                            
                            
//                            instagram
//                            
//                            tiktok
//                            
//                            custom_acct
                                                        
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("")
            .navigationDestination(for: HowToAppearNavigation.self) { page in
                if page.page == "AddHandle" {
                    AddHandle(link_vm1: link_vm1, link_vm2: link_vm2, link_vm3: link_vm3, users_vm: users_vm, appear_path: $appear_path, account_type: $account_type, account_name: $account_name, handle: $handle)
                } else if page.page == "EnterName" {
                    ConfirmName(users_vm: users_vm)
                } else if page.page == "ConfirmHandle" {
                    ConfirmHandle(link_vm1: link_vm1, link_vm2: link_vm2, link_vm3: link_vm3, users_vm: users_vm, appear_path: $appear_path, account_type: $account_type, account_name: $account_name, handle: $handle, shouldUpdateUserProfilePic: $shouldUpdateUserProfilePic)
                }
            }
        }
    }
    
    var twitter: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                Circle()
                    .foregroundColor(.blue.opacity(0.4))
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 4)
                    .padding(.bottom, 4)
                
                Image("x")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
            .padding(.trailing)
            
            
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                    
                Text("My Name on X")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.vertical, 1)
    
                
                Text("@my_handle_on_x")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
            
            Spacer()
            
            
            
            
//            .onAppear(perform: {
//
//                withAnimation(.linear(duration: 0.5).repeatForever()) {
//                    animateLoadingIcon.toggle()
//                }
//            })
            
        }
        
    }
    
    var instagram: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                Circle()
                    .foregroundColor(.blue.opacity(0.4))
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 4)
                    .padding(.bottom, 4)
                
                Image("instagram")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
            .padding(.trailing)
            
            
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                    
                Text("My Name on Instagram")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.vertical, 1)
    
                
                Text("@my_handle_on_instagram")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
            
            Spacer()
            
            
            
            
//            .onAppear(perform: {
//
//                withAnimation(.linear(duration: 0.5).repeatForever()) {
//                    animateLoadingIcon.toggle()
//                }
//            })
            
        }
        
    }
    
    var tiktok: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                Circle()
                    .foregroundColor(.blue.opacity(0.4))
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 4)
                    .padding(.bottom, 4)
                
                Image("tiktok")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
            .padding(.trailing)
            
            
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                    
                Text("My Name on TikTok")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.vertical, 1)
    
                
                Text("@my_handle_on_tiktok")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
            
            Spacer()
            
            
            
            
//            .onAppear(perform: {
//
//                withAnimation(.linear(duration: 0.5).repeatForever()) {
//                    animateLoadingIcon.toggle()
//                }
//            })
            
        }
        
    }
    
    var custom: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                Circle()
                    .foregroundColor(.blue.opacity(0.4))
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 4)
                    .padding(.bottom, 4)
                
//                Image("TikTok")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 18, height: 18)
//                    .clipShape(Circle())
            }
            .frame(width: 44, height: 44)
            .padding(.trailing)
            
            
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                    
                Text("My Name")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.vertical, 1)
    
                
                Text("")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
            
            Spacer()
            
            
            
            

        }
        
    }
        
    
    
    
    
//    var custom_acct: some View {
//        
//        HStack {
//            
//            if let uiImage = link_vm5.image {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 44, height: 44)
//                    .clipShape(RoundedRectangle(cornerRadius: 6))
//            } else {
//                
//                if let uiIcon = link_vm5.icon {
//                    Image(uiImage: uiIcon)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 44, height: 44)
//                        .clipShape(RoundedRectangle(cornerRadius: 6))
//                } else {
//                    RoundedRectangle(cornerRadius: 6)
//                        .frame(width: 44, height: 44)
//                        .foregroundColor(.clear)
//                }
//            }
//            
//            VStack(alignment: .leading, spacing: 0) {            // height 30
//                
//                if let metadata = link_vm5.metadata {
//                    
//                    Text(metadata.title ?? "")
//                        .font(.system(size: 15, weight: .semibold, design: .rounded))
//                        .foregroundColor(.black)
//                        .lineLimit(1)
//                        .padding(.vertical, 1)
//                } else {
//                    RoundedRectangle(cornerRadius: 6)
//                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 15)
//                        .foregroundColor(.gray.opacity(0.1))
//                        .padding(.vertical, 1)
//                }
//                
//                Text("shopltk.com")
//                    .font(.system(size: 13, weight: .regular, design: .rounded))
//                    .foregroundColor(.gray)
//                    .lineLimit(1)
//            }
//            .frame(height: 30)
////            .onAppear(perform: {
////
////                withAnimation(.linear(duration: 0.5).repeatForever()) {
////                    animateLoadingIcon.toggle()
////                }
////            })
//            
//        }
//        
//    }
//        

}


struct HowToAppearNavigation: Hashable {
    
    let page: String
    
}


