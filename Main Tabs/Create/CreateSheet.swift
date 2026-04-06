//
//  AddProduct.swift
//  SwearBy
//
//  Created by Colin Power on 1/6/25.
//


import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct CreateSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var new_post: NewPosts
    
    @State private var editing_new_post_referral: NewPosts = EmptyVariables().empty_new_post
    
    @State private var rlink = ""
    @State private var hasDiscount: Bool = false
    
    @State private var selectedType = "Dollars"
    //let discount_types = [["$"], "%", ""]]
    let discount_types = ["Dollars", "Percent", "Other", "None"]
    @State private var discountAmount: String = ""
    
    @State private var doesExpire: Bool = false
    @State private var date = Date()
    @State private var hasMinimumSpend: Bool = false
    
    @FocusState private var codeOrLinkFocused: Bool
    @FocusState private var valueFocused: Bool

    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Your Code or Link"), footer: (!editing_new_post_referral.referral.code.isEmpty ? Text("Users must enter this code: " + editing_new_post_referral.referral.code) : !editing_new_post_referral.referral.link.isEmpty ? Text("Users must follow this link: " + editing_new_post_referral.referral.link) : Text(""))) {
                    
                    TextField("Enter code or link", text: $editing_new_post_referral.referral.code)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .focused($codeOrLinkFocused)
                        .submitLabel(.return)
                        .onSubmit {
                            codeOrLinkFocused = false
                            detectLink()
                        }
                }
                
                Section(header: Text("Discount Value")) {
                    
                    Picker("Discount", selection: $selectedType) {
                        ForEach(discount_types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedType != "None" {
                        
                        HStack {
                            if selectedType == "Dollars" && !editing_new_post_referral.referral.offer_value.isEmpty {
                                Text("$")
                            }
                            if selectedType == "Dollars" || selectedType == "Percent" {
                                TextField(selectedType == "Dollars" ? "$50" : "25%", text: $editing_new_post_referral.referral.offer_value)
                                    .keyboardType(.numberPad)
                                    .focused($valueFocused)
                            } else {
                                TextField("Describe the offer value", text: $editing_new_post_referral.referral.offer_value)
                                    .keyboardType(.default)
                                    .focused($valueFocused)
                            }
                            if selectedType == "Percent" && !editing_new_post_referral.referral.offer_value.isEmpty {
                                Text("%")
                            }
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Details")) {
                    
                    if selectedType != "None" {
                        Toggle("Minimum Spend Required", isOn: $hasMinimumSpend)
                        
                        if hasMinimumSpend {
                            TextField("$100", text: $editing_new_post_referral.referral.minimum_spend)
                                .keyboardType(.numberPad)
                        }
                    }
                    
                    Toggle("For New Customers Only", isOn: $editing_new_post_referral.referral.for_new_customers_only)
                }
                
                Section {
                    Toggle("Expires", isOn: $doesExpire)
                    
                    if doesExpire {
                        
                        DatePicker(
                            "On Date",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                    }
                }
            }
            .navigationTitle("Add Discount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                        detectLink()
                        
                        if doesExpire {
                            editing_new_post_referral.referral.expiration = Int(round(date.timeIntervalSince1970))
                        }
                        
                        if selectedType == "None" {
                            editing_new_post_referral.referral.offer_type = ""
                            editing_new_post_referral.referral.offer_value = ""
                        } else {
                            if selectedType == "Dollars" {
                                editing_new_post_referral.referral.offer_type = "$"
                            } else if selectedType == "Percent" {
                                editing_new_post_referral.referral.offer_type = "%"
                            } else {
                                editing_new_post_referral.referral.offer_type = "OTHER"
                            }
                        }
                        
                        if !hasMinimumSpend {
                            editing_new_post_referral.referral.minimum_spend = ""
                        }
                        
                        new_post.referral = editing_new_post_referral.referral
                        
                        dismiss()
                    } label: {
                        Text("Add")
                            .foregroundColor(editing_new_post_referral.referral.code.isEmpty && editing_new_post_referral.referral.link.isEmpty ? .gray : .blue)
                    }
                    .disabled(editing_new_post_referral.referral.code.isEmpty && editing_new_post_referral.referral.link.isEmpty)
                }
            }
            .interactiveDismissDisabled()
            .onAppear {
                self.valueFocused = true
                
                self.editing_new_post_referral = new_post
            }
        }
    }
    
    func createReferralCorrectly() {
        
        
        
    }
    
    func detectLink() {
         
        if let text = editing_new_post_referral.referral.code as? String {
            do {
                // Detect URLs in String
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(
                    in: text,
                    options: [],
                    range: NSRange(location: 0, length: text.utf16.count)
                )
                // Get first URL found
                if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                    print(text[range])
                    
                    let url_from_text = String(text[range])
                    
                    editing_new_post_referral.referral.link = url_from_text
                    editing_new_post_referral.referral.code = ""
                    
                    return
                    
                } else {
                    print("No URL found")
                    
                    editing_new_post_referral.referral.link = ""
                    editing_new_post_referral.referral.code = text
                    // later, can remove spaces here from the CODE...
                        // e.g. -> let hasIllegalCharacter = !new_code.offer_value.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.%$")).isEmpty
                    
                    return
                }
            } catch let error {
                print("Do-Try Error: \(error.localizedDescription)")
                
                editing_new_post_referral.referral.link = ""
                editing_new_post_referral.referral.code = text
                
                return
                
            }
        } else {
            print("No Text Found Error")
            
            return
        }
        
        
    }
}
