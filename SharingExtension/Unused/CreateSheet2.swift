////
////  CreateSheet2.swift
////  SharingExtension
////
////  Created by Colin Power on 11/20/23.
////
//
//import Foundation
//import SwiftUI
//import WebKit
//import FirebaseStorage
//import SDWebImageSwiftUI
//
//
//enum UploadStatus: String, Identifiable {
//    case READY, UPLOADING, SUCCESS, ERROR
//    var id: String {
//        return self.rawValue
//    }
//}
//
//struct CreateSheet2: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var store = StorageManager()
//    
//    // Received from prior view
//    @ObservedObject var users_vm: UsersVM2
//    @ObservedObject var posts_vm = PostsVM2()
//    @Binding var isShowingCreateSheet: Bool                     // show sheet
//    @Binding var selectedTab: Int                               // choose which tab (reset when you post)
//    @State var initial_url: String                              // the INITIAL_URL for the rich webview, which has already been
//    @State var new_post: Posts2                                  // the object that will become the posted thing
//    @State var initial_title: String
//    
//    // Webview variables
//    @State private var action = WebViewAction.idle
//    @State private var state = WebViewState.empty
//    @State var available_images: [String] = []
//    @State var page_title:String = ""                  // title
//    @State var brand_favicon:String = ""
//    
//    
//    // Manage this page
//    @State private var didSelectSwearBy: Bool = false
//    @State private var didSelectReferralCode: Bool = false
//    @State private var didSelectPoll: Bool = false
//    @State private var isShowingChangeThumbnail = false
//    @State private var isShowingAddImage = false
//    @State private var isShowingCreateReferral = false
//    @State private var isShowingChooseAccess = false
//    @State private var sheetDetent: PresentationDetent = .height(UIScreen.main.bounds.height * 0.5)
//    
//    //Setup image upload
//    @State private var showPicker: Bool = false
//    @State private var croppedImage: UIImage?
//    
//    // For the upload button
//    @State private var uploadStatus:UploadStatus = .READY
//    
//    
//    @FocusState private var descriptionFocused: Bool
//    @FocusState private var option1Focused: Bool
//    @FocusState private var option2Focused: Bool
//    @FocusState private var option3Focused: Bool
//    @FocusState private var option4Focused: Bool
//    
//    // Capture data for post
//    @State private var selected_image:String = ""
//    @State private var description: String = ""
//    //@State private var temp_custom_group: Groups = EmptyVariables().empty_group
//    @State private var path = NavigationPath()
//    
//    
//    //Visibility
//    @State private var isPublic: Bool = true
//    
//    // Post as Demo Account
//    @State private var showDemoAccountList: Bool = false
//    @State var demoAccountSelected:Users2 = EmptyVariables().empty_user2
//    
//    
//    var body: some View {
//        
//        ZStack(alignment: .top) {
//            
//            // Bottom -> Reload the webpage and get images / title
//            WebViewRepresentable(action: $action,
//                                 state: $state,
//                                 product_image_urls: $available_images,
//                                 product_name: $page_title,
//                                 initial_url: $initial_url,
//                                 brand_favicon: $brand_favicon)
//            
//            // Cover the webview
//            Color.white
//                .onTapGesture {
//                    self.descriptionFocused = false
//                }
//                
//            // Main page for editing
//            VStack(alignment: .leading, spacing: 0) {
//                 
//                create_header
//                
//                if new_post.photo != "" {
//                    added_image
//                        .padding(.vertical)
//                } else {
//                    add_image
//                        .padding(.vertical)
//                }
//                
//                ScrollView(showsIndicators: false) {
//                    VStack(alignment: .leading, spacing: 0) {
//                        create_description
//                            .padding(.vertical)
//                        
//                        set_visibility
//                            .padding(.vertical)
//                        
//                        Divider()
//                        
//                        create_callout
//                        
//                        referral_in_progress
//                        
//                        if users_vm.one_user.user_id == "Jb1nOzXJ49hH9Q5TyyTlT79328n1" {
//                            HStack {
//                                if demoAccountSelected.user_id.isEmpty {
//                                    Button {
//                                        showDemoAccountList = true
//                                    } label: {
//                                        Text("Choose Demo Account")
//                                            .padding(.vertical, 5)
//                                    }
//                                } else {
//                                    Text(demoAccountSelected.info.name + " " + demoAccountSelected.info.name)
//                                        .padding(.trailing)
//                                    Button {
//                                        demoAccountSelected = EmptyVariables().empty_user2
//                                    } label: {
//                                        Text("REMOVE")
//                                            .foregroundStyle(.red)
//                                    }
//                                }
//                                
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                    }.ignoresSafeArea(.keyboard, edges: .bottom)
//                }
//
////                button_bar
////                .KeyboardAwarePadding(offset: 0)
//            }
//            
//            
//        }
//        .edgesIgnoringSafeArea(.all)
//        .interactiveDismissDisabled()
//        .cropImagePicker(
//            options: [.square],
//            show: $showPicker,
//            croppedImage: $croppedImage
//        )
//        .onAppear {
//            
//            // setup the new_post object
//            self.new_post._ID = UUID().uuidString               // ID
//            
//            self.store.getUser(user_id: users_vm.one_user.user_id)
//            
//        }
//        .onChange(of: available_images) { newValue in           // IMAGE_URL
//            if !newValue.isEmpty {
//                available_images = available_images.removingDuplicates()
//                if let img = available_images.first {
//                    selected_image = img
//                    new_post.url.image_url = img
//                }
//            }
//        }
//        .onChange(of: croppedImage, perform: { newValue in
//                        
//            new_post.photo = new_post._ID
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                uploadPhoto(user_id: users_vm.one_user.user_id)
//            }
//            
//        })
//        .onChange(of: page_title) { newValue in
//            self.new_post.url.page_title = newValue
//        }
//        .sheet(isPresented: $showDemoAccountList) {
//            ChooseDemoUser(users_vm: users_vm, demoAccountSelected: $demoAccountSelected)
//        }
//        .navigationBarBackButtonHidden()
//    }
//    
//    
//    var create_header: some View {
//        
//        HStack(alignment: .center, spacing: 0) {
//            
//            Button {
//                dismiss()
//            } label: {
//                
//                Text("Back")
//                    .font(.system(size: 19, weight: .regular, design: .rounded))
//                    .foregroundColor(.black)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            
//            Spacer()
//            
//            Text("New Post")
//                .font(.system(size: 17, weight: .semibold, design: .rounded))
//                .foregroundColor(.black)
//                .frame(maxWidth: .infinity, alignment: .center)
//            
//            Spacer()
//
//            Button {
//                
//                // TODO: upload the image and set the photo_id
//                
//                //new_post.access.group = "PUBLIC"                            // Set the access
//                //new_post.access.list = users_vm.one_user.followers.list     // Set the list
//                new_post.url.site_favicon = brand_favicon                   // favicon
//                // MISSING -> SITE_ID and SITE_TITLE
//                
//                if !isPublic {
//                    new_post.isPublicPost = false
//                } else {
//                    new_post.isPublicPost = true
//                }
//                
//                // IF ADMIN + HAS SELECTED DEMO ACCOUNT... POST AS DEMO ACCOUNT
//                if (users_vm.one_user.user_id == "Jb1nOzXJ49hH9Q5TyyTlT79328n1") && !demoAccountSelected.user_id.isEmpty {
//                    new_post.created_by_civilian = users_vm.one_user.user_id
//                    posts_vm.create(post: new_post, user: demoAccountSelected)    // Post
//                } else {
//                    // Otherwise, post normally
//                    posts_vm.create(post: new_post, user: users_vm.one_user)    // Post
//                }
//                
//                selectedTab = 0                                             // Reset tab on prior page
//                isShowingCreateSheet = false                                // Dismiss
//                
//            } label: {
//                
//                Text("Share")
//                    .font(.system(size: 19, weight: .medium, design: .rounded))
//                    .foregroundColor((new_post.text.isEmpty) ? .gray.opacity(0.5) : .blue)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                
//            }
//            .disabled(new_post.text.isEmpty)
//        }
//        .padding(.horizontal)
//        .padding(.horizontal, 6)
//        .padding(.top)
//    }
//    
//    
//    var set_visibility: some View {
//        
//        
//        HStack(alignment: .center, spacing: 0) {
//            
//            Image(systemName: "globe.americas.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 20, height: 20, alignment: .leading)
//                .foregroundColor(.black)
//                .padding(.horizontal)
//            
//            Text("Visibility")
//                .font(.system(size: 17, weight: .medium, design: .rounded))
//                .foregroundColor(.black)
//            
//            Spacer()
//            
//            Button {
//                isPublic.toggle()
//            } label: {
//                Text(isPublic ? "Everyone" : "My followers")
//                    .font(.system(size: 15, weight: .regular, design: .rounded))
//                    .foregroundColor(.gray)
//                    .padding(.trailing, 12)
//                
//                Image(systemName: "ellipsis")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 10, height: 10, alignment: .leading)
//                    .foregroundColor(.gray)
//                    .rotationEffect(.degrees(-90))
//            }
//        }
//        .padding(.horizontal)
//        .padding(.leading, 5)
//    }
//    
//    var add_image: some View {
//        
//        Button {
//            showPicker = true
//        } label: {
//            Text("Add a picture")
//                .font(.system(size: 15, weight: .regular, design: .rounded))
//                .foregroundColor(.blue)
//                .frame(width: 150, height: 180)
//                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.blue.opacity(0.1)))
//        }
//        .frame(width: UIScreen.main.bounds.width, height: 180, alignment: .center)
//        
//    }
//    
//    
//    var referral_in_progress: some View {
//            
//        VStack(alignment: .leading, spacing: 0) {
//            
//            let str1 = new_post.referral.offer_type == "$" ? ("$" + new_post.referral.offer_value) : new_post.referral.offer_type == "%" ? (new_post.referral.offer_value + "%") : new_post.referral.offer_value
//            let str2 = new_post.referral.code.isEmpty ? ("Use my link") : ("Use code " + new_post.referral.code)
//            
//            Text(str1)
//                .font(.system(size: 17, weight: .semibold, design: .rounded))
//                .foregroundColor(.green)
//                .lineLimit(1)
//                .padding(.trailing)
//                .padding(.trailing)
//                .padding(.bottom, 1)
//            
//            Text(str2)
//                .font(.system(size: 15, weight: .medium, design: .rounded))
//                .foregroundColor(.gray)
//                .lineLimit(1)
//            
//        }
//        .padding(.all)
//        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.gray.opacity(0.1)))
//        .padding(.horizontal)
//    }
//    
//    var create_callout: some View {
//        
//        VStack(alignment: .leading, spacing: 0) {
//            
//            HStack(alignment: .center, spacing: 0) {
//                VStack(alignment: .leading, spacing: 0) {
//                    HStack(alignment: .center, spacing: 0) {
//                        
//                        if state.isLoading {
//                            ProgressView()
//                                .frame(width: 44, height: 44)
//                            
//                        } else if !new_post.url.image_url.isEmpty {
//                            WebImage(url: URL(string: new_post.url.image_url)!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 44, height: 44)
//                                .clipShape(RoundedRectangle(cornerRadius: 6))
//                        } else {
//                            RoundedRectangle(cornerRadius: 6)
//                                .foregroundColor(.clear)
//                                .frame(width: 44, height: 44)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 0) {
//                            
//                            Text(state.isLoading ? initial_title : new_post.url.page_title)
//                                .font(.system(size: 15, weight: .semibold, design: .rounded))
//                                .foregroundColor(.black)
//                                .lineLimit(1)
//                                .padding(.bottom, 3)
//                            
//                            Text(new_post.url.host)
//                                .font(.system(size: 14, weight: .regular, design: .rounded))
//                                .foregroundColor(.gray)
//                                .lineLimit(1)
//                            
//                        }.padding(.leading)
//                        
//                        Spacer(minLength: 10)
//                        
//                        Button {
//                            isShowingChangeThumbnail = true
//                        } label: {
//                            Text("Change thumbnail")
//                                .font(.system(size: 15, weight: .regular, design: .rounded))
//                                .foregroundColor(state.isLoading ? .gray.opacity(0.2) : .gray)
//                                .padding(.all, 12)
//                        }
//                        .disabled(state.isLoading)
//                        .padding(.leading, 10)
//                        
//                    }
//                    .padding(.vertical, 9)
//                    .padding(.horizontal, 9)
//                
//                }
//                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.gray.opacity(0.08)))
//            }
//        }
//        .padding(.all)
//    }
//    
//    var create_description: some View {
//        
//        VStack(alignment: .leading, spacing: 0) {
//            
//            TextField("Add a description! Why do you swear by this product?", text: $new_post.text, axis: .vertical)
//                .textFieldStyle(.plain)
//                .font(.system(size: 17, weight: .regular, design: .rounded))
//                .keyboardType(.default)
//                .lineLimit(3...5)
//                .autocorrectionDisabled()
//                .focused($descriptionFocused)
//                .submitLabel(.return)
//                .foregroundColor(.black)
//                .padding(.all)
//                .padding(.leading, 5)
//                .padding(.bottom)
//            
//        }
//    }
//    
//    var choose_from_images: some View {
//        
//        ScrollView(.horizontal) {
//            
//            HStack {
//                
//                let w = (UIScreen.main.bounds.width - 8) / 3
//                
//                if available_images.isEmpty {
//                    ProgressView()
//                } else {
//                    
//                    let images_deduped = available_images.removingDuplicates()
//                    
//                    ForEach(0..<images_deduped.count, id: \.self) { index in
//                        
//                        Button {
//                            selected_image = images_deduped[index]
//                        } label: {
//                            ZStack(alignment: .center) {
//                                
//                                //if !product_image_urls[index].isEmpty {
//                                if let img:String = images_deduped[index] as? String {
//                                    WebImage(url: URL(string: img))
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: w, height: w)
//                                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                                    
//                                    RoundedRectangle(cornerRadius: 8).stroke(selected_image == img ? .blue : .clear, lineWidth: 3)
//                                        .frame(width: w - 3, height: w - 3)
//                                }
//                            }
//                            .padding(.trailing, 10)
//                        }
//                        
//                        
//                    }
//                }
//            }
//            
//            
//        }
//        
//        
//    }
//    
//    var added_referral: some View {
//        
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(alignment: .center, spacing: 0) {
//                HStack(alignment: .center, spacing: 0) {
//                    
//                    Image(systemName: "dollarsign.circle.fill")
//                        .font(.system(size: 40, weight: .medium, design: .rounded))
//                        .foregroundColor(.green.opacity(0.3))
//                        .padding(.all, 1)
//                        .padding(.trailing, 7)
//                    
//                    VStack(alignment: .leading, spacing: 0) {
//                        
//                        var str1: String {
//                            switch new_post.referral.offer_type {
//                            case "$":
//                                return "Get $" + new_post.referral.offer_value
//                            case "%":
//                                return "Get " + new_post.referral.offer_value + "%"
//                            case "":
//                                return new_post.referral.link.isEmpty ? "Shop with my code" : "Shop with my link"
//                            default:
//                                return "Shop with my link"
//                            }
//                        }
//                        
//                        Text(str1)
//                            .font(.system(size: 16, weight: .semibold, design: .rounded))
//                            .foregroundColor(.green)
//                            .padding(.bottom, 2)
//                        Text(new_post.referral.link.isEmpty ? "Use my code " + new_post.referral.code : "Use my link")
//                            .font(.system(size: 14, weight: .regular, design: .rounded))
//                            .foregroundColor(.green)
//                            .lineLimit(1)
//                    }
//                    
//                    Spacer()
//                    
//                    Button {
//                        isShowingCreateReferral = true
//                    } label: {
//                        Text("Edit")
//                            .font(.system(size: 14, weight: .bold, design: .rounded))
//                            .foregroundColor(.white)
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 10)
//                            .background(Capsule().foregroundColor(.green))
//                            .padding(.vertical, 6)
//                            .padding(.trailing, 10)
//                    }
//                }
//                .padding(.trailing, 1)
//                .background(Capsule().foregroundColor(.green.opacity(0.1)))
//                .onTapGesture {
//                    isShowingCreateReferral = true
//                }
//                
//                Button {
//                    new_post.referral.code = ""
//                    new_post.referral.link = ""
//                    new_post.referral.offer_type = ""
//                    new_post.referral.offer_value = ""
//                    new_post.referral.for_new_customers_only = false
//                } label: {
//                    Image(systemName: "xmark")
//                        .font(.system(size: 12, weight: .semibold, design: .rounded))
//                        .foregroundColor(.gray)
//                        .padding(.all, 6)
//                        .padding(.horizontal, 12)
//                }
//            }
//            
//            if new_post.referral.for_new_customers_only {
//                Text("For new customers only")
//            }
//        }
//        .padding(.horizontal)
//        .padding(.bottom)
//        
//        
//    }
//        
//    var added_image: some View {
//        
//        ZStack(alignment: .topTrailing) {
//            
//            let s = CGFloat(150)
//            
//            if let croppedImage {
//                Image(uiImage: croppedImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: s, height: s)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//            } else {
//                WebImage(url: URL(string: new_post.photo))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: s, height: s)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//            }
//            
//            Button {
//                new_post.photo = ""
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.system(size: 12, weight: .semibold, design: .rounded))
//                    .foregroundColor(.white)
//                    .padding(.all, 6)
//                    .background(Circle().foregroundColor(.gray.opacity(0.7)))
//                    .padding(.trailing, 12)
//                    .padding(.top, 12)
//            }
//        }
//        .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .center)
//    }
//    
//    var create_image: some View {
//        
//        ZStack(alignment: .topTrailing) {
//            
//            let s = UIScreen.main.bounds.width - 60
//            
//            if !selected_image.isEmpty {
//                WebImage(url: URL(string: selected_image))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: s, height: s)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .padding(.horizontal, 30)
//            } else {
//                
//                RoundedRectangle(cornerRadius: 20)
//                    .frame(width: s, height: s)
//                    .foregroundColor(.gray)
//                    .clipShape(RoundedRectangle(cornerRadius: 30))
//                    .padding(.horizontal, 30)
//
//            }
//            
//            Button {
//                isShowingAddImage = true
//            } label: {
//                Circle()
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(.red)
//                    .padding(.trailing, 40)
//                    .padding(.top, 10)
//            }
//            
//        }
//        
//        
//    }
//    
//    var create_access: some View {
//        
//        VStack(alignment: .leading, spacing: 0) {
//            Spacer()
//            
////            SelectAccessWidget(users_vm: users_vm, access_list: $access_list, temp_custom_group: $temp_custom_group, path: $path, description: $description, new_comment: $new_comment)
////                .KeyboardAwarePadding(offset: 40)
//        }
//    }
//    
//    func uploadPhoto(user_id: String) {
//        
//        // Make sure that the selected image property isn't nil
//        guard croppedImage != nil else {
//            return
//        }
//        
//        // Create storage reference
//        let storageRef = Storage.storage().reference()
//        
//        // Turn our image into data
//        let imageData = croppedImage!.pngData()
//        
//        guard imageData != nil else {
//            print("returned nil.. trying to do it as a png instead")
//
//            return
//        }
//        
//        //Specify the file path and name
//        let fileRef = storageRef.child("photos/\(new_post._ID).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
//        
//        // Upload that data
//        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
//            
//            //Check for errors
//            if error == nil && metadata != nil {
//                
//                
//                print("successfully uploaded")
//                // TODO: Save a reference to the file in Firestore DB
//                // make call to Firebase here...
//            }
//        }
//    }
//}
//
//
//
//
//
//
//struct SelectAccessStruct: Hashable {
//    
//    let test: String
//    
//}
//
//struct SelectAccessStruct_Group: Hashable {
//    
//    let test: String
//    
//}
//
//struct SelectAccessStruct_SelectFriend: Hashable {
//    
//    let test: String
//    
//}
