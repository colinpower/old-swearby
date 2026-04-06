//
//  NewPostsVM.swift
//  SwearBy
//
//  Created by Colin Power on 1/5/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//MARK: ViewModel ----------------------------------------------------------------------------------------------------------------
class NewPostsVM: ObservableObject, Identifiable {

    //MARK: Setup
    private var dm = NewPostsDM()
    private var db = Firestore.firestore()

    //MARK: Published variables
    
    @Published var latest_posts = [NewPosts]()
    @Published var latest_25_public_posts = [NewPosts]()
    @Published var all_my_posts = [NewPosts]()
    @Published var all_friend_posts = [NewPosts]()
    
    @Published var public_account_posts = [NewPosts]()
    
    

    //MARK: Listener
    var latest_posts_listener: ListenerRegistration!
    
    //MARK: Listen
    func listenForLatestPosts(user_id: String, following: [String]) {
    
        self.dm.getLatestPostsListener(user_id: user_id, following: following, onSuccess: { (posts) in

            self.latest_posts = posts

        }, listener: { (listener) in
            self.latest_posts_listener = listener
        })
    }

    
    //MARK: Get
    func getLatest25PublicPosts() {
        
        db.collection("new_posts")
            .whereField("isPublicPost", isEqualTo: true)
            .whereField("timestamp.deleted", isEqualTo: 0)
            .order(by: "timestamp.created", descending: true)
            .limit(to: 25)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
    
                self.latest_25_public_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> NewPosts? in
                    return try? queryDocumentSnapshot.data(as: NewPosts.self)
                })
            }
    }
    
    
    func getMyPosts(user_id: String) {
        
        if user_id.isEmpty {
            
        } else {
            db.collection("new_posts")
                .whereField("user._ID", isEqualTo: user_id)
                .whereField("timestamp.deleted", isEqualTo: 0)
                .order(by: "timestamp.created", descending: true)
                .limit(to: 50)
                .getDocuments { (snapshot, error) in
                    
                    guard let snapshot = snapshot, error == nil else {
                        //handle error
                        print("found error")
                        return
                    }
                    print("Number of documents: \(snapshot.documents.count)")
                    
                    self.all_my_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> NewPosts? in
                        return try? queryDocumentSnapshot.data(as: NewPosts.self)
                    })
                }
        }
    }
    
    func getFriendPosts(friend_user_id: String) {
        
        if friend_user_id.isEmpty {
            
        } else {
            db.collection("new_posts")
                .whereField("user._ID", isEqualTo: friend_user_id)
                .whereField("timestamp.deleted", isEqualTo: 0)
                .order(by: "timestamp.created", descending: true)
                .getDocuments { (snapshot, error) in
                    
                    guard let snapshot = snapshot, error == nil else {
                        //handle error
                        print("found error")
                        return
                    }
                    print("Number of documents: \(snapshot.documents.count)")
                    
                    self.all_friend_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> NewPosts? in
                        return try? queryDocumentSnapshot.data(as: NewPosts.self)
                    })
                }
        }
    }
    
    
    func trackTotalPublicAccountPosts() {
        
        db.collection("new_posts")
            .whereField("isPublicPost", isEqualTo: true)
            .whereField("user.isPublicAccount", isEqualTo: true)
            .whereField("timestamp.deleted", isEqualTo: 0)
            .getDocuments { (snapshot, error) in
    
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
    
                
                self.public_account_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> NewPosts? in
                    return try? queryDocumentSnapshot.data(as: NewPosts.self)
                })
            }
    }
    
    
    
    
    
    //MARK: Add
    
    func create(new_post: NewPosts, user: Users) {
        
        let ref = db.collection("new_posts")
        
        var new_post1 = new_post
        new_post1.user = convertUser2ObjectToUser2Snippet(user: user)
        new_post1.timestamp.created = getTimestamp()
        
        do {
            try ref.document(new_post1._ID).setData(from: new_post1)
            print("stored with new doc ref \(new_post._ID)")
        }
        catch {
            print(error)
        }
    }
    
    
    
//    func like(new_post_id: String, user_id: String) {
//
//        db.collection("posts").document(new_post_id)
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
    
    func delete(new_post_id: String) {

        db.collection("new_posts").document(new_post_id)
            .updateData([
                "timestamp.deleted": getTimestamp()
            ]) { err in
                if let err = err {
                    print("Error updating delete: \(err)")
                } else {
                    print("DELETED")
                }
            }
    }
//    
//    func unlike(new_post_id: String, user_id: String) {
//
//        db.collection("posts").document(new_post_id)
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
class NewPostsDM: ObservableObject {
    
