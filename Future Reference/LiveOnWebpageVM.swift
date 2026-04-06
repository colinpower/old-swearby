////
////  LiveOnWebpageVM.swift
////  SwearBy
////
////  Created by Colin Power on 1/8/24.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import Combine
//
////MARK: ViewModel ----------------------------------------------------------------------------------------------------------------
//class LiveOnWebpageVM: ObservableObject, Identifiable {
//
//    //MARK: Setup
//    private var dm = LiveOnWebpageDM()
//    private var db = Firestore.firestore()
//
//    //MARK: Published variables
//    @Published var one_webpage = EmptyVariables().empty_live_on_webpage
//    @Published var live_webpages = [LiveOnWebpage]()
//    @Published var all_live = [LiveOnWebpage]()
//    
//    
//    //MARK: Listeners
//    var one_new_webpage_listener: ListenerRegistration!
//    var live_chats_listener: ListenerRegistration!
//    var all_live_listener: ListenerRegistration!
//
//    
//    //MARK: Listen
//    func listenForOneWebpage(live_id: String, new_live_entry: LiveOnWebpage, user_id: String) {
//    
//        self.dm.getLiveOnWebpageListener(live_id: live_id, new_live_entry: new_live_entry, user_id: user_id, onSuccess: { (p) in
//
//            self.one_webpage = p
//
//        }, listener: { (listener) in
//            self.one_new_webpage_listener = listener
//        })
//    }
//    
//    func listenToAll() {
//    
//        self.dm.getAllLiveListener(onSuccess: { (p) in
//
//            self.all_live = p
//
//        }, listener: { (listener) in
//            self.all_live_listener = listener
//        })
//    }
//    
//    func listenForLiveChats(current_timestamp: Int) {
//    
//        self.dm.getLiveChatsListener(current_timestamp: current_timestamp, onSuccess: { (p) in
//
//            self.live_webpages = p
//
//        }, listener: { (listener) in
//            self.live_chats_listener = listener
//        })
//    }
//    
//    
//    //MARK: Get
////    func getOneWebpage(live_id: String, new_live_entry: LiveOnWebpage, live_user_id: String) {
////        
////        let docRef = db.collection("live_on_webpage").document(live_id)
////
////        docRef.getDocument { document, error in
////            if let error = error as NSError? {
////                print("Error getting document: \(error)")
////            }
////            else {
////                if let document = document {
////                    do {
////                        self.one_webpage = try document.data(as: LiveOnWebpage.self)
////                        
////                        LiveOnWebpageVM().updateLive(live_on_webpage_id: self.one_webpage._ID, user_ids: filtered)
////                    }
////                    catch {
////                        print(error)
////                    }
////                } else {
////                    
////                    LiveOnWebpageVM().create(new_live_on_webpage: new_live_entry, user_id: live_user_id)
////                    
////                    var new_live_entry_temp = new_live_entry
////                    new_live_entry_temp.user_ids = [live_user_id]
////                    new_live_entry_temp.timestamp.created = getTimestamp()
////                    self.one_webpage = new_live_entry_temp
////                    
////                }
////            }
////        }
////    }
//    
//    
//    
//    //MARK: Add
//    func create(new_live_on_webpage: LiveOnWebpage, user_timestamp: String, user_id: String) {
//        
//        let ref = db.collection("live_on_webpage")
//        let t = getTimestamp()
//        
//        var new1 = new_live_on_webpage
//        new1.user_timestamps = [user_timestamp]
//        new1.user_ids = [user_id]
//        new1.timestamp.created = t
//        new1.num_currently_live = 1
//        new1.last_live_timestamp = t
//        
//        do {
//            try ref.document(new_live_on_webpage._ID).setData(from: new1)
//            print("stored with new doc ref \(new_live_on_webpage._ID)")
//        }
//        catch {
//            print(error)
//        }
//    }
//    
//    
//    func updateLive(live_on_webpage_id: String, user_timestamps: [String], user_ids: [String]) {
//
//        let n = user_ids.count
//        let t = getTimestamp()
//        
//        db.collection("live_on_webpage").document(live_on_webpage_id)
//            .updateData([
//                "user_ids": user_ids,
//                "user_timestamps": user_timestamps,
//                "num_currently_live": n,
//                "last_live_timestamp": t
//            ]) { err in
//                if let err = err {
//                    print("Error updating appear: \(err)")
//                } else {
//                    print("APPEARED CORRECTLY")
//                }
//            }
//    }
//    
//    
//    func disappeared(live_on_webpage_id: String, user_timestamp: String, user_id: String, num: Int) {
//        
//        db.collection("live_on_webpage").document(live_on_webpage_id)
//            .updateData([
//                "user_ids": FieldValue.arrayRemove([user_id]),
//                "user_timestamps": FieldValue.arrayRemove([user_timestamp]),
//                "num_currently_live": num
//            ]) { err in
//                if let err = err {
//                    print("Error updating disappear: \(err)")
//                } else {
//                    print("DISAPPEARED CORRECTLY")
//                }
//            }
//    }
//}
//
//
////MARK: DataManager ----------------------------------------------------------------------------------------------------------------
//class LiveOnWebpageDM: ObservableObject {
//    
//    private var db = Firestore.firestore()
//    
//    func getLiveOnWebpageListener(live_id: String, new_live_entry: LiveOnWebpage, user_id: String, onSuccess: @escaping(LiveOnWebpage) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
//        
//        let listenerRegistration = db.collection("live_on_webpage").document(live_id)
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                
//                var p1 = EmptyVariables().empty_live_on_webpage
//                
//                do {
//                    if document.exists {
//                        
//                        p1 = try! document.data(as: LiveOnWebpage.self)
//                        
//                        var temp_user_timestamp_array = p1.user_timestamps                 // grab array of user_timestamps
//                        var temp_user_id_array = p1.user_ids                 // grab array of user_ids
//                        
//                        let hasMyUserTimestamp = (temp_user_timestamp_array.filter { $0.contains(user_id) }.count > 0)  // check if my userID is in the array
//                        
//                        if !hasMyUserTimestamp {                                               // if not, you must add your user_timestamp
//                            
//                            let my_user_timestamp = user_id + "<>" + String(getTimestamp())     // create user_timestamp
//                            
//                            temp_user_timestamp_array.append(my_user_timestamp)                 // append to array
//                            
//                            let hasMyUserID = (temp_user_id_array.filter { $0.contains(user_id) }.count > 0)   // check if my userID is in the array
//                            
//                            if !hasMyUserID {                                       // if not, you must add your user_id
//                                temp_user_id_array.append(user_id)                 // append to array
//                                LiveOnWebpageVM().updateLive(live_on_webpage_id: live_id, user_timestamps: temp_user_timestamp_array, user_ids: temp_user_id_array)
//                            } else {
//                                LiveOnWebpageVM().updateLive(live_on_webpage_id: live_id, user_timestamps: temp_user_timestamp_array, user_ids: temp_user_id_array)
//                            }
//                            
//                        }
//                        
//                    } else {
//                        
//                        let my_user_timestamp = user_id + "<>" + String(getTimestamp())     // create user_timestamp
//                        
//                        LiveOnWebpageVM().create(new_live_on_webpage: new_live_entry, user_timestamp: my_user_timestamp, user_id: user_id)
//                    }
//                }
//                catch {
//                    print(error)
//                    return
//                }
//                onSuccess(p1)
//            }
//        listener(listenerRegistration) //escaping listener
//    }
//    
//    func getLiveChatsListener(current_timestamp: Int, onSuccess: @escaping([LiveOnWebpage]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
//        
//        let listenerRegistration = db.collection("live_on_webpage")
//            .whereField("num_currently_live", isGreaterThan: 0)
//            .addSnapshotListener { (querySnapshot, error) in
//                guard let documents = querySnapshot?.documents else {
//                    print("No documents")
//                    return
//                }
//                var liveArray = [LiveOnWebpage]()
//                
//                liveArray = documents.compactMap { (queryDocumentSnapshot) -> LiveOnWebpage? in
//                    
//                    print(try? queryDocumentSnapshot.data(as: LiveOnWebpage.self))
//                    return try? queryDocumentSnapshot.data(as: LiveOnWebpage.self)
//                }
//                onSuccess(liveArray)
//            }
//        listener(listenerRegistration)
//    }
//    
//    func getAllLiveListener(onSuccess: @escaping([LiveOnWebpage]) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
//        
//        let listenerRegistration = db.collection("live_on_webpage")
//            .whereField("num_currently_live", isGreaterThan: 0)
//            //.limit(to: 5)
//            .addSnapshotListener { (querySnapshot, error) in
//                guard let documents = querySnapshot?.documents else {
//                    print("No documents")
//                    return
//                }
//                var liveArray = [LiveOnWebpage]()
//                
//                liveArray = documents.compactMap { (queryDocumentSnapshot) -> LiveOnWebpage? in
//                    
//                    print(try? queryDocumentSnapshot.data(as: LiveOnWebpage.self))
//                    return try? queryDocumentSnapshot.data(as: LiveOnWebpage.self)
//                }
//                
//                onSuccess(liveArray)
//            }
//        listener(listenerRegistration)
//    }
//    
//}
//
////MARK: Model ----------------------------------------------------------------------------------------------------------------
//struct LiveOnWebpage: Identifiable, Codable, Hashable {
//    
//    @DocumentID var id: String?
//    var _ID: String                                         // set on CREATE page
//    var _STATUS: String                                     //
//    var host: String                    // bonobos.com
//    var path: String                    // bonobos.com/shirts/001
//    var prefix: String                  // https:// OR https://www.
//    var full: String                    // https://www.bonobos.com/shirts/001
//    var user_ids: [String]              // [user1, user2, user3]
//    var user_timestamps: [String]
//    var last_chat_text: String
//    var last_chat_user_id: String
//    var last_chat_user_name: String
//    var num_currently_live: Int         // so you can search for the top pages with the top # of concurrent users
//    var last_live_timestamp: Int        // so you can get recency
//    var num_posts: Int                  // so you can query just for this page's number of posts without requesting all posts
//    var last_post_timestamp: Int        // so you can get recency
//    var timestamp: NewTimestamps        // set on CREATE page
//    var chat_ids: [String]
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case _ID
//        case _STATUS
//        case host
//        case path
//        case prefix
//        case full
//        case user_ids
//        case user_timestamps
//        case last_chat_text
//        case last_chat_user_id
//        case last_chat_user_name
//        case num_currently_live
//        case last_live_timestamp
//        case num_posts
//        case last_post_timestamp
//        case timestamp
//        case chat_ids
//    }
//}
