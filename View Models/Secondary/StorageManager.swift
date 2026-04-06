//
//  GetImages.swift
//  SwearBy
//
//  Created by Colin Power on 3/24/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

public class StorageManager: ObservableObject {
    
    let storageRef = Storage.storage().reference()
    
    @Published var post_url: String = ""
    @Published var user_url: String = ""
    @Published var group_url: String = ""
    @Published var request_url: String = ""
    @Published var photo_url: String = ""
    
    
    func getPost(image_url: String) {

        let path = "post/" + image_url + ".png"
        
        storageRef.child(path).downloadURL { url, err in
            if err != nil {
                print(err?.localizedDescription ?? "Issue showing the right image")
                return
            } else {
                self.post_url = "\(url!)"
            }
        }
    }
    
    func getUser(user_id: String) {

        let path = "user/" + user_id + ".png"
        
        storageRef.child(path).downloadURL { url, err in
            if err != nil {
                print(err?.localizedDescription ?? "Issue showing the right image")
                return
            } else {
                self.user_url = "\(url!)"
            }
        }
    }
     
    
    func getPhoto(post_id: String) {

        let path = "photos/" + post_id + ".png"
        
        storageRef.child(path).downloadURL { url, err in
            if err != nil {
                print(err?.localizedDescription ?? "Issue showing the right image")
                return
            } else {
                self.photo_url = "\(url!)"
            }
        }
    }
}









