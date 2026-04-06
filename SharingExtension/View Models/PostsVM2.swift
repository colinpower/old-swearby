//
//  PostsVM2.swift
//  SwearBy
//
//  Created by Colin Power on 2/3/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//MARK: ViewModel ----------------------------------------------------------------------------------------------------------------
class PostsVM2: ObservableObject, Identifiable {

    //MARK: Setup
    private var dm = Posts2DM()
    private var db = Firestore.firestore()

    //MARK: Published variables
    @Published var posts_on_domain = [Posts2]()
    @Published var one_post = EmptyVariables().empty_post2

    @Published var found_posts = [Posts2]()
    
    //MARK: Listeners
    var posts_on_domain_listener2: ListenerRegistration!
    var one_post_listener2: ListenerRegistration!

    //MARK: GET
    
    func getPostsOnDomain(domain: String) {
        
        let docRef = db.collection("new_posts")
            .whereField("url.host", isEqualTo: domain)
            .getDocuments { (snapshot, error) in
                
                guard let snapshot = snapshot, error == nil else {
                    //handle error
                    print("found error")
                    return
                }
                print("Number of documents: \(snapshot.documents.count)")
                
                self.found_posts = snapshot.documents.compactMap({ queryDocumentSnapshot -> Posts2? in
                    
                    print(try? queryDocumentSnapshot.data(as: Posts2.self))
                    return try? queryDocumentSnapshot.data(as: Posts2.self)
                })
            }
    }
    
    
    //MARK: Listen
    func listenForPostsOnDomain(hostname: String, user_id: String, following: [String]) {
    
        self.dm.getPostsOnDomainListener(hostname: hostname, user_id: user_id, following: following, onSuccess: { (posts) in

            self.posts_on_domain = posts

        }, listener: { (listener) in
            self.posts_on_domain_listener2 = listener
        })
    }
    
    
    func listenForOnePost(post_id: String) {
    
        self.dm.getOnePostListener(post_id: post_id, onSuccess: { (p) in

            self.one_post = p

        }, listener: { (listener) in
            self.one_post_listener2 = listener
        })
    }
    
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
    
    // for people who click "COPY" or "OPEN" on your discount
    func clicked(post: Posts2, user_id: String) {
        
        let docRef = Firestore.firestore().collection("new_posts").document(post._ID)
        
        let device_id = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let uid = !user_id.isEmpty ? user_id : !device_id.isEmpty ? device_id : ("unknown" + UUID().uuidString)
        
        docRef.updateData([
            "referral.clicks": FieldValue.arrayUnion([(uid + "-SHARE")])     // Ensures uniqueness
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Successfully updated document")
            }
        }
    }
    
    
    
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
    
    func delete(post_id: String) {

        db.collection("new_posts").document(post_id)
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
class Posts2DM: ObservableObject {
    
    private var db = Firestore.firestore()
    
    func getPostsOnDomainListener(hostname: String, user_id: String, following: [String], onSuccess: @escaping([Posts2]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("new_posts")
            .whereField("url.host", isEqualTo: hostname)
            .whereField("timestamp.deleted", isEqualTo: 0)
            .order(by: "timestamp.created", descending: true)
            .limit(toLast: 15)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                var postsArray = [Posts2]()
                
                postsArray = documents.compactMap { (queryDocumentSnapshot) -> Posts2? in
                    
                    print(try? queryDocumentSnapshot.data(as: Posts2.self))
                    return try? queryDocumentSnapshot.data(as: Posts2.self)
                }
                
                // Filter the results to just PUBLIC posts and posts shared with this user
                if user_id.isEmpty {
                    onSuccess(postsArray.filter( { $0.isPublicPost == true } ))
                } else {
                    onSuccess(postsArray.filter( { $0.isPublicPost == true || following.contains($0.user._ID) } ))
                }
            }
        listener(listenerRegistration)
    }
    
    func getOnePostListener(post_id: String, onSuccess: @escaping(Posts2) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerRegistration = db.collection("new_posts").document(post_id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                var p1 = EmptyVariables().empty_post2
                
                do {
                    if document.exists {
                        p1 = try! document.data(as: Posts2.self)
                    } else {
                        p1.text = "NO POST FOUND"
                    }
                }
                catch {
                    print(error)
                    return
                }
                onSuccess(p1)
            }
        listener(listenerRegistration) //escaping listener
    }
    
    
    
    
    
    
}

//MARK: Model ----------------------------------------------------------------------------------------------------------------
struct Posts2: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var _ID: String                                         // set on CREATE page
    var created_by_civilian: String
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
