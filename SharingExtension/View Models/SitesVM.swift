//
//  SitesVM.swift
//  SwearBy
//
//  Created by Colin Power on 11/24/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//MARK: ViewModel ----------------------------------------------------------------------------------------------------------------
class SitesVM: ObservableObject, Identifiable {

    //MARK: Setup
    private var db = Firestore.firestore()

    //MARK: Published variables
    @Published var site = EmptyVariables().empty_site
    
    //MARK: Listeners

    //MARK: GET
    
    func getSiteByDomain(domain: String) {
        
        let docRef = db.collection("sites").document(domain)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.site = try document.data(as: Sites.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: Listen

    
    //MARK: Add
    func create(post: Posts2, user: Users2) {
        
        let ref = db.collection("new_posts")
        
        var new_post = post
       
        
        //MARK: MUST FIX THIS SO THAT YOU INCLUDE THE USER!!
        new_post.user = convertUser2ObjectToUser2Snippet(user: user)
        new_post.timestamp.created = getTimestamp()
        
        do {
            try ref.document(new_post._ID).setData(from: new_post)
            print("stored with new doc ref \(post._ID)")
        }
        catch {
            print(error)
        }
    }
    
//    // for people who click "COPY" or "OPEN" on your discount
//    func clicked(post: Posts2, user_id: String) {
//        
//        let docRef = Firestore.firestore().collection("new_posts").document(post._ID)
//        
//        let device_id = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        
//        let uid = !user_id.isEmpty ? user_id : !device_id.isEmpty ? device_id : ("unknown" + UUID().uuidString)
//        
//        docRef.updateData([
//            "referral.clicks": FieldValue.arrayUnion([(uid + "-SHARE")])     // Ensures uniqueness
//        ]) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Successfully updated document")
//            }
//        }
//    }
    
    
    
//    func like(post_id: String, user_id: String) {
//
//        db.collection("posts").document(post_id)
//            .updateData([
//                "likes": FieldValue.arrayUnion([user_id])
//            ]) { err in
//                if let err = err {
//                    print("Error updating likes: \(err)")
//                } else {
//                    print("LIKED")
//                }
//            }
//    }
    
    
//    func unlike(post_id: String, user_id: String) {
//
//        db.collection("posts").document(post_id)
//            .updateData([
//                "likes": FieldValue.arrayRemove([user_id])
//            ]) { err in
//                if let err = err {
//                    print("Error unliking: \(err)")
//                } else {
//                    print("UNLIKED")
//                }
//            }
//    }
    
    

}


//MARK: DataManager ----------------------------------------------------------------------------------------------------------------

//MARK: Model ----------------------------------------------------------------------------------------------------------------
