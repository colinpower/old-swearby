//
//  SelectThumbnail.swift
//  SwearBy
//
//  Created by Colin Power on 1/20/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct SelectThumbnail: View {
    
    @Binding var new_post: NewPosts
    @Binding var isShowingChangeThumbnail: Bool
    @Binding var list_of_images: [String]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            create_header
                .padding(.bottom)
            
            images
            
        }
    }
    
    var create_header: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                isShowingChangeThumbnail = false
            } label: {
                
                Text("Cancel")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Thumbnail")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("Cancel")
                .font(.system(size: 19, weight: .regular, design: .rounded))
                .foregroundColor(.clear)

        }
        .padding(.horizontal)
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .padding(.top)

    }
    
    var images: some View {
        
        ScrollView(showsIndicators: false) {
            VStack (alignment: .center, spacing: 0) {
                let columns = Array(repeating: GridItem(spacing: 10), count: 3)
                let w = (UIScreen.main.bounds.width - 50) / 3
                
                LazyVGrid(columns: columns, spacing: 10, content: {
                    
                    ForEach(Array(list_of_images.enumerated()), id: \.offset) { offset, im in
                        
                        Button {
                            new_post.url.image_url = im
                            isShowingChangeThumbnail = false
                        } label: {
                            WebImage(url: URL(string: im)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: w, height: w)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                    }
                })
                .padding(.horizontal, 5)
            }
            
            Spacer()
            
        }
        
    }
    
    
}






