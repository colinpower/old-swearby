//
//  LinkVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/18/24.
//

import Foundation
import SwiftUI
import LinkPresentation

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
