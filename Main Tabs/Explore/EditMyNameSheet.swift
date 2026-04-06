//
//  EditMyNameSheet.swift
//  SwearBy
//
//  Created by Colin Power on 6/28/23.
//

import Foundation
import SwiftUI

struct EditMyNameSheet: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var isEditMyNameSheetPresented: Bool
    
    @State private var name: String = ""
    
    @FocusState private var firstFocused: Bool
    @FocusState private var lastFocused: Bool
    
    var body: some View {
        
            
            ZStack(alignment: .top) {
            
                Color("Background").ignoresSafeArea()
            
                VStack(alignment: .leading, spacing: 0) {
                    //Title
                    Text("Edit Name")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .padding(.top)
                    
                    //Subtitle
                    Text("Update your name, then tap Save")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color("text.gray"))
                        .padding(.vertical)
                        .padding(.bottom)
                    
                    //First Name textfield
                    TextField("First Name", text: $name)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color("text.black"))
                        .frame(height: 48)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                        .onSubmit {
                        }
                        .focused($firstFocused)
                        .submitLabel(.next)
                        .keyboardType(.alphabet)
                        .disableAutocorrection(true)
                        .padding(.bottom)
 
                    
                    Spacer()
                    
                    //Continue button
                    Button {
                        
                        users_vm.updateName(user_id: users_vm.one_user.user_id, name: name)
                        
                        isEditMyNameSheetPresented = false
                        
                    } label: {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Save")
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
                
                self.name = users_vm.one_user.info.name
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    firstFocused = true
//                    lastFocused = false
//                }
            }
    }
}