    private var db = Firestore.firestore()
    
    func getLatestPostsListener(user_id: String, following: [String], onSuccess: @escaping([NewPosts]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("new_posts")
            .whereField("timestamp.deleted", isEqualTo: 0)
            .order(by: "timestamp.created", descending: true)
            .limit(to: 100)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var postsArray = [NewPosts]()
                
                postsArray = documents.compactMap { (queryDocumentSnapshot) -> NewPosts? in
                    
                    print(try? queryDocumentSnapshot.data(as: NewPosts.self))
                    return try? queryDocumentSnapshot.data(as: NewPosts.self)
                }
                
                //onSuccess(postsArray)
                
                // Filter the results to just PUBLIC posts and posts shared with this user
                if user_id.isEmpty {
                    
                    // User not signed in. Just filter to public posts
                    onSuccess(postsArray.filter( { $0.isPublicPost == true } ))
                    
                } else if following.isEmpty {
                    
                    // User signed in but isn't following anyone. Just filter to PUBLIC or posts created by user
                    onSuccess(postsArray.filter( { $0.isPublicPost == true || (user_id == $0.user._ID) } ))
                } else {
                    
                    // User signed in and is following people. Filter to Public, created by user, or following
                    onSuccess(postsArray.filter( { $0.isPublicPost == true || (user_id == $0.user._ID) || following.contains($0.user._ID) } ))
                }
            }
        listener(listenerRegistration)
    }
    

}

//MARK: Model ----------------------------------------------------------------------------------------------------------------
struct NewPosts: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var _ID: String                                         // set on CREATE page
    var created_by_civilian: String                         // if a user created this post on behalf of an influencer
    var likes: [String]                                     //
    var photo: String                                       // set on CREATE page
    var referral: Struct_Posts_Referral                     // set on CREATE page
    var isPublicPost: Bool
    var text: String                                        // set on CREATE page
    var timestamp: Struct_Posts_Timestamps                  // set on CREATE page
    var url: Struct_Posts_URL                               // set on BOILERPLATE page
    var user: Struct_Posts_User                             // set within the CREATE function
    
    enum CodingKeys: String, CodingKey {
        case id
        case _ID
        case created_by_civilian
        case likes
        case photo
        case referral
        case isPublicPost
        case text
        case timestamp
        case url
        case user
    }
}

struct Struct_Posts_URL: Codable, Hashable {

    var host: String           // bonobos.com
    var path: String           // bonobos.com/shirts/001
    var prefix: String         // https:// OR https://www.
    var full: String           // https://www.bonobos.com/shirts/001
    var original: String       // https://www.bonobos.com/shirts/001?value=abc123
    var image_url: String      // (this would be any image_url that the user has chosen when uploading)
    var type: String           // SHARE_SHEET_BROWSER or SHARE_SHEET_URL or SHARE_SHEET_TEXT or SWEARBY_APP
    var page_title: String     // The ABC Pants
    var site_title: String     // Bonobos (find in the list of brands)
    var site_favicon: String   // https://www.bonobos.com/svg=12345
    var site_id: String        // BONOBOS_UUID

    enum CodingKeys: String, CodingKey {
        case host
        case path
        case prefix
        case full
        case original
        case image_url
        case type
        case page_title                 // set on CREATE
        case site_title                 // set on CREATE
        case site_favicon               // set on CREATE
        case site_id                    // set on CREATE
    }
}

struct Struct_Posts_Referral: Codable, Hashable {
    
    var clicks: [String]                // [array of UUIDs who have clicked "copy" or "open" on the link]
    var code: String                    // COLIN123
    var link: String                    // https://reward.me/bonobos?id=COLIN123
    var expiration: Int                 // Timestamp when it expires
    var for_new_customers_only: Bool    // TRUE/FALSE if the discount applies only to new customers
    var for_this_page_only: Bool        // TRUE/FALSE if the discount applies only to this page
    var minimum_spend: String           // "100"
    var offer_value: String             // "15", ""
    var offer_type: String              // $, %, OTHER, NONE
    
    enum CodingKeys: String, CodingKey {
        case clicks
        case code
        case expiration
        case for_new_customers_only
        case for_this_page_only
        case link
        case minimum_spend
        case offer_value
        case offer_type
    }
}

struct Struct_Posts_User: Codable, Hashable {

    var _ID: String
    var name: String
    var pic: String
    var socials: Struct_User_Socials
    var isPublicAccount: Bool

    enum CodingKeys: String, CodingKey {
        case _ID
        case name
        case pic
        case socials
        case isPublicAccount
    }
}


