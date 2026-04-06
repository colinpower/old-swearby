//
//  EnterEmail.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//





import Foundation
import SwiftUI
//import FirebaseFunctions

struct EnterEmail: View {
    
    var checkEmailPages: [CheckEmailPage] = [.init(screen: "CheckEmail", content: ""), .init(screen: "EnterPassword", content: "")]
    
    var demoSignInPage: [CheckEmailPage] = [.init(screen: "DemoPage", content: "")]
    
//    @EnvironmentObject var viewModel: AppViewModel
    
    @Binding var email: String
    @Binding var startpath: NavigationPath
    @Binding var isInDemoMode: Bool
    
    @ObservedObject var users_vm: UsersVM
    
    @FocusState private var keyboardFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    @State var textFromFunction = ""                                                      // NOTE: THE CALLABLE FUNCTION IS SET UP HERE
    
    @State private var isEmailValid: Bool = true
    @State private var didRequestPassword:Bool = false
    @State private var password: String = ""
    @State private var shouldCreateNewAccount: Bool = false
    
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
                Text("Enter your email")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.top)
                
                //Email textfield
                TextField("", text: $email)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                        if self.textFieldValidatorEmail(email) {
                            self.isEmailValid = true
                            
                            if email.lowercased() == "demo@swearby.app" {
                                
                                isInDemoMode = true
                                
                            } else {
                                
                                isLoadingUserAccount = true
                                
                                self.users_vm.getUsersByEmail(email: email)
                                
                            }
                        } else {
                            self.isEmailValid = false
                        }
                    }
                    .focused($keyboardFocused)
                    .submitLabel(.continue)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 6)
                
                if !self.isEmailValid {
                    Text("Please enter a valid email")
                        .font(.callout)
                        .foregroundColor(Color.red)
                }
                
                Spacer()
                
                //Continue button
                Button {
                    
                    //Auth_EmailVM().requestEmailLink(email: email)
                    
                    if email.lowercased() == "demo@swearby.app" {
                        
                        isInDemoMode = true
                        
                    } else {
                        
                        isLoadingUserAccount = true
                        
                        self.users_vm.getUsersByEmail(email: email)
                        
                    }
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Continue")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(email.isEmpty ? Color("WebViewGray") : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(email.isEmpty ? Color("TextFieldGray") : Color("SwearByGold")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled(email.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationDestination(for: CheckEmailPage.self) { page in
            if page.screen == "DemoPage" {
                DemoPage(users_vm: users_vm, startpath: $startpath)
            } else if page.screen == "CheckEmail" {
                CheckEmail(startpath: $startpath, email: $email)
            } else if page.screen == "EnterPassword" {
                EnterPassword(email: $email, startpath: $startpath, users_vm: users_vm, isShowing: $isShowing)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                keyboardFocused = true
            }
        }
        .onChange(of: users_vm.get_users_by_email) { newValue in
            
            if newValue.count > 0 {
                
                let t = newValue[0].settings.timestamp
                
                if t < 1712723550 {
                    
                    RequestEmailLinkVM().requestEmailLink(email: email)
                    
                    startpath.append(checkEmailPages[0])
                    
                } else {
                    
                    startpath.append(checkEmailPages[1])
                    
                }
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





struct CheckEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}
