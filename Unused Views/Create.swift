//
//  Create.swift
//  SwearBy
//
//  Created by Colin Power on 1/6/25.
//



import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct Create: View {
    
    @ObservedObject var users_vm: UsersVM
    @StateObject var temp_posts_vm: NewPostsVM = NewPostsVM()
    
    @Binding var showSignInPage: Bool
    
    @State var new_post: NewPosts = EmptyVariables().empty_new_post
    
    // Present "Add Product" and "Add Discount"
    @State private var presentReferralSheet:Bool = false
    @State private var presentProductSheet:Bool = false
    
    //Textfield - Referral
    @State private var referral_text: String = ""
    @FocusState var isReferralFocused: Bool
    @State private var animateGoButton: Bool = false
    
    //Textfield - Product
    @State private var product_text: String = ""
    @FocusState var isProductFocused: Bool
    @State private var animateGoButton2: Bool = false
    
    //Textfield - Description
    @FocusState var isDescriptionFocused: Bool
    
    //Visibility
    @State private var isPublic: Bool = true
    
    //Setup image upload
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    // Post as Demo user
    @State private var showDemoAccountList: Bool = false
    @State var demoAccountSelected:Users = EmptyVariables().empty_user
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color("Background")
                .onTapGesture {
                    self.isDescriptionFocused = false
                }
            
            VStack(alignment: .leading, spacing: 0) {
                if new_post.referral.code.isEmpty && new_post.referral.link.isEmpty {
                    //StandardHeader(title: "Create", isSearching: Binding.constant(false), fullScreenPresented: Binding.constant(nil))
                } else {
                    create_header
                }
                
                if new_post.referral.code.isEmpty && new_post.referral.link.isEmpty {
                    Text("Add a discount code or referral link")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                        .padding(.top)
                        .padding(.leading)
                        .padding(.leading)
                    referral_textfield
                        .padding(.top, 4)
                        .padding(.bottom)
                        .padding(.bottom)
                    
                    Spacer()
                    
                    Divider()
                    
                    Create_EmptyState()
                        .padding(.top)
                    
                } else if new_post.url.original.isEmpty {
                    Text("What product or site is this discount for?")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                        .lineLimit(2)
                        .padding(.top)
                        .padding(.leading)
                        .padding(.leading)
                    product_textfield
                        .padding(.vertical)
                    
                    Spacer()
                } else {
                    if !new_post.photo.isEmpty {
                        added_image
                            .padding(.vertical)
                    } else {
                        add_image
                            .padding(.vertical)
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            create_description
                                .padding(.vertical)
                            
                            set_visibility
                                .padding(.vertical)
                            
                            if users_vm.one_user.user_id == "Jb1nOzXJ49hH9Q5TyyTlT79328n1" {            // E22U3BQ2jycJ2WMnZIth7gVrIKL2
                                HStack {
                                    if demoAccountSelected.user_id.isEmpty {
                                        Button {
                                            showDemoAccountList = true
                                        } label: {
                                            Text("Choose Demo Account")
                                                .padding(.vertical, 5)
                                        }
                                    } else {
                                        Text(demoAccountSelected.info.name)
                                            .padding(.trailing)
                                        Button {
                                            demoAccountSelected = EmptyVariables().empty_user
                                        } label: {
                                            Text("REMOVE")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                    
                                }
                            }
                            
                            product_in_progress
                                .padding(.top)
                            
                            Button {
                                presentReferralSheet = true
                            } label: {
                                referral_in_progress
                                    .padding(.vertical)
                            }
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
                
                Spacer()
                
//                if !new_post.url.original.isEmpty {
//                    
//                }
//                
//                if !new_post.referral.code.isEmpty || !new_post.referral.link.isEmpty {
//                    
//                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color("Background"))
        .sheet(isPresented: $presentReferralSheet) {
            CreateSheet(new_post: $new_post)
        }
        .sheet(isPresented: $presentProductSheet) {
            AddProduct(new_post: $new_post)
        }
        .sheet(isPresented: $showDemoAccountList) {
            ChooseDemoUser(users_vm: users_vm, posts_vm: temp_posts_vm, demoAccountSelected: $demoAccountSelected)
        }
        .cropImagePicker(
            options: [.square],
            show: $showPicker,
            croppedImage: $croppedImage
        )
        .onAppear {
            resetNewPost()
        }
        .onChange(of: croppedImage, perform: { newValue in
                        
            new_post.photo = new_post._ID
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                uploadPhoto(post_id: new_post._ID)
            }
            
        })
    }
    
    func resetNewPost() {
        
        self.referral_text = ""
        self.product_text = ""
        self.isReferralFocused = false
        self.isProductFocused = false
        self.isDescriptionFocused = false
        self.isPublic = true
        
        self.new_post = EmptyVariables().empty_new_post
        self.demoAccountSelected = EmptyVariables().empty_user
        
        if new_post._ID.isEmpty {
            // setup the new_post object
            self.new_post._ID = UUID().uuidString               // ID
        }
    }
        
    
    var create_header: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                self.new_post = EmptyVariables().empty_new_post
            } label: {
                
                Text("Discard")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text("New Post")
                .font(.system(size: 19, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()

            Button {

                //Add followers to the access list, whether PUBLIC or PRIVATE
                if !isPublic {
                    new_post.isPublicPost = false
                } else {
                    new_post.isPublicPost = true
                }
                
                // IF ADMIN + HAS SELECTED DEMO ACCOUNT... POST AS DEMO ACCOUNT
                if (users_vm.one_user.user_id == "Jb1nOzXJ49hH9Q5TyyTlT79328n1") && !demoAccountSelected.user_id.isEmpty {
                    new_post.created_by_civilian = users_vm.one_user.user_id
                    NewPostsVM().create(new_post: new_post, user: demoAccountSelected)
                } else {
                    // Otherwise, post normally
                    NewPostsVM().create(new_post: new_post, user: users_vm.one_user)
                }                
                
                resetNewPost()
                
            } label: {
                
                Text("Share")
                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                    .foregroundColor(((!new_post.referral.code.isEmpty || !new_post.referral.link.isEmpty) && !new_post.url.full.isEmpty && !new_post.text.isEmpty) ? .blue : .gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .disabled(new_post.url.original.isEmpty)
        }
        .padding(.horizontal)
        .frame(height: 40)
        .padding(.top, 60)
        .padding(.bottom, 10)
        .frame(height: 110)
        .background(Color("Background"))
    }
    
    private var referral_textfield: some View {
        
        HStack(spacing: 0) {
            
                HStack(spacing: 0) {
                    
                    TextField("KATHLEEN10", text: $referral_text)
                        .textFieldStyle(.plain)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .focused($isReferralFocused)
                        .keyboardType(.default)
                        .submitLabel(.done)
                        .onSubmit {
                            
                            if !referral_text.isEmpty {
                                
                                if users_vm.one_user.user_id.isEmpty {
                                    showSignInPage = true
                                } else {
                                    // Dismiss the keyboard
                                    isReferralFocused = false
                                    
                                    // Set the text as the new code
                                    new_post.referral.code = referral_text.trimmingTrailingSpaces()
                                    
                                    // Wipe the text
                                    referral_text = ""
                                    
                                    // Open the referral sheet
                                    presentReferralSheet = true
                                }
                            } else {
                                // Dismiss the keyboard
                                isReferralFocused = false
                            }
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .foregroundColor(Color("text.black"))
                        
                    Spacer()
                    
                    if isReferralFocused && !referral_text.isEmpty {
                        
                        Button {
                            referral_text = ""
                            
                            isReferralFocused = true
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color("text.gray").opacity(0.6))
                        }
                        .padding(.trailing)
                    }
                    
                }
                .frame(height: 48)
                .padding(.leading).padding(.leading, 5)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color("WebViewWhite")))
            
            if animateGoButton {
                Button {
                    if users_vm.one_user.user_id.isEmpty {
                        showSignInPage = true
                    } else {
                        // Dismiss the keyboard
                        isReferralFocused = false
                        
                        // Set the text as the new code
                        new_post.referral.code = referral_text.trimmingTrailingSpaces()
                        
                        // Wipe the text
                        referral_text = ""
                        
                        // Open the referral sheet
                        presentReferralSheet = true
                    }
                    
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(!referral_text.isEmpty ? .blue : .gray.opacity(0.2))
                        .frame(width: 48, height: 48)
                }
                .disabled(referral_text.isEmpty)
                .padding(.leading)
                .background(.clear)
            }
            
        }
        .frame(height: 48)
        .padding(.horizontal).padding(.horizontal, 5)
        .padding(.vertical, 8)
        .onChange(of: isReferralFocused) { focus in
            if focus {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.linear(duration: 0.2)) {
                        animateGoButton = true
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.linear(duration: 0.2)) {
                        animateGoButton = false
                    }
                }
            }
        }
    }
    
    private var product_textfield: some View {
        
        HStack(spacing: 0) {
            
                HStack(spacing: 0) {
                    
                    TextField("revolve.com/shirts/cropped-tee", text: $product_text)
                        .textFieldStyle(.plain)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                        .focused($isProductFocused)
                        .keyboardType(.URL)
                        .submitLabel(.go)
                        .onSubmit {
                            
                            if !product_text.isEmpty {
                                
                                // Dismiss the keyboard
                                isProductFocused = false
                                
                                // Remove trailing spaces
                                product_text.trimmingTrailingSpaces()
                                
                                // Check for http or https
                                let has_https = product_text.contains("https://") || product_text.contains("http://")
                                
                                // Set the url
                                new_post.url.original = has_https ? product_text : "https://" + product_text
                                
                                // Wipe the variable
                                product_text = ""
                                
                                // Open the referral sheet
                                presentProductSheet = true
                                
                            } else {
                                // Dismiss the keyboard
                                isProductFocused = false
                            }
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .foregroundColor(Color("text.black"))
                        
                    Spacer()
                    
                    if product_text.isEmpty {
                        Button {
                            if let pasteboardString = UIPasteboard.general.string {
                                if !pasteboardString.isEmpty {
                                    
                                    new_post.url.original = pasteboardString
                                    
                                    // Dismiss the keyboard
                                    isProductFocused = false
                                    
                                    // Open the referral sheet
                                    
                                    presentProductSheet = true
                                }
                            }
                            
                        } label: {
                            Text("Paste")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal)
                                .background(Capsule().foregroundStyle(.blue))
                        }
                        .padding(.trailing)
                    } else {
                        Button {
                            product_text = ""
                            
                            isProductFocused = true
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color("text.gray").opacity(0.6))
                        }
                        .padding(.trailing)
                    }
                    
                }
                .frame(height: 48)
                .padding(.leading).padding(.leading, 5)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color("WebViewWhite")))
            
            if animateGoButton2 {
                Button {
                    
                    if !product_text.isEmpty {
                        // Dismiss the keyboard
                        isProductFocused = false
                        
                        // Set the url
                        new_post.url.original = product_text
                        
                        // Wipe the variable
                        product_text = ""
                        
                        // Open the referral sheet
                        presentProductSheet = true
                    }
                    
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(!product_text.isEmpty ? .blue : .gray.opacity(0.2))
                        .frame(width: 48, height: 48)
                }
                .disabled(product_text.isEmpty)
                .padding(.leading)
                .background(.clear)
            }
        }
        .frame(height: 48)
        .padding(.horizontal).padding(.horizontal, 5)
        .padding(.vertical, 8)
        .onChange(of: isProductFocused) { focus in
            if focus {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.linear(duration: 0.1)) {
                        animateGoButton2 = true
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.linear(duration: 0.1)) {
                        animateGoButton2 = false
                    }
                }
            }
        }
    }
    
    var create_description: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            TextField("Add a description! Why do you swear by this product?", text: $new_post.text, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .keyboardType(.default)
                .focused($isDescriptionFocused)
                .submitLabel(.return)
                .lineLimit(3...5)
                .foregroundColor(.black)
                .padding(.all)
                .padding(.leading, 5)
            
            Spacer()
        }
    }
    
    var add_image: some View {
        
        Button {
            showPicker = true
        } label: {
            Text("Add a picture")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.blue)
                .frame(width: 150, height: 180)
                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.blue.opacity(0.1)))
        }
        .frame(width: UIScreen.main.bounds.width, height: 180, alignment: .center)
        
    }
    
    var added_image: some View {
        
        ZStack(alignment: .topTrailing) {
            
            let s = CGFloat(150)
            
            if let croppedImage {
                Image(uiImage: croppedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: s, height: s)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                WebImage(url: URL(string: new_post.photo))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: s, height: s)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button {
                new_post.photo = ""
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.all, 6)
                    .background(Circle().foregroundColor(.gray.opacity(0.7)))
                    .padding(.trailing, 12)
                    .padding(.top, 12)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .center)
    }
    
    var referral_in_progress: some View {
            
        VStack(alignment: .leading, spacing: 0) {
            
            let str1 = new_post.referral.offer_type == "$" ? ("$" + new_post.referral.offer_value) : new_post.referral.offer_type == "%" ? (new_post.referral.offer_value + "%") : new_post.referral.offer_value
            let str2 = new_post.referral.code.isEmpty ? ("Use my link") : ("Use code " + new_post.referral.code)
            
            Text(str1)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.green)
                .lineLimit(1)
                .padding(.trailing)
                .padding(.trailing)
                .padding(.bottom, 1)
            
            Text(str2)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
                .lineLimit(1)
            
        }
        .padding(.all)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.gray.opacity(0.1)))
        .padding(.horizontal)
    }
    
    var product_in_progress: some View {
            
        HStack(alignment: .center, spacing: 0) {

            if !new_post.url.image_url.isEmpty {
                WebImage(url: URL(string: new_post.url.image_url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(new_post.url.page_title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.bottom, 2)
                
                Text(new_post.url.host)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .lineLimit(1)
                
            }
            .padding(.leading)
            
            Spacer()
        }
        .padding(.all, 10)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.gray.opacity(0.1)))
        .padding(.horizontal)
    }
    
    
    var set_visibility: some View {
        
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "globe.americas.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .leading)
                .foregroundColor(Color("text.black"))
                .padding(.horizontal)
            
            Text("Visibility")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            Spacer()
            
            Button {
                isPublic.toggle()
            } label: {
                Text(isPublic ? "Everyone" : "My followers")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.trailing, 12)
                
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10, alignment: .leading)
                    .foregroundColor(Color("text.gray"))
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(.horizontal)
        .padding(.leading, 5)
    }
    
    
    
    func uploadPhoto(post_id: String) {
        
        // Make sure that the selected image property isn't nil
        guard croppedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into data
        let imageData = croppedImage!.pngData()
        
        guard imageData != nil else {
            print("returned nil.. trying to do it as a png instead")

            return
        }
        
        //Specify the file path and name
        let fileRef = storageRef.child("photos/\(post_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                
                print("successfully uploaded")
                // TODO: Save a reference to the file in Firestore DB
                // make call to Firebase here...
            }
        }
    }
    
}


