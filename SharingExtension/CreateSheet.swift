//
//  CreateSheet.swift
//  SwearBy
//
//  Created by Colin Power on 1/23/25.
//

import Foundation
import SwiftUI

struct GoToPage: Hashable {
    
    let page: String
    
}


struct CreateSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var users_vm: UsersVM2
    @ObservedObject var posts_vm: PostsVM2
    
    @State var boilerplate_post: Posts2
    @State var initial_title: String
    @State var initial_code: String
    
    @State private var new_post: Posts2 = EmptyVariables().empty_post2
    @State private var txt = ""
    @State private var creator_instagram = ""
    @State private var description = ""
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
    @FocusState private var creatorInstagramFocused: Bool
    @FocusState private var descriptionFocused: Bool
    
    
    @State var path = NavigationPath()
    
    var goToPage: [GoToPage] = [.init(page: "Create")]

    var body: some View {
        
        NavigationStack(path: $path) {
            Form {
                
                // SECTION 1: CODE
                Section(header: Text("Your Discount for \(convertURLToHostname(url: boilerplate_post.url.full))"), footer: (!new_post.referral.code.isEmpty ? Text("Users must enter this code: " + new_post.referral.code) : !new_post.referral.link.isEmpty ? Text("Users must enter this link: " + new_post.referral.link) : Text(""))) {
                    
                    TextField("Enter code or link", text: $new_post.referral.code)
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
                
                // SECTION 2: VALUE
                Section(header: Text("Discount Value")) {
                    
                    Picker("Discount", selection: $selectedType) {
                        ForEach(discount_types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedType) { _ in
                        if selectedType == "None" {
                            new_post.referral.offer_type = ""
                            new_post.referral.offer_value = ""
                        } else {
                            if selectedType == "Dollars" {
                                new_post.referral.offer_type = "$"
                            } else if selectedType == "Percent" {
                                new_post.referral.offer_type = "%"
                            } else {
                                new_post.referral.offer_type = "OTHER"
                            }
                        }
                    }
                    
                    if selectedType != "None" {
                        
                        HStack {
                            if selectedType == "Dollars" && !new_post.referral.offer_value.isEmpty {
                                Text("$")
                            }
                            if selectedType == "Dollars" || selectedType == "Percent" {
                                TextField(selectedType == "Dollars" ? "$50" : "25%", text: $new_post.referral.offer_value)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("Describe the offer value", text: $new_post.referral.offer_value)
                                    .keyboardType(.default)
                            }
                            if selectedType == "Percent" && !new_post.referral.offer_value.isEmpty {
                                Text("%")
                            }
                        }
                        
                    }
                }
                
                // SECTION 3: CREATOR NAME
                Section(header: Text("Instagram of Creator")) {
                    
                    TextField("e.g. @kathleen.post", text: $creator_instagram)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .focused($creatorInstagramFocused)
                        .submitLabel(.return)
                        .onSubmit {
                            creatorInstagramFocused = false
                        }
                    
                    URLPreview_Instagram(handle: creator_instagram, instagram_url: "https://www.instagram.com/colinjpower") // Note: error may occur if instagram handle does not exist
                }
                
                
                // SECTION 4: DETAILS (Min spend, expiration)
                Section(header: Text("Details")) {
                    
                    if selectedType != "None" {
                        Section {
                            Toggle("Minimum Spend", isOn: $hasMinimumSpend)
                                .onChange(of: hasMinimumSpend) { _ in
                                    if !hasMinimumSpend {
                                        new_post.referral.minimum_spend = ""
                                    }
                                }
                            
                            if hasMinimumSpend {
                                TextField("Amount", text: $new_post.referral.minimum_spend)
                                    .keyboardType(.numberPad)
                            }
                            Toggle("Expires", isOn: $doesExpire)
                                .onChange(of: doesExpire) { _ in
                                    if !doesExpire {
                                        new_post.referral.expiration = 0
                                    }
                                }
                            
                            if doesExpire {
                                
                                DatePicker(
                                    "On Date",
                                    selection: $date,
                                    displayedComponents: [.date]
                                )
                                .onChange(of: date) { _ in
                                    new_post.referral.expiration = Int(round(date.timeIntervalSince1970))
                                }
                            }
                        }
                    }
                }
                    
                // SECTION 5: ADD TEXT
                Section(header: Text("More Details")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 120)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($descriptionFocused)
                }
                
                
                // SECTION 6: POST ANONYMOUSLY?
                Section(footer: (new_post.isPublicPost ? Text("Post will appear as @colinjpower1") : Text("Post will appear as anonymous"))) {
                    Toggle("Post publicly", isOn: $new_post.isPublicPost)
                }
            }
            .navigationTitle("Add Discount Code")
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
                        
                        posts_vm.create(post: new_post, user: users_vm.one_user)    // Post
                        
                        dismiss()                                                   // Dismiss
                        
                    } label: {
                        Text("Add")
                            .font(.system(size: 19, weight: .medium, design: .rounded))
                            .foregroundColor((new_post.referral.code.isEmpty || new_post.referral.offer_value.isEmpty || creator_instagram.isEmpty) ? .gray : .blue)
                    }
                    .disabled(new_post.referral.code.isEmpty || new_post.referral.offer_value.isEmpty || creator_instagram.isEmpty)          // code is empty OR value is empty OR creator is empty
                }
            }
            .onAppear {
                
                //Set the focus on entering the code / link
                self.codeOrLinkFocused = true
                
                // Merge the boilerplate_post into the new_post
                self.new_post._ID = UUID().uuidString
                
                mergeBoilerplateWithNewPost()
            }
        }
        
        
    }
    
    func createReferralCorrectly() {
        
        
        
    }
    
    func mergeBoilerplateWithNewPost() {
        self.new_post.url = self.boilerplate_post.url
        self.new_post.referral.code = self.boilerplate_post.referral.code
    }
    
    
    func detectLink() {
        
//        if txt.contains("/") {
//            new_post.referral.link = txt
//        } else {
//            new_post.referral.code = txt
        
        
        if let text = txt as? String {
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
                    
                    new_post.referral.link = url_from_text
                    new_post.referral.code = ""
                    
                    return
                    
                } else {
                    print("No URL found")
                    
                    new_post.referral.link = ""
                    new_post.referral.code = text
                    // later, can remove spaces here from the CODE...
                        // e.g. -> let hasIllegalCharacter = !new_code.offer_value.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.%$")).isEmpty
                    
                    return
                }
            } catch let error {
                print("Do-Try Error: \(error.localizedDescription)")
                
                new_post.referral.link = ""
                new_post.referral.code = text
                
                return
                
            }
        } else {
            print("No Text Found Error")
            new_post.referral.link = ""
            new_post.referral.code = txt
            return
        }
        
        
    }
    
}
