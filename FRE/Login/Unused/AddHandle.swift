//
//  AddHandle.swift
//  SwearBy
//
//  Created by Colin Power on 4/9/24.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct AddHandle: View {
    
    var howToAppearNavigation1: [HowToAppearNavigation] = [.init(page: "ConfirmHandle")]
    
    @ObservedObject var link_vm1: LinkVM            // twitter.com/HANDLE, instagram.com/HANDLE, tiktok.com/@HANDLE
    @ObservedObject var link_vm2: LinkVM
    @ObservedObject var link_vm3: LinkVM
    
    @ObservedObject var users_vm: UsersVM
    @Binding var appear_path: NavigationPath
    @Binding var account_type: String
    
    @FocusState private var keyboardFocused: Bool
    @Binding var account_name: String
    @Binding var handle: String
    
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var preloaded_text: String = ""
    @State private var url: String = ""
    @State private var paragraph_header: String = ""
    
    
    
    
    
    
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
                    
                    HStack(spacing: 0) {
                        Text("@")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color.black)

                        
                        TextField("swearby_app", text: $handle)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color.black)
                            .frame(height: 48)
                            .padding(.trailing)
                            .onSubmit {
                                if !handle.contains(" ") {
                                    if account_type == "x" {
                                        self.link_vm1.getMetadata(link: url + handle)
                                    } else if account_type == "instagram" {
                                        self.link_vm2.getMetadata(link: url + handle)
                                    } else if account_type == "tiktok" {
                                        self.link_vm3.getMetadata(link: url + handle)
                                    }
                                } else {
                                    handle = "no spaces allowed"
                                }
                            }
                            .focused($keyboardFocused)
                            .submitLabel(.search)
                            .keyboardType(.alphabet)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            
                    }
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .padding(.trailing)
                    
                    Button {
                        if !handle.contains(" ") {
                            
                            if account_type == "x" {
                                self.link_vm1.getMetadata(link: url + handle)
                            } else if account_type == "instagram" {
                                self.link_vm2.getMetadata(link: url + handle)
                            } else if account_type == "tiktok" {
                                self.link_vm3.getMetadata(link: url + handle)
                            }
                        } else {
                            handle = "no spaces allowed"
                        }
                    } label: {
                        Text("Search")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .frame(height: 24)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                    
                }
                .padding(.bottom, 6)
                
                
                Spacer()
                
                Text(paragraph_header)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.gray)
                    .padding(.vertical)
                    .padding(.bottom)
                
                if account_type == "x" {
                    your_profile1
                } else if account_type == "instagram" {
                    your_profile2
                } else if account_type == "tiktok" {
                    your_profile3
                }
                
                    
                Spacer()
                
                //Continue button
                Button {
                    
                    appear_path.append(howToAppearNavigation1[0])
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Next")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(account_name.isEmpty ? Color("WebViewGray") : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(account_name.isEmpty ? Color("TextFieldGray") : Color("SwearByGold")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled(account_name.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .onAppear(perform: {
            
            if account_type == "x" {
                title = "Enter X handle"
                subtitle = "We'll retrieve your profile."
                url = "https://www.twitter.com/"
                paragraph_header = "How you'll appear on SwearBy (Your profile pic will update later.)"
            } else if account_type == "instagram" {
                title = "Enter Instagram handle"
                subtitle = "We'll retrieve your profile."
                url = "https://www.instagram.com/"
                paragraph_header = "How you'll appear on SwearBy"
            } else if account_type == "tiktok" {
                title = "Enter TikTok handle"
                subtitle = "We'll retrieve your profile."
                url = "https://www.tiktok.com/@"
                paragraph_header = "How you'll appear on SwearBy"
            }
        })
    }
    
    var your_profile1: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                if let uiImage = link_vm1.image {
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
            .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                
                if let metadata = link_vm1.metadata {
                    
                    Text(grabName(title: metadata.title ?? ""))
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.vertical, 1)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 15)
                        .foregroundColor(.gray.opacity(0.1))
                        .padding(.vertical, 1)
                }
                
                Text("@" + handle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
                     
            Spacer()
        }
        
    }
    
    var your_profile2: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                if let uiImage = link_vm2.image {
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
            .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                
                if let metadata = link_vm2.metadata {
                    
                    Text(grabName(title: metadata.title ?? ""))
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.vertical, 1)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 15)
                        .foregroundColor(.gray.opacity(0.1))
                        .padding(.vertical, 1)
                }
                
                Text("@" + handle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
                     
            Spacer()
        }   
    }
    
    var your_profile3: some View {
        
        HStack(alignment: .center, spacing: 0) {
                 
            ZStack(alignment: .bottomTrailing) {
                
                if let uiImage = link_vm3.image {
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
            .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                
                if let metadata = link_vm3.metadata {
                    
                    Text(grabName(title: metadata.title ?? ""))
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.vertical, 1)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 15)
                        .foregroundColor(.gray.opacity(0.1))
                        .padding(.vertical, 1)
                }
                
                Text("@" + handle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
                     
            Spacer()
        }
        
    }
    
    func grabName(title: String) -> String {
        // X, Insta -> Colin (@colin)
        // TikTok   -> Colin on TikTok
        
        if title.isEmpty {
            
            account_name = ""
            
            return account_name
        }
        
        if account_type != "tiktok" {
            
            let index = title.range(of: " (@")!.lowerBound
            
            let name = String(title[..<index])
            
            account_name = name
            
            return account_name
            
        } else {
            let index = title.range(of: " on TikTok")!.lowerBound
            
            let name = String(title[..<index])
            
            account_name = name
            
            return account_name
            
        }
    }
    
    
    
    
    
    var twitter: some View {
        
        HStack {
                 
            if let uiImage = link_vm1.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                
                if let uiIcon = link_vm1.icon {
                    Image(uiImage: uiIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.clear)
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {            // height 30
                
                if let metadata = link_vm1.metadata {
                    
                    Text(metadata.title ?? "")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.vertical, 1)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 15)
                        .foregroundColor(.gray.opacity(0.1))
                        .padding(.vertical, 1)
                }
                
                Text("twitter.com")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(height: 30)
        }
        
    }
    
    
}