struct Struct_Posts_Timestamps: Codable, Hashable {

    var archived: Int
    var created: Int
    var deleted: Int
    var expired: Int
    var updated: Int

    enum CodingKeys: String, CodingKey {
        case archived
        case created
        case deleted
        case expired
        case updated
    }
}



//struct NewPosts: Identifiable, Codable, Hashable {
//
//    @DocumentID var id: String?
//    var _ID: String                                         // set on CREATE page
//    var _STATUS: String                                     //
//    var access: Access                                      // set on CREATE page
//    var image_url: String                                   // set on CREATE page
//    var isSwornBy: Bool                                     // set on CREATE page
//    var likes: [String]                                     //
//    var override_url: String                                // set on CREATE page (if influencer wants to use a custom link)
//    var photos: [String]                                    // set on CREATE page
//    var poll: Poll_Struct                                   // set on CREATE page
//    var referral: Referral_Struct                           // set on CREATE page
//    var replies: [String]                                   //
//    var title: String                                       //
//    var text: String                                        // set on CREATE page
//    var timestamp: NewTimestamps                            // set on CREATE page
//    var url: Url_Struct                                     // set on BOILERPLATE page
//    var user: User_Snippet                                  // set within the CREATE function
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case _ID
//        case _STATUS
//        case access
//        case image_url
//        case isSwornBy
//        case likes
//        case override_url
//        case photos
//        case poll
//        case referral
//        case replies
//        case title
//        case text
//        case timestamp
//        case url
//        case user
//    }
//}
//
//struct Url_Struct: Codable, Hashable {
//
//    var host: String           // bonobos.com
//    var path: String           // bonobos.com/shirts/001
//    var prefix: String         // https:// OR https://www.
//    var full: String           // https://www.bonobos.com/shirts/001
//    var original: String       // https://www.bonobos.com/shirts/001?value=abc123
//    var type: String           // SHARE_SHEET_BROWSER or SHARE_SHEET_URL or SHARE_SHEET_TEXT or SWEARBY_APP
//    var page_title: String     // The ABC Pants
//    var site_title: String     // Bonobos (find in the list of brands)
//    var site_favicon: String   // https://www.bonobos.com/svg=12345
//    var site_id: String        // BONOBOS_UUID
//
//    enum CodingKeys: String, CodingKey {
//        case host
//        case path
//        case prefix
//        case full
//        case original
//        case type
//        case page_title                 // set on CREATE
//        case site_title                 // set on CREATE
//        case site_favicon               // set on CREATE
//        case site_id                    // set on CREATE
//    }
//}
//
//struct Referral_Struct: Codable, Hashable {
//    
//    var code: String                    // COLIN123
//    var link: String                    // https://reward.me/bonobos?id=COLIN123
//    var commission_value: String        // 15
//    var commission_type: String         // $, %, OTHER
//    var offer_value: String
//    var offer_type: String
//    var for_new_customers_only: Bool
//    var minimum_spend: String           //
//    var expiration: Int                 // Timestamp when it expires
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case code
//        case link
//        case commission_value
//        case commission_type
//        case offer_value
//        case offer_type
//        case for_new_customers_only
//        case minimum_spend
//        case expiration
//        
//    }
//}
//
//
//struct Poll_Struct: Codable, Hashable {
//    
//    var prompt: String                    // What should I do?
//    var text1: String
//    var text2: String
//    var text3: String
//    var text4: String
//    var votes1: [String]
//    var votes2: [String]
//    var votes3: [String]
//    var votes4: [String]
//    var expiration: Int
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case prompt
//        case text1
//        case text2
//        case text3
//        case text4
//        case votes1
//        case votes2
//        case votes3
//        case votes4
//        case expiration
//    }
//}
//
//
//struct NewTimestamps: Codable, Hashable {
//
//    var archived: Int
//    var created: Int
//    var deleted: Int
//    var expired: Int
//    var updated: Int
//
//    enum CodingKeys: String, CodingKey {
//        case archived
//        case created
//        case deleted
//        case expired
//        case updated
//    }
//}
//
//struct User_Snippet: Codable, Hashable {
//
//    var _ID: String
//    var name: Struct_Profile_Name
//    var email: String
//    var phone: String
//
//    enum CodingKeys: String, CodingKey {
//        case _ID
//        case name
//        case email
//        case phone
//    }
//}
//
//
//struct Access: Codable, Hashable {
//    var group: String
//    var list: [String]
//    var is_private_account: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case group
//        case list
//        case is_private_account
//    }
//}
