//
//  EnterName.swift
//  UncommonApp
//
//  Created by Colin Power on 12/15/22.
//

import Foundation
import SwiftUI

struct EnterName: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var isShowing: Bool
    
    @State private var name: String = ""
    
    //var uid: String
    
    @FocusState private var nameFocused: Bool

    
    var body: some View {
        
        ZStack(alignment: .top) {
        
            Color("Background").ignoresSafeArea()
        
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Setup your account")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top)
                
                //Subtitle
                Text("Enter your name below.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.vertical)
                    .padding(.bottom)
                
                
                TextField("First and last name", text: $name)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.black"))
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                        if !name.isEmpty {
                            self.nameFocused = false
                        }
                    }
                    .focused($nameFocused)
                    .submitLabel(.next)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .padding(.bottom)
                
                Spacer()
                
                //Continue button
                Button {
                    
                    if !users_vm.one_user.user_id.isEmpty {
                        users_vm.updateName(user_id: users_vm.one_user.user_id, name: name)
                    }
                    
                    isShowing = false
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Continue")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor((name.isEmpty) ? Color("text.gray") : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor((name.isEmpty) ? Color("TextFieldGray") : Color("SwearByGold")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled((name.isEmpty))
                    
                
                
                Spacer()
            }
            .padding(.horizontal)
        }
        
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                nameFocused = true
            }
        }
    }
}

struct SetupPage: Hashable {
    
    let screen: String
    let content: String
    
}
