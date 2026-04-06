//
//  Users2.swift
//  SwearBy
//
//  Created by Colin Power on 2/3/25.
//

import Foundation
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


//MARK: ViewModel ----------------------------------------------------------------------------------------------------------------
class UsersVM2: ObservableObject, Identifiable {

    //MARK: Setup
    private var dm = UsersDM2()
    private var db = Firestore.firestore()

    //MARK: Published variables
    @Published var one_user1 = EmptyVariables().empty_user2
    @Published var one_user = EmptyVariables().empty_user2
    @Published var get_user_by_id = EmptyVariables().empty_user2
    @Published var all_users = [Users2]()
    @Published var get_fan_accounts = [Users2]()
    
    
    //MARK: Listeners
    var one_user_listener2: ListenerRegistration!

    //MARK: Listen
    func listenForOneUser(user_id: String) {

        self.dm.getOneUserListener(user_id: user_id, onSuccess: { (user) in

            self.one_user1 = user

        }, listener: { (listener) in
            self.one_user_listener2 = listener
        })
    }

    //MARK: Get
    func getActiveAccountUserByID(user_id: String) {
        
        let docRef = db.collection("new_users").document(user_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.one_user = try document.data(as: Users2.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getUserByID(user_id: String) {
        
        let docRef = db.collection("new_users").document(user_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.get_user_by_id = try document.data(as: Users2.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getAllUsers() {                        // NEED TO ADD A FIELD FOR DELETED ACCOUNTS
        
        db.collection("new_users")
            .order(by: "info.name")
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.all_users = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users2? in
    
                    print(try? queryDocumentSnapshot.data(as: Users2.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users2.self)
                })
            }
    }

    
    
    func getFanAccounts() {
        
        db.collection("new_users")
            .whereField("settings.isPublicAccount", isEqualTo: true)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.get_fan_accounts = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users2? in
                    print("AT THE TRY STATEMENT for get_fan_accounts")
                    print(try? queryDocumentSnapshot.data(as: Users2.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users2.self)
                })
            }
    }
    
    
    

    //MARK: Add
    
    
    //MARK: Update
    
    //MARK: Helpers

}


//MARK: DataManager ----------------------------------------------------------------------------------------------------------------
class UsersDM2: ObservableObject {

    private var db = Firestore.firestore()

    func getOneUserListener(user_id: String, onSuccess: @escaping(Users2) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
    
        let listenerRegistration = db.collection("new_users").document(user_id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
    
                var empty_user = EmptyVariables().empty_user2
    
                do {
                    print("GOT HERE IN THE getOneUserListener")
    
                    if document.exists {
    
                        print(document.data())

//                        if user_id == "xctA4e4hQ3auh5oOZbeG6JbDAw63" {
//
//                        } else {
                            empty_user = try! document.data(as: Users2.self)
//                        }
                    } else {
                        empty_user.user_id = user_id
                        empty_user.info.phone = "NO USER FOUND"
                    }
                }
                catch {
                    print(error)
                    return
                }
                onSuccess(empty_user)
            }
        listener(listenerRegistration) //escaping listener
    }
    
    
    
    

}

//MARK: Model ----------------------------------------------------------------------------------------------------------------
struct Users2: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? // = UUID().uuidString
    var followers: Struct_User_Followers
    var following: Struct_User_Following
    var info: Struct_User_Info
    var settings: Struct_User_Settings
    var socials: Struct_User_Socials
    var user_id: String
                                                    // MARK: MISSING -> Reddit, Discord,
    enum CodingKeys: String, CodingKey {
        case id
        case followers
        case following
        case info
        case settings
        case socials
        case user_id
    }
}


struct Struct_User_Info: Codable, Hashable {

    var bio: String                 // "a little about me ... "
    var email: String               
    var name: String                // "Colin Power"
    var phone: String
    var pic: String                 // either User_ID (in Storage), URL (load url), or "" (load from social handles)

    enum CodingKeys: String, CodingKey {
        case bio
        case email
        case name
        case phone
        case pic
    }
}

struct Struct_User_Settings: Codable, Hashable {

    var device_token: String        // for notifications
    var isPublicAccount: Bool       // TRUE if it's an account where anyone can add info
    var timestamp: Int              // timestamp created

    enum CodingKeys: String, CodingKey {
        case device_token
        case isPublicAccount
        case timestamp
    }
}


struct Struct_User_Socials: Codable, Hashable {

    var instagram: String
    var ltk: String
    var shopmy: String
    var tiktok: String
    var x: String
    var youtube: String

    enum CodingKeys: String, CodingKey {
        case instagram
        case ltk
        case shopmy
        case tiktok
        case x
        case youtube
    }
}

struct Struct_User_Followers: Codable, Hashable {

    var follow_requests: [String]
    var list: [String]
    var manually_accept_followers: Bool

    enum CodingKeys: String, CodingKey {
        case follow_requests
        case list
        case manually_accept_followers
    }
}


struct Struct_User_Following: Codable, Hashable {

    var list: [String]
    var you_sent_follow_request: [String]

    enum CodingKeys: String, CodingKey {
        case list
        case you_sent_follow_request
    }
}
