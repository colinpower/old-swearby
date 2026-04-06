//
//  LinkVM.swift
//  SharingExtension
//
//  Created by Colin Power on 2/15/24.
//

import Foundation
import SwiftUI
import LinkPresentation
import FirebaseAuth
import FirebaseStorage

class LinkVM : ObservableObject {
    
    //MARK: Published variables
    @Published var metadata: LPLinkMetadata?
    @Published var image: UIImage?
    @Published var icon: UIImage?
    
    //MARK: Get
    func getMetadata(link: String) {
        
        let metadataProvider = LPMetadataProvider()
        
        guard let url = URL(string: link) else {
            return
        }
        
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            guard error == nil else {
                assertionFailure("Error")
                return
            }
            
            DispatchQueue.main.async {
                self.metadata = metadata
            }
            
            guard let imageProvider = metadata?.imageProvider else { return }
            imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                guard error == nil else {
                    // handle error
                    return
                }
                if let image = image as? UIImage {
                    // do something with image
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    
//                    // Choose a storage path. If you have a user:
//                    let uid = Auth.auth().currentUser?.uid ?? "anonymous"
//                    let filename = UUID().uuidString + ".jpg"
//                    let path = "linkPreviews/\(uid)/\(filename)"
//
//                    self.uploadImageToStorage(image, path: path) { result in
//                        switch result {
//                        case .success(let url):
//                            print("Uploaded preview image. Download URL:", url.absoluteString)
//                            // Optional: store url.absoluteString in Firestore alongside the link
//                        case .failure(let err):
//                            print("Upload failed:", err)
//                        }
//                    }
                    
                    
                    
                } else {
                    print("no image available")
                }
            }
            
            guard let iconProvider = metadata?.iconProvider else { return }
            iconProvider.loadObject(ofClass: UIImage.self) { (icon, error) in
                guard error == nil else {
                    // handle error
                    return
                }
                if let icon = icon as? UIImage {
                    // do something with icon
                    DispatchQueue.main.async {
                        self.icon = icon
                    }
                } else {
                    print("no image available")
                }
            }
        }
    }
}


extension LinkVM {

    /// Uploads a UIImage to Firebase Storage and returns the download URL string.
    func uploadImageToStorage(
        _ image: UIImage,
        path: String,
        jpegQuality: CGFloat = 0.85,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        // Convert UIImage -> Data (JPEG). Use pngData() if you prefer PNG.
        guard let data = image.jpegData(compressionQuality: jpegQuality) else {
            completion(.failure(NSError(domain: "LinkVM", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to encode image as JPEG."
            ])))
            return
        }

        let storageRef = Storage.storage().reference().child(path)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(data, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let url = url else {
                    completion(.failure(NSError(domain: "LinkVM", code: -2, userInfo: [
                        NSLocalizedDescriptionKey: "No download URL returned."
                    ])))
                    return
                }
                completion(.success(url))
            }
        }
    }
}
