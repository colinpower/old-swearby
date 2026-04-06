//
//  FirestoreService.swift
//  SwearBy
//
//  Created by Colin Power on 11/24/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreService {
    private let db = Firestore.firestore()
    
    // Loads a doc if it exists. Returns nil if missing.
    func fetchDocumentIfExists<T: Decodable>(collection: String, docId: String, as type: T.Type) async throws -> T? {
        let ref = db.collection(collection).document(docId)
        
        do {
            let snapshot = try await ref.getDocument()
            
            if snapshot.exists {
                return try snapshot.data(as: T.self)
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}

@MainActor
class ExampleViewModel: ObservableObject {
    @Published var doc: Sites?
    @Published var didCheck = false

    private let service = FirestoreService()

    /// Pass in any docID you want to check/load
    func loadDocument(with docID: String) async {
        do {
            let result = try await service.fetchDocumentIfExists(
                collection: "users",
                docId: docID,
                as: Sites.self
            )
            self.doc = result
            self.didCheck = true
        } catch {
            print("Error fetching document: \(error.localizedDescription)")
        }
    }
}

//struct MyDocument: Codable, Identifiable {
//    @DocumentID var id: String?
//    let title: String?
//    let createdAt: Date?
//}

struct Sites: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var site_id: String                                         // set on CREATE page
    var notifications: [String]
    var no_notifications: [String]                                     //
    var t_created: Int
    var t_updated: Int
    var url_host: String
    var url_full: String
    var url_original: String
    var url_domain: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case site_id
        case notifications
        case no_notifications
        case t_created
        case t_updated
        case url_host
        case url_full
        case url_original
        case url_domain
    }
}
