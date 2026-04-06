//
//  AddProduct.swift
//  SwearBy
//
//  Created by Colin Power on 1/20/25.
//

import Foundation
import SwiftUI
import WebKit
import FirebaseStorage
import SDWebImageSwiftUI

enum UploadStatus: String, Identifiable {
    case READY, UPLOADING, SUCCESS, ERROR
    var id: String {
        return self.rawValue
    }
}

struct SelectAccessStruct: Hashable {
    
    let test: String
    
}

struct SelectAccessStruct_Group: Hashable {
    
    let test: String
    
}

struct SelectAccessStruct_SelectFriend: Hashable {
    
    let test: String
    
}

struct AddProduct: View {
    
    @Environment(\.dismiss) var dismiss
    
    // Received from prior view
    @Binding var new_post: NewPosts
    
    // Webview variables
    @State var initial_url:String = ""                  // title
    @State private var action = WebViewAction.idle
    @State private var state = WebViewState.empty
    @State var available_images: [String] = []
    @State var page_title:String = ""                  // title
    @State var brand_favicon:String = ""
    
    
    // Manage this page
    @State private var didSelectSwearBy: Bool = false
    @State private var didSelectReferralCode: Bool = false
    @State private var didSelectPoll: Bool = false
    @State private var isShowingChangeThumbnail = false
    @State private var isShowingAddImage = false
    @State private var isShowingCreateReferral = false
    @State private var isShowingChooseAccess = false
    @State private var sheetDetent: PresentationDetent = .height(UIScreen.main.bounds.height * 0.5)
    
    //Setup image upload
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    // For the upload button
    @State private var uploadStatus:UploadStatus = .READY
    
    
    @FocusState private var descriptionFocused: Bool
    @FocusState private var option1Focused: Bool
    @FocusState private var option2Focused: Bool
    @FocusState private var option3Focused: Bool
    @FocusState private var option4Focused: Bool
    
    // Capture data for post
    @State private var selected_image:String = ""
    
    
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            // Bottom -> Reload the webpage and get images / title
            WebViewRepresentable(action: $action,
                                 state: $state,
                                 product_image_urls: $available_images,
                                 product_name: $page_title,
                                 initial_url: $initial_url,
                                 brand_favicon: $brand_favicon)
            
            // Cover the webview
            Color("Background")
            
            // Main page for editing
            VStack(alignment: .leading, spacing: 0) {
                 
                create_header
                
                create_url
                
                Text("Product Preview")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.vertical)
                    .padding(.leading)
                
                create_callout
                    .padding(.horizontal)
                                
                edit_thumbnail
                    .padding(.vertical)
                
//                if new_post.isSwornBy {
//                    swearby_callout
//                        .padding(.horizontal)
//                        .padding(.bottom)
//                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .interactiveDismissDisabled()
        .onAppear {
            self.initial_url = new_post.url.original
            
        }
        .onChange(of: available_images) { newValue in           // IMAGE_URL
            if !newValue.isEmpty {
                available_images = available_images.removingDuplicates()
                if let img = available_images.first {
                    selected_image = img
                    self.new_post.url.image_url = img
                }
            }
        }
        .onChange(of: page_title) { newValue in
            self.new_post.url.page_title = newValue
            
        }
        .onChange(of: state.isLoading) { newValue in
            if !newValue {
                setupBoilerplatePost(url_string: initial_url)
            }
        }
        .sheet(isPresented: $isShowingChangeThumbnail, content: {
            SelectThumbnail(new_post: $new_post, isShowingChangeThumbnail: $isShowingChangeThumbnail, list_of_images: $available_images)
        })
    }
    
    
    var create_header: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                wipeURLData()
                
                dismiss()
            } label: {
                
                Text("Discard")
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text("Add Product")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()

            Button {
                
                new_post.url.site_favicon = brand_favicon                   // favicon
                 
                dismiss()
                
            } label: {
                
                Text("Add")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(new_post.url.full.isEmpty ? .gray.opacity(0.5) : .blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .disabled(new_post.url.full.isEmpty)
        }
        .padding(.horizontal)
        .padding(.horizontal, 6)
        .padding(.top)
    }
    
    
    var create_url: some View {
        
        HStack(spacing: 0) {
            
            Text(new_post.url.original)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .lineLimit(2)
                .foregroundColor(Color("text.gray"))
                .padding(.vertical, 10)
                
            Spacer()
        }
        .padding(.all)
    }
    
    
    var create_callout: some View {
        
        HStack(alignment: .center, spacing: 0) {
        
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                     
                    if state.isLoading {
                        ProgressView()
                            .frame(width: 44, height: 44)
                    } else if !new_post.url.image_url.isEmpty {
                        WebImage(url: URL(string: new_post.url.image_url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 64, height: 64)
                            .foregroundColor(.gray.opacity(0.2))
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(state.isLoading ? "Loading..." : new_post.url.page_title)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .padding(.bottom, 2)
                        
                        Text(new_post.url.host)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(Color("text.gray"))
                            .lineLimit(1)
                        
                    }
                    .padding(.leading)
                }
                .padding(.all, 12)
            }
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.gray.opacity(0.08)))
            .padding(.trailing)

            Spacer()
        }
    }
    
    var edit_thumbnail: some View {
        
        Button {
            isShowingChangeThumbnail = true
        } label: {
            Text("Edit Thumbnail Image")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(state.isLoading ? .gray.opacity(0.2) : .gray)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Capsule().foregroundColor(.gray.opacity(0.1)))
        }
        .disabled(state.isLoading)
        .padding(.leading, 10)
    }
    
    func setupBoilerplatePost(url_string: String) {
        
        let b_host = convertURLToHostname(url: url_string)          // stocks.apple.com
        let b_path = convertURLToPathURL(url: url_string)           // stocks.apple.com/AAPL/010234
        let b_prefix = getURLPrefix(url: url_string)                // https://www.
        
        self.new_post.url.host = b_host
        self.new_post.url.path = b_path
        self.new_post.url.prefix = b_prefix
        self.new_post.url.full = b_prefix + b_path
        
        self.new_post.url.original = url_string
        self.new_post.url.type = "APP"
        
        //hasLoadedBoilerplatePost = true
    }
    
    func wipeURLData() {
        self.new_post.url.host = ""
        self.new_post.url.path = ""
        self.new_post.url.prefix = ""
        self.new_post.url.full = ""
        self.new_post.url.original = ""
        self.new_post.url.type = ""
        self.initial_url = ""
    }

}
