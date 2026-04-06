//
//  CreateAccount.swift
//  SwearBy
//
//  Created by Colin Power on 4/9/24.
//

import Foundation
import SwiftUI

struct CreateAccount: View {
    
    var createAccountNavigation: [CreateAccountNavigation] = [.init(screen: "HowToAppear")]
    var enterEmailPages: [EnterEmailPage] = [.init(screen: "CreateAccount", content: ""),
                                             .init(screen: "SignIn", content: ""),
                                             .init(screen: "EnterName", content: "")]
    
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @Binding var email: String
    @Binding var startpath: NavigationPath
    @Binding var isInDemoMode: Bool
    @Binding var isShowing: Bool
    
    @ObservedObject var users_vm: UsersVM
    
    @FocusState private var keyboardFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    @State var textFromFunction = ""                                                      // NOTE: THE CALLABLE FUNCTION IS SET UP HERE
    
    @State private var isEmailValid: Bool = true
    @State private var didRequestPassword:Bool = false
    @State private var password: String = ""
    @State private var shouldCreateNewAccount: Bool = false
    
    // For this page:
        // 1. Ask the user to enter their email
        // 2. Check if the email is validated correctly
        // 3. Check whether this email address has a sign-in method already (withMagicLink or withPassword)
            // 3.1 If so, send the MagicLink or show the password field. Either create an account or login to the account for the password option
        // 4. If not, check whether the email address is @outlook.com, @gmail.com, @hotmail.com or @icloud.com.. if so, send a MagicLink
            // 4.1 If not, request a password from the user
    
    @State private var didTapCreate: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Create Account")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.top)
                    .padding(.bottom)
                    .padding(.bottom)
                
                
                //Email textfield
                TextField("Email", text: $email)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                        if self.textFieldValidatorEmail(email) {
                            self.isEmailValid = true
                            
                            self.keyboardFocused = false
                            
                            self.passwordFocused = true
                            
                        } else {
                            self.isEmailValid = false
                        }
                    }
                    .focused($keyboardFocused)
                    .submitLabel(.next)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 6)
                
                if !self.isEmailValid {
                    Text("Please enter a valid email")
                        .font(.callout)
                        .foregroundColor(Color.red)
                }
                
                TextField("Password", text: $password)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                         
                        // create the account using Auth.auth()
                        SessionManager().createAccount(email: email, password: password) { result in
                            switch result {

                            case let .success(user):
                                
                                //isShowing = false
                                startpath.append(enterEmailPages[2])
                                //viewModel.listen(users_vm: users_vm)
                                print("SUCCESS CREATING ACCOUNT!")

                            case let .failure(error):
                                print("error with result of createAccount function")
                                //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
                            }
                        }
                        
                        // then, wait for the users_vm.one_user etc to appear (this happens in the onChange event)
                        
                    }
                    .focused($passwordFocused)
                    .submitLabel(.continue)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 6)
                    .padding(.top)
                    .padding(.top, 8)
                
                //Subtitle
                Text("Password must include an uppercase character, a number, and a symbol.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color.gray)
                    .padding(.vertical)
                    .padding(.bottom)
                
                
                Spacer()
                
                if didTapCreate {
                    
                    HStack(spacing: 0) {
                        
                        Spacer()
                        ProgressView()
                            .padding(.trailing, 5)
                        
                        Text("Creating... 1 sec")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                } else {
                    
                    //Continue button
                    Button {
                        
                        didTapCreate = true
                        
                        // create the account using Auth.auth()
                        SessionManager().createAccount(email: email, password: password) { result in
                            switch result {
                                
                            case let .success(user):
                                //isShowing = false
                                startpath.append(enterEmailPages[2])
                                didTapCreate = false
                                //viewModel.listen(users_vm: users_vm)
                                print("SUCCESS CREATING ACCOUNT!")
                                
                            case let .failure(error):
                                didTapCreate = false
                                print("error with result of createAccount function")
                                //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
                            }
                        }
                        
                        // then, wait for the users_vm.one_user etc to appear (this happens in the onChange event)
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Create")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(email.isEmpty ? Color("WebViewGray") : Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(email.isEmpty ? Color("TextFieldGray") : Color("SwearByGold")))
                        .padding(.horizontal)
                        .padding(.top).padding(.top).padding(.top)
                        
                    }.disabled(email.isEmpty || password.isEmpty)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
//        .navigationDestination(for: CheckEmailPage.self) { page in
//            if page.screen == "HowToAppear" {
//                HowToAppear()
//            }
//        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                keyboardFocused = true
            }
        }
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
}





struct CreateAccountNavigation: Hashable {
    
    let screen: String
    
}
