//
//  ChooseDemoUser.swift
//  SwearBy
//
//  Created by Colin Power on 1/23/25.
//

import Foundation
import SwiftUI

struct ChooseDemoUser: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var users_vm: UsersVM
    @ObservedObject var posts_vm: NewPostsVM
    
    @Binding var demoAccountSelected: Users
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    let list = users_vm.get_fan_accounts
                    
                    ForEach(list) { u in
                        
                        Button {
                            demoAccountSelected = u
                            
                            dismiss()
                            
                        } label: {
                            let num = posts_vm.public_account_posts.filter { $0.user._ID == u.user_id }.count
                            Text("\(String(num))")
                            
                            Text(u.info.name)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                            
                        }
                        Divider()
                        
                    }
                }
                .padding(.bottom)
                Text("\(String(posts_vm.public_account_posts.count)) posts")
                Text("\(String(users_vm.get_fan_accounts.count)) public accounts")
            }
        }
        .onAppear {
            self.users_vm.getFanAccounts()
        }
    }
}


//struct DemoUserProfile: View {
//
//}
