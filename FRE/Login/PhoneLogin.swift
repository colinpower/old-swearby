//
//  PhoneLogin.swift
//  SwearBy
//
//  Created by Colin Power on 2/5/25.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct PhoneLogin: View {
    
    // Inherited
    @Environment(\.dismiss) var dismiss
    
    // For TextField
    @State private var textFieldPreview: String = "(201) 555-0123"
    @State private var numbers: String = ""
    @State private var phone: String = ""
    @State private var code: String = ""
    
    @FocusState private var isFocused: Bool
    @FocusState private var isPhoneFocused: Bool
    @FocusState private var isCodeFocused: Bool
    
    // For holding the values
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    
    // For Auth
    @State private var verificationID: String?
    
    @State private var isVerificationSent: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var errorMessage: String?
    
    // For pausing while checking code
    @State private var isShowingProgressView: Bool = false
    
    
    var body: some View {
            
        VStack(alignment: .leading, spacing: 0) {
            
            Text(!isVerificationSent ? "Sign Up" : "Verify")
                .padding(.top, 80)
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(Color.black)
                .padding(.bottom, 80)
            
            if isVerificationSent {
                HStack {
                    TextField("CODE", text: $code)
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                        .foregroundColor(Color.black)
                        .frame(height: 60)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .focused($isCodeFocused)
                }
                .padding(.bottom)
            } else {
                HStack {
                    TextField("(201) 555-0123", text: $phone)
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                        .foregroundColor(Color.black)
                        .frame(height: 60)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                        .focused($isPhoneFocused)
//                        .onChange(of: phone) {
//                                        print($0) // You can do anything due to the change here.
//                                        // self.autocomplete($0) // like this
//                                    }
                }
                .padding(.bottom)
            }
             
            if !isVerificationSent {
                Text("Enter Phone Number")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
                    .padding(.bottom)
            } else {
                // Calculate the indices for splitting the string.
                let firstIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
                let secondIndex = phoneNumber.index(firstIndex, offsetBy: 3)

                // Create substrings and convert them to Strings.
                let str1 = String(phoneNumber[..<firstIndex])         // "123"
                let str2 = String(phoneNumber[firstIndex..<secondIndex]) // "123"
                let str3 = String(phoneNumber[secondIndex...])           // "1234"
                let str4 = "Enter code sent to (" + str1 + ") " + str2 + "-" + str3
                
                Text(str4)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            
                
            Spacer()
                    
                
            Group {
                
                if !isVerificationSent {
                    
                    let policyText = "By signing up, you agree to the SwearBy [Terms of Service](https://www.uncommon.app/terms-of-service) and [Privacy Policy](https://www.uncommon.app/privacy-policy)."
                    Text(.init(policyText))
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 4)
                    
                    Button {
                        self.phoneNumber = phone
                        
                        sendVerificationCode()
                        
                    } label: {
                            
                        Text("Send Verification Code")
                            .font(.system(size: 19, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 44, alignment: .center)
                            .background(Capsule().foregroundStyle(phone.count < 10 ? .gray.opacity(0.5) : .blue))
                    }
                    .disabled(phone.count < 10)
                } else {
                    if isShowingProgressView {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 44, alignment: .center)
                    } else {
                        Button {
                            self.verificationCode = code
                            
                            verifyCode()
                            
                        } label: {
                            
                            Text("Verify Code")
                                .font(.system(size: 19, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: 44, alignment: .center)
                                .background(Capsule().foregroundStyle(code.count < 10 ? .gray.opacity(0.5) : .blue))
                             
                        }
                        .disabled(code.count < 6)
                    }
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .KeyboardAwarePadding(offset: 12)
        .padding(.horizontal)
        .padding(.horizontal)
        .onChange(of: phone) { newValue in
            if newValue.count == 10 {
                self.phoneNumber = newValue
                sendVerificationCode()
            }
        }
        .onChange(of: code) { newValue in
            if newValue.count == 6 {
                self.verificationCode = newValue
                self.isShowingProgressView = true
                
                verifyCode()
            }
        }
        .onAppear {
            self.isPhoneFocused = true
            self.isCodeFocused = false
        }
    }
    
    private func sendVerificationCode() {
        let phoneNumber = self.phoneNumber
        let phoneNumberWithCountryCode = "+1\(phoneNumber)" // Replace "+1" with the country code if needed
        
       //let phoneNumberWithCountryCode = "+919719325299"
        
        // Apple sign in: 222-222-2222 pw 222222
        // My email     : 777-888-9999 pw 555555 (NEED TO FIX.. NOT WORKING CURRENTLY)
        // Otehr test   : 617-244-9360 pw 555555
        // Otehr test   : 123-123-1234 pw 555555
            
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumberWithCountryCode, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        self.errorMessage = "Error: \(error.localizedDescription)"
                        self.phone = ""
                        return
                    }
                    self.verificationID = verificationID
                    
                    self.phone = ""
                    self.textFieldPreview = "CODE"
                    
                    self.isPhoneFocused = false
                    
                    self.isVerificationSent = true
                    
                    
                    self.isCodeFocused = true
                    
                    self.errorMessage = nil
                }
    }
    
    private func verifyCode() {
        guard let verificationID = self.verificationID else {
            self.errorMessage = "Verification ID is missing."
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.isShowingProgressView = false
                self.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            self.isAuthenticated = true
            self.errorMessage = nil
            self.isShowingProgressView = false
            
            dismiss()
        }
    }
}


extension View {
    func formatPhoneNumber(value: Binding<String>) -> some View {
        self.modifier(TextFieldPhoneNumberModifer(value: value))
    }
}

struct TextFieldPhoneNumberModifer: ViewModifier {
    @Binding var value: String

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {

                if value.count == 1 {
                    if String($0) != "(" {
                        value = "(" + String($0)
                    }
                } else if value.count == 5 {
                    if String($0[$0.index($0.startIndex, offsetBy: 4)]) != ")" {
                        value = String($0.prefix(4)) + ")" + String($0[$0.index($0.startIndex, offsetBy: 4)])
                    }
                } else if value.count == 6 {
                    if String($0[$0.index($0.startIndex, offsetBy: 5)]) != " " {
                        value = String($0.prefix(5)) + " " + String($0[$0.index($0.startIndex, offsetBy: 5)])
                    }
                } else if value.count == 10 {
                    if String($0[$0.index($0.startIndex, offsetBy: 9)]) != "-" {
                        value = String($0.prefix(9)) + "-" + String($0[$0.index($0.startIndex, offsetBy: 9)])
                    }
                } else if value.count > 14 {
                    value = String($0.prefix(14))
                }
            }
    }
}
