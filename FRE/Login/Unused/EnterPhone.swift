//
//  EnterPhone.swift
//  UncommonApp
//
//  Created by Colin Power on 12/15/22.
//

import Foundation
import SwiftUI






struct EnterPhone: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var setuppath: NavigationPath
    
    @State var phone:String = ""
    @State var formattedPhoneNumber:String = ""
    @State var auth_phone_uuid: String = ""
    @FocusState private var isFocused: Bool
    
    var checkPhonePages: [CheckPhonePage] = [.init(screen: "CheckPhone", content: "")]
    
    var body: some View {
        ZStack(alignment: .top) {
        
            Color("Background").ignoresSafeArea()
        
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Enter your phone number")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top)
                
                //Subtitle
                Text("We use your phone number to find your friends and eligible referral programs.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.vertical)
                    .padding(.bottom)
                
                //Phone textfield
                TextField("Enter your phone number", text: $formattedPhoneNumber)
                    .formatPhoneNumber(value: $formattedPhoneNumber)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.black"))
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                        //usersViewModel.requestVerificationCode(phone: phoneNumber, codeExpiresInSeconds: 180, userID: userID, verificationID: verificationID)
                        //phoneNumber = "+1" + formattedPhoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
                    }
                    .focused($isFocused)
                    .submitLabel(.send)
                    .keyboardType(.numberPad)
                
             
            
                
                Spacer()
                
                //Continue button
                Button {
                    
                    //send verification code
                    auth_phone_uuid = UUID().uuidString
                    
                    phone = formattedPhoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
                    
//                    Auth_PhoneVM().requestOTP(user: users_vm.one_user, phone: phone, auth_phone_uuid: auth_phone_uuid)
                    
                    setuppath.append(checkPhonePages[0])
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Send Code")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor((formattedPhoneNumber.count != 14) ? Color("text.gray") : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor((formattedPhoneNumber.count != 14) ? Color("TextFieldGray") : Color("UncommonRed")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled(formattedPhoneNumber.count != 14)
                //617-655-7618
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationDestination(for: CheckPhonePage.self) { page in
            CheckPhone(users_vm: users_vm, setuppath: $setuppath, phone: $phone, auth_phone_uuid: $auth_phone_uuid)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}

struct CheckPhonePage: Hashable {
    
    let screen: String
    let content: String
    
}
