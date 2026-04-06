//
//  ShareViewProduct.swift
//  SharingExtension
//
//  Created by Colin Power on 4/6/23.
//

import Foundation

struct ShareViewProduct: Codable, Hashable {
    
    var name: String                                    // Weekend Warrior Dress Pants
    var url: String                                     // https://bonobos.com/products/stretch-weekday-warrior-dress-pants?color=monday%20blue
    var image: String                                   // product/{PRODUCT-ID}.png  ||  https://bonobos-prod-s3.imgix.net/products/28 ...
    var brand: ShareViewBrand
    var sheet_attributed_text: String
    var sheet_attributed_title: String
    var sheet_urlString: String
    var sheet_text: String
    var attachment_types: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case image
        case brand
        case sheet_attributed_text
        case sheet_attributed_title
        case sheet_urlString
        case sheet_text
        case attachment_types
    }
}

struct ShareViewBrand: Codable, Hashable {

    var icon: String
    var name: String
    var url: String

    enum CodingKeys: String, CodingKey {
        case icon
        case name
        case url
    }

}

struct ShareObject: Codable, Hashable {
    
    var url: String
    var sheet_attributed_text: String
    var sheet_attributed_title: String
    var raw_text: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case sheet_attributed_text
        case sheet_attributed_title
        case raw_text
        case type
    }
}

