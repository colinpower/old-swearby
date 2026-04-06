//
//  EnterPassword.swift
//  SwearBy
//
//  Created by Colin Power on 4/11/24.
//

import Foundation
import SwiftUI
//import FirebaseFunctions

struct EnterPassword: View {
    
    @Binding var email: String
    @Binding var startpath: NavigationPath
    
    @ObservedObject var users_vm: UsersVM
    
    @FocusState private var passwordFocused: Bool
    
    @State var textFromFunction = ""                                                      // NOTE: THE CALLABLE FUNCTION IS SET UP HER
    
    @State private var password: String = ""
    
    @State private var isLoadingUserAccount: Bool = false
    
    @Binding var isShowing: Bool
    
    // For this page:
        // 1. Ask the user to enter their email
        // 2. Check if the email is validated correctly
        // 3. Check whether this email address has a sign-in method already (withMagicLink or withPassword)
            // 3.1 If so, send the MagicLink or show the password field. Either create an account or login to the account for the password option
        // 4. If not, check whether the email address is @outlook.com, @gmail.com, @hotmail.com or @icloud.com.. if so, send a MagicLink
            // 4.1 If not, request a password from the user
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Enter password")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.top)
                
                //Subtitle
                Text("Enter your password for \(email)")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.gray)
                    .padding(.vertical)
                    .padding(.bottom)
                
                //Email textfield
                TextField("", text: $password)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                        
                        isLoadingUserAccount = true
                        
                        SessionManager().signIn(email: email, password: password) { result in
                            switch result {

                            case let .success(user):
                                isLoadingUserAccount = false
                                
                                isShowing = false
                                //viewModel.listen(users_vm: users_vm)
                                print("SUCCESS CREATING ACCOUNT!")

                            case let .failure(error):
                                print("error with result of signIn function")
                                //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
                                
                                isLoadingUserAccount = false
                            }
                        }
                    }
                    .focused($passwordFocused)
                    .submitLabel(.continue)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 6)
                
                Spacer()
                
                if isLoadingUserAccount {
                    ProgressView()
                } else {
                    //Continue button
                    Button {
                        
                        SessionManager().signIn(email: email, password: password) { result in
                            switch result {
                                
                            case let .success(user):
                                isShowing = false
                                //viewModel.listen(users_vm: users_vm)
                                print("SUCCESS CREATING ACCOUNT!")
                                
                            case let .failure(error):
                                print("error with result of signIn function")
                                //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
                            }
                        }
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Continue")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(password.isEmpty ? Color("WebViewGray") : Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(password.isEmpty ? Color("TextFieldGray") : Color("SwearByGold")))
                        .padding(.horizontal)
                        .padding(.top).padding(.top).padding(.top)
                        
                    }.disabled(password.isEmpty)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                passwordFocused = true
            }
        }
        .onChange(of: users_vm.one_user.user_id) { newValue in
            
            isShowing = false
            
        }
    }

    
}

