//
//  DeleteSharedContentVM.swift
//  SwearBy
//
//  Created by Colin Power on 6/20/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class DeleteSharedContentVM: ObservableObject, Identifiable {
    
    private var db = Firestore.firestore()
    
    
    // FOR POSTS, REQUESTS, CODES
    func markDeleted(firebase_collection_name: String, firebase_doc_id: String) {
        
        db.collection(firebase_collection_name).document(firebase_doc_id)
            .updateData([
                "timestamp.deleted": getTimestamp()
            ]) { err in
                if let err = err {
                    print("Deleted or error: \(err)")
                } else {
                    print("DELETED or error")
                }
            }
    }
    
    // FOR MESSAGES AND COMMENTS
    func markArchived(firebase_collection_name: String, firebase_doc_id: String) {
        
        db.collection(firebase_collection_name).document(firebase_doc_id)
            .updateData([
                "timestamp.archived": getTimestamp()
            ]) { err in
                if let err = err {
                    print("Deleted or error: \(err)")
                } else {
                    print("DELETED or error")
                }
            }
    }
    
}