struct Create_EmptyState: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text("How do I share a discount?")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.leading, 5)
                .padding(.bottom)
                .padding(.bottom, 6)
            
            Create_1(num: "1", title: "Add a referral code or link", subtitle: "KATHLEEN10")
            Create_1(num: "2", title: "Add the website it's for", subtitle: "revolve.com/shirts/cropped-tee")
                .padding(.vertical, 10)
            Create_1(num: "3", title: "Add a pic or description", subtitle: "\"These are my favorite shirts\"")

        }
        .padding(.all)
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        
    }
    
}

struct Create_1: View {
    
    var num: String
    var title: String
    var subtitle: String
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            
            Image(systemName: (num + ".circle"))
                .font(.system(size: 21, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.top, 3)
                .padding(.trailing)
                
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.gray"))
                    .padding(.bottom, 2)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.gray").opacity(0.8))
            }
        }
        .frame(height: 50)
    }
}

struct Create_2: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "2.circle")
                .font(.system(size: 21, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.trailing)
                
            Text("Specify the website that your discount works on")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.gray"))
        }
        .frame(height: 50)
    }
}

struct Create_3: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "3.circle")
                .font(.system(size: 21, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.gray"))
                .padding(.trailing)
                
            Text("Add details or a picture")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.gray"))
        }
        .frame(height: 50)
    }
}
