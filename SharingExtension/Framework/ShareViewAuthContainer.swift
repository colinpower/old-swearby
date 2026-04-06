//
//  ShareViewAuthContainer.swift
//  SharingExtension
//
//  Created by Colin Power on 4/11/23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseAuth


struct ShareViewAuthContainer: View {
    
    @State var shareViewObject: ShareObject
    var user_id: String
    
    // For getting data from firebase
    @State private var hasLoadedUser:Bool = false
    @State private var hasLoadedFirebase:Bool = false
    @State var uid:String = ""
    
    @State var detent: PresentationDetent = PresentationDetent.large
    
    
    var body: some View {
        
        Group {
            
            if hasLoadedFirebase {
                Home(shareViewObject: shareViewObject, user_id: user_id, uid: uid, detent: $detent)
                
            } else {
                EmptyView()  // Color.clear
            }
        }
        .interactiveDismissDisabled()
//        .sheet(isPresented: $hasLoadedFirebase) {
//            Home(shareViewObject: shareViewObject, user_id: user_id, uid: uid, detent: $detent)
//                .presentationDetents([.medium, .large], selection: $detent)
//                .presentationBackground(.clear)
//        }
        .onAppear {
            
            FirebaseApp.configure()
         
            self.hasLoadedFirebase = true
            
        }
    }
}
