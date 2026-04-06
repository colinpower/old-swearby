//
//  UserVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//MARK: ViewModel ----------------------------------------------------------------------------------------------------------------
class UsersVM: ObservableObject, Identifiable {

    //MARK: Setup
    private var dm = UsersDM()
    private var db = Firestore.firestore()

    //MARK: Published variables
    @Published var one_user = EmptyVariables().empty_user
    @Published var get_user_by_id = EmptyVariables().empty_user
    @Published var all_users = [Users]()
    @Published var get_users_by_phone_number = [Users]()
    @Published var get_users_by_email = [Users]()
    @Published var get_fan_accounts = [Users]()
    
    
    //MARK: Listeners
    var one_user_listener: ListenerRegistration!

    //MARK: Listen
    func listenForOneUser(user_id: String) {

        self.dm.getOneUserListener(user_id: user_id, onSuccess: { (user) in

            self.one_user = user

        }, listener: { (listener) in
            self.one_user_listener = listener
        })
    }

    //MARK: Get
    func getUserByID(user_id: String) {
        
        let docRef = db.collection("new_users").document(user_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.get_user_by_id = try document.data(as: Users.self)
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
    
                self.all_users = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users? in
    
                    print(try? queryDocumentSnapshot.data(as: Users.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users.self)
                })
            }
    }
    
    func getUserByPhoneNumber(number: String) {
        
        db.collection("new_users")
            .whereField("info.phone", isEqualTo: number)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.get_users_by_phone_number = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users? in
                    print("AT THE TRY STATEMENT for getMyReferrals")
                    print(try? queryDocumentSnapshot.data(as: Users.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users.self)
                })
            }
        
        
    }
    
    func getUsersByEmail(email: String) {
        
        db.collection("new_users")
            .whereField("info.email", isEqualTo: email)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.get_users_by_email = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users? in
                    print("AT THE TRY STATEMENT for get_users_by_email")
                    print(try? queryDocumentSnapshot.data(as: Users.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users.self)
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
    
                self.get_fan_accounts = snapshot.documents.compactMap({ queryDocumentSnapshot -> Users? in
                    print("AT THE TRY STATEMENT for get_fan_accounts")
                    print(try? queryDocumentSnapshot.data(as: Users.self) as Any)
                    return try? queryDocumentSnapshot.data(as: Users.self)
                })
            }
    }
    
    
    

    //MARK: Add
    
    
    //MARK: Update
    func updateUserAccount(user_id: String, name: String, ltk: String, instagram: String, tiktok: String, bio: String) {

        if user_id.isEmpty { return } else {

            db.collection("new_users").document(user_id)
                .updateData([
                    "socials.ltk": ltk,
                    "socials.instagram": instagram,
                    "socials.tiktok": tiktok,
                    "info.name": name,
                    "info.bio": bio
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
        }
    }
    
    
    
    
    func updateName(user_id: String, name: String) {

        if user_id.isEmpty { return } else {

            db.collection("new_users").document(user_id)
                .updateData([
                    "info.name": name
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
        }
    }
    
    func sendFollowRequest(my_user_object: Users, my_friends_user_object: Users) {
         
        // Don't send friend request if it's the same user
        if my_user_object.user_id == my_friends_user_object.user_id {
            return
        } else {
            
            // Add me to their "friend requests" list
            var followers_current_requests:[String] = my_friends_user_object.followers.follow_requests
            followers_current_requests.append(my_user_object.user_id)
            
            db.collection("new_users").document(my_friends_user_object.user_id)
                .updateData([
                    "followers.follow_requests": followers_current_requests
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Add them to my "following requested" list
            var requested_to_follow:[String] = my_user_object.following.you_sent_follow_request
            requested_to_follow.append(my_friends_user_object.user_id)
            
            db.collection("new_users").document(my_user_object.user_id)
                .updateData([
                    "following.you_sent_follow_request": requested_to_follow
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Send a notification
            //NotificationsVM().addFollowRequest(from_user: my_user_object, to_user: my_friends_user_object.user_id)
            
        }
    }
    
    
    func sendFollowRequestAndAutoFollow(my_user_object: Users, my_friends_user_object: Users) {
        
        // Don't send friend request if it's the same user
        if my_user_object.user_id == my_friends_user_object.user_id {
            return
        } else {
            
            // Add me to their "followers" list
            var followers_current_list:[String] = my_friends_user_object.followers.list
            followers_current_list.append(my_user_object.user_id)
            
            db.collection("new_users").document(my_friends_user_object.user_id)
                .updateData([
                    "followers.list": followers_current_list
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Add them to my "following" list
            var my_accounts_following:[String] = my_user_object.following.list
            my_accounts_following.append(my_friends_user_object.user_id)
            
            db.collection("new_users").document(my_user_object.user_id)
                .updateData([
                    "following.list": my_accounts_following
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Add them to all my FOLLOWERS posts
            BackendTriggerVM().addedFollower(user1: my_friends_user_object.user_id, user2: my_user_object.user_id)
            
            // Send a notification
            //            NotificationsVM().newFollower(from_user: my_user_object, to_user: my_friends_user_object.user_id)
            //
        }
    }
    
    
    func undoFollowRequest(my_user_object: Users, my_friends_user_object: Users) {
         
        // Don't send friend request if it's the same user
        if my_user_object.user_id == my_friends_user_object.user_id {
            return
        } else {
            
            // Remove me from their "friend requests" list
            var followers_current_requests = my_friends_user_object.followers.follow_requests
            if let index = followers_current_requests.firstIndex(where: {$0 == my_user_object.user_id}) {
                followers_current_requests.remove(at: index)
            }
            
            db.collection("new_users").document(my_friends_user_object.user_id)
                .updateData([
                    "followers.follow_requests": followers_current_requests
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Remove them from my "friends added" list
            var requested_to_follow = my_user_object.following.you_sent_follow_request
            if let index = requested_to_follow.firstIndex(where: {$0 == my_friends_user_object.user_id}) {
                requested_to_follow.remove(at: index)
            }
            
            db.collection("new_users").document(my_user_object.user_id)
                .updateData([
                    "following.you_sent_follow_request": requested_to_follow
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
        }
    }
    
    func unfollow(my_user_object: Users, my_friends_user_object: Users) {
         
        // Don't send friend request if it's the same user
        if my_user_object.user_id == my_friends_user_object.user_id {
            return
        } else {
            
            // Remove me from their "followers" list
            var followers_current = my_friends_user_object.followers.list
            if let index = followers_current.firstIndex(where: {$0 == my_user_object.user_id}) {
                followers_current.remove(at: index)
            }
            
            db.collection("new_users").document(my_friends_user_object.user_id)
                .updateData([
                    "followers.list": followers_current
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Remove them from my "following" list
            var following_list = my_user_object.following.list
            if let index = following_list.firstIndex(where: {$0 == my_friends_user_object.user_id}) {
                following_list.remove(at: index)
            }
            
            db.collection("new_users").document(my_user_object.user_id)
                .updateData([
                    "following.list": following_list
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
        }
    }
    
    func acceptFollowRequest(my_user_object: Users, my_friends_user_object: Users) {
        
        // Don't send friend request if it's the same user
        if my_user_object.user_id == my_friends_user_object.user_id {
            return
        } else {
            
            // Add me to their list
            var their_following_list = my_friends_user_object.following.list
            their_following_list.append(my_user_object.user_id)
            
            // Remove me from their "added friends" list
            var their_following_requests = my_friends_user_object.following.you_sent_follow_request
            if let index = their_following_requests.firstIndex(where: {$0 == my_user_object.user_id}) {
                their_following_requests.remove(at: index)
            }
            
            // Update their account
            db.collection("new_users").document(my_friends_user_object.user_id)
                .updateData([
                    "following.list": their_following_list,
                    "following.you_sent_follow_request": their_following_requests
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Add them to my list
            var my_followers_list = my_user_object.followers.list
            my_followers_list.append(my_friends_user_object.user_id)
            
            // Remove them from my "friend requests" list
            var my_follower_requests = my_user_object.followers.follow_requests
            if let index = my_follower_requests.firstIndex(where: {$0 == my_friends_user_object.user_id}) {
                my_follower_requests.remove(at: index)
            }
            
            // Update my account
            db.collection("new_users").document(my_user_object.user_id)
                .updateData([
                    "followers.list": my_followers_list,
                    "followers.follow_requests": my_follower_requests
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Add them to all my FOLLOWERS posts
            BackendTriggerVM().addedFollower(user1: my_user_object.user_id, user2: my_friends_user_object.user_id)
            
            // Send notification
//            NotificationsVM().acceptedFollowRequest(from_user: my_user_object, to_user: my_friends_user_object.user_id)
        }
    }
    
    
    func removeFollower(my_user_object: Users, my_friends_user_object: Users) {
         
        // Don't send friend request if it's the same user
        if my_user_object.user_id == my_friends_user_object.user_id {
            return
        } else {
            
            // Remove me from their "following" list
            var their_following_list = my_friends_user_object.following.list
            if let index = their_following_list.firstIndex(where: {$0 == my_user_object.user_id}) {
                their_following_list.remove(at: index)
            }
            
            db.collection("new_users").document(my_friends_user_object.user_id)
                .updateData([
                    "following.list": their_following_list
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Remove them from my "following me" list
            var my_followers_list = my_user_object.followers.list
            if let index = my_followers_list.firstIndex(where: {$0 == my_friends_user_object.user_id}) {
                my_followers_list.remove(at: index)
            }
            
            db.collection("new_users").document(my_user_object.user_id)
                .updateData([
                    "followers.list": my_followers_list
                ]) { err in
                    if let err = err {
                        print("Error updating document submitting names for User object: \(err)")
                    } else {
                        print("Updated the first and last names")
                    }
                }
            
            // Remove me from all their public posts
//            BackendTriggerVM().unfriend(user1: my_user_object.user_id, user2: my_friends_user_object.user_id)
        }
    }


    
    
    func updateDeviceToken(user_id: String, token: String) {

        if user_id.isEmpty { return } else {

            db.collection("new_users").document(user_id)
                .updateData([
                    "device_token": token
                ]) { err in
                    if let err = err {
                        print("Error updating document for device token for User object: \(err)")
                    } else {
                        print("Updated the device token")
                    }
                }
        }
    }
    
    func updateLastNotificationSeen(user_id: String) {

        if user_id.isEmpty { return } else {

            db.collection("new_users").document(user_id)
                .updateData([
                    "lastNotificationSeen": getTimestamp()
                ]) { err in
                    if let err = err {
                        print("Error updating document for device token for User object: \(err)")
                    } else {
                        print("Updated the last seen notification")
                    }
                }
        }
    }
    
    func updateAcceptFollowersManually(user_id: String, new_setting_state: Bool) {

        if user_id.isEmpty { return } else {

            db.collection("new_users").document(user_id)
                .updateData([
                    "followers.manually_accept_followers": new_setting_state
                ]) { err in
                    if let err = err {
                        print("Error updating document for manually_accept_followers for User object: \(err)")
                    } else {
                        print("Updated the manually_accept_followers")
                    }
                }
        }
    }
    
    func createDemoUser(new_user_object: Users) {              // Must have name.first name.last name.first_last twitter instagram tiktok

        let ref = db.collection("new_users")
        var new_user = new_user_object
        
        new_user.followers.manually_accept_followers = false
        new_user.settings.isPublicAccount = true
        new_user.settings.timestamp = getTimestamp()

        do {
            try ref.document(new_user.user_id).setData(from: new_user)
            print("stored with new doc ref \(new_user.user_id)")
        }
        catch {
            print(error)
        }
    }

    
    
    //MARK: Helpers

}


//MARK: DataManager ----------------------------------------------------------------------------------------------------------------
class UsersDM: ObservableObject {

    private var db = Firestore.firestore()

    func getOneUserListener(user_id: String, onSuccess: @escaping(Users) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
    
        let listenerRegistration = db.collection("new_users").document(user_id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
    
                var empty_user = EmptyVariables().empty_user
    
                do {
                    print("GOT HERE IN THE getOneUserListener")
    
                    if document.exists {
    
                        print(document.data())

//                        if user_id == "xctA4e4hQ3auh5oOZbeG6JbDAw63" {
//
//                        } else {
                            empty_user = try! document.data(as: Users.self)
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
struct Users: Identifiable, Codable, Hashable {
    
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

//struct Users: Identifiable, Codable, Hashable {
//
//    @DocumentID var id: String? // = UUID().uuidString
//    var device_token: String
//    var email: String
//    var email_verified: Bool
//    var followers: Struct_Profile_Followers
//    var following: Struct_Profile_Following
//    var friend_requests: [String]
//    var friends_added: [String]
//    var friends_invited: [String]
//    var friends_list: [String]
//    var instagram: String
//    var isDemoAccount: Bool
//    var lastNotificationSeen: Int
//    var name: Struct_Profile_Name
//    var phone: String
//    var phone_verified: Bool
//    var tiktok: String
//    var timestamp: Int
//    var twitter: String
//    var user_id: String
//    
//    // PROPOSED
////    @DocumentID var id: String? // = UUID().uuidString
////    var device_token: String
////    var email: String
////    var email_verified: Bool
////    var followers: Struct_Profile_Followers
////    var following: Struct_Profile_Following
////    var isDemoAccount: Bool
////    var name: Struct_Profile_Name
////    var socials:
//    //      instagram
//    //      ltk
//    //      tiktok
//    //      youtube
//    //      twitter
//    //      link_in_bio
//    //      blog
////    var timestamp: Int
////    var user_id: String
//    
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case device_token
//        case email
//        case email_verified
//        case followers
//        case following
//        case friend_requests
//        case friends_added
//        case friends_invited
//        case friends_list
//        case instagram
//        case isDemoAccount
//        case lastNotificationSeen
//        case name
//        case phone
//        case phone_verified
//        case tiktok
//        case timestamp
//        case twitter
//        case user_id
//    }
//}
//
//struct Struct_Profile_Name: Codable, Hashable {
//
//    var first: String
//    var last: String
//    var first_last: String
//
//    enum CodingKeys: String, CodingKey {
//        case first
//        case last
//        case first_last
//    }
//}
//
//struct Struct_Profile_Followers: Codable, Hashable {
//
//    var follow_requests: [String]
//    var list: [String]
//    var manually_accept_followers: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case follow_requests
//        case list
//        case manually_accept_followers
//    }
//}
//
//
//struct Struct_Profile_Following: Codable, Hashable {
//
//    var list: [String]
//    var you_sent_follow_request: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case list
//        case you_sent_follow_request
//    }
//}
//
//
//
