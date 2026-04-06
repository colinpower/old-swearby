//
//  Simple_WebViewComponents.swift
//  SharingExtension
//
//  Created by Colin Power on 11/20/23.
//

import Foundation
import SwiftUI
import WebKit

// Set up Actions
public enum Simple_WebViewAction {
    case idle,                                  // idle is always needed as actions need an empty state
         load(URLRequest)
}

// Set up States
public struct Simple_WebViewState {
    public internal(set) var isLoading: Bool
    public internal(set) var pageTitle: String?
    public internal(set) var currentURL: String?

    public static let empty = Simple_WebViewState(isLoading: false,
                                                  pageTitle: nil,
                                                  currentURL: "google.com")
}
