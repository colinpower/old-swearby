//
//  Settings.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI


struct Settings: View {
    
    // Inherited
    @Environment(\.dismiss) var dismiss
    
    //Inherited from Content View
    @ObservedObject var users_vm: UsersVM
    
    //Used for sign-out
    @EnvironmentObject var viewModel: AppViewModel
    //@Binding var selectedTab: Int
    //@Binding var email: String
    //@Binding var path0: NavigationPath                       // used if the user is signing out.. remove the entire path
    //@Binding var path1: NavigationPath                      // used if the user is signing out.. remove the entire path
    
    @State private var isDeleteMyAccountPresented: Bool = false
    @State private var isEditMyNameSheetPresented: Bool = false
    @State private var isEditBioPresented: Bool = false
    @State private var isAcceptFollowersSheetPresented: Bool = false
    
    @State private var sheet_type: String = ""
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            profile_sheet_header
            
            VStack(alignment: .leading, spacing: 0) {
                
                top_section
                
                Spacer()
                
                sign_out_button
                    .padding(.vertical)
                
                Divider()
                
                tos_view
                    .padding(.vertical)
                
                privacy_policy
                    .padding(.vertical)
                                            
                delete_account_button
                    .padding(.top)
                    .padding(.bottom, 60)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isDeleteMyAccountPresented, content: {
//            DeleteMyAccountSheet(users_vm: users_vm, email: $email, isDeleteMyAccountPresented: $isDeleteMyAccountPresented)
        })
        .sheet(isPresented: $isEditMyNameSheetPresented, content: {
            EditMyNameSheet(users_vm: users_vm, isEditMyNameSheetPresented: $isEditMyNameSheetPresented)
        })
        .sheet(isPresented: $isEditBioPresented, content: {
            EditBioSocialsSheet(users_vm: users_vm, isPresented: $isEditBioPresented, sheet_type: $sheet_type)
        })
    }

    
    var top_section: some View {
        
        VStack(alignment: .leading, spacing: 0){
            change_my_name
                .padding(.vertical)
            
            my_bio
                .padding(.vertical)
            
            accept_followers_manually
                .padding(.vertical)
            
            my_instagram
                .padding(.vertical)
            
            my_tiktok
                .padding(.vertical)
            
            my_ltk
                .padding(.vertical)
            
        }
    }
    
    
    
    var profile_sheet_header: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Text("Settings")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 5)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.all, 11)
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
        .padding(.top, 60)
        .padding(.bottom, 10)
    }
    
    
    var change_my_name: some View {
        
        Button {
           
            isEditMyNameSheetPresented = true
            
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundColor(Color("text.black").opacity(0.7))
                    .padding(.horizontal)
                
                Text("Your name")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                
                Spacer()
                
                Text(users_vm.one_user.info.name)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
    }
    
    var my_bio: some View {
        
        Button {
           
            sheet_type = "bio"
            isEditBioPresented = true
            
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundColor(Color("text.black"))
                    .padding(.horizontal)
                
                Text("Your bio")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                
                Spacer()
                
                Text("Edit")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
    }
    
    var my_instagram: some View {
        
        Button {
            
            sheet_type = "instagram"
            isEditBioPresented = true
            
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image("instagram")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Your Instagram")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                
                Spacer()
                
                Text(users_vm.one_user.socials.instagram)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
    }
    
    var my_tiktok: some View {
        
        Button {
            
            sheet_type = "tiktok"
            isEditBioPresented = true
            
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image("tiktok")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Your TikTok")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                
                Spacer()
                
                Text(users_vm.one_user.socials.tiktok)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
    }
    
    var my_ltk: some View {
        
        Button {
            
            sheet_type = "ltk"
            isEditBioPresented = true
            
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image("ltk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Your LTK")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                
                Spacer()
                
                Text(users_vm.one_user.socials.ltk)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
    }

    var accept_followers_manually: some View {
        
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .leading)
                .foregroundColor(Color("text.black"))
                .padding(.horizontal)
            
            Text("Accept Followers")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            Spacer()
            
            Button {
                let current_state = users_vm.one_user.followers.manually_accept_followers
                UsersVM().updateAcceptFollowersManually(user_id: users_vm.one_user.user_id, new_setting_state: !current_state)
            } label: {
                Text(users_vm.one_user.followers.manually_accept_followers ? "Manually" : "Automatically")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
            }
            
        }
        .padding(.horizontal)
        .padding(.leading, 5)
    }
    
    var tos_view: some View {
        
        Button {
            if let url = URL(string: "https://www.uncommon.app/terms-of-service") {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "doc.text")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundColor(.clear)
                    .padding(.horizontal)
                
                Text("Terms of service")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .underline()
                
                Spacer()
            
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
        
        
    }
    
    
    var privacy_policy: some View {
        
        
        Button {
            if let url = URL(string: "https://www.uncommon.app/privacy-policy") {

                UIApplication.shared.open(url)

            }
        } label: {
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "lock.doc")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundColor(.clear)
                    .padding(.horizontal)
                
                Text("Privacy policy")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .underline()
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
    }
    
    
    var sign_out_button: some View {
        
        Button {
            
//            let signOutResult = SessionManager().signOut(users_vm: users_vm)
//            
//            email = ""                                                  // clear the user's email address
//            path0.removeLast(path0.count)                               // return back to the home page from navigation on page 0
//            path1.removeLast(path1.count)                               // return back to the home page from navigation on page 1
//            dismiss()                                                  // dismiss the sheet
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                selectedTab = 0                                         // switch back to the home page
//            }
//            
//            if !signOutResult {
//                //error signing out here.. handle it somehow?
//            }
            
        } label: {
            
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundColor(.clear)
                    .padding(.horizontal)
                
                Text("Sign out")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.blue)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
        }
        
        
    }
    
    var delete_account_button: some View {
        
        Button {
            
            isDeleteMyAccountPresented = true
            
        } label: {
            
            HStack(alignment: .center, spacing: 0) {
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundColor(.clear)
                    .padding(.horizontal)
                
                Text("Delete my account")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.red)
                
                Spacer()

                
            }
            .padding(.horizontal)
            .padding(.leading, 5)
            
        }
    }
    
    
}
