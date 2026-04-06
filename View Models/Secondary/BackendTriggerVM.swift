//
//  BackendTriggerVM.swift
//  SwearBy
//
//  Created by Colin Power on 6/23/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class BackendTriggerVM: ObservableObject, Identifiable {
    
    private var db = Firestore.firestore()
    
    // add friend to posts & create DM group
    func addedFollower(user1: String, user2: String) {
            
        db.collection("backend_trigger").document()
            .setData([
                "type": "ADD_FOLLOWER",
                "group_id": "",
                "user1": user1,
                "user2": user2,
                "timestamp": getTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("IDK ERROR WHEN SUBMITTING ADD FRIEND??")
                }
            }
    }
    
    // delete account
    func deleteAccount(user1: String) {
            
        db.collection("backend_trigger").document()
            .setData([
                "type": "DELETE_ACCOUNT",
                "group_id": "",
                "user1": user1,
                "user2": "",
                "timestamp": getTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("IDK ERROR WHEN SUBMITTING ADD FRIEND??")
                }
            }
            
    }
}
