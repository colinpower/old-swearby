//
//  LoadedAppVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/5/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class LoadedAppVM: ObservableObject, Identifiable {
    
    // Created from this conversation with ChatGPT
    // https://chatgpt.com/share/67a30692-2d14-8006-a0e3-6e538481eced
    
    
    //MARK: Setup
    private var db = Firestore.firestore()
    
    //MARK: Published variables
    //MARK: Listeners
    //MARK: Listen
    
    
    //MARK: Get
    
    
    
    
    
    
    //MARK: Add
    func log(user_id: String, type: String) {
        
        let device_id = UIDevice.current.identifierForVendor?.uuidString
        
        var new_logging = LoadedApp(user_id: "", device_id: "", type: "", timestamp: 0)
        
        new_logging.device_id = device_id ?? ""
        new_logging.user_id = user_id
        new_logging.type = type
        new_logging.timestamp = getTimestamp()
        
        let log_id = UUID().uuidString
        
        let ref = db.collection("loaded_app").document(log_id)
        
        do {
            try ref.setData(from: new_logging)
            print("stored with new doc ref \(log_id)")
        }
        catch {
            print(error)
        }
    }
}


//MARK: Model ----------------------------------------------------------------------------------------------------------------
struct LoadedApp: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var user_id: String                                     // if available
    var device_id: String                                   // unique for a user
    var type: String                                        // e.g. "initial-load"
    var timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case device_id
        case type
        case timestamp
    }
}
