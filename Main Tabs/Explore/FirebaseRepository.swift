//
//  FirebaseRepository.swift
//  SwearBy
//
//  Created by Colin Power on 11/23/25.
//

import Foundation
import FirebaseFirestore

protocol FirestoreRepositoryProtocol {
    //func fetchTabOneItems(completion: @escaping (Result<[Item], Error>) -> Void)
    func fetchTabTwoItems(completion: @escaping (Result<[NewPosts], Error>) -> Void)
}

final class FirestoreRepository: FirestoreRepositoryProtocol {
    private let db = Firestore.firestore()
    
//    func fetchTabOneItems(completion: @escaping (Result<[Item], Error>) -> Void) {
//        db.collection("tabOneItems")
//            .order(by: "createdAt", descending: true)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                do {
//                    let items = try snapshot?.documents.compactMap {
//                        try $0.data(as: Item.self)
//                    } ?? []
//                    completion(.success(items))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//    }
    
    func fetchTabTwoItems(completion: @escaping (Result<[NewPosts], Error>) -> Void) {
        db.collection("new_posts")
            .whereField("isPublicPost", isEqualTo: true)
            .whereField("timestamp.deleted", isEqualTo: 0)
            .order(by: "timestamp.created", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    let items = try snapshot?.documents.compactMap {
                        try $0.data(as: NewPosts.self)
                    } ?? []
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
