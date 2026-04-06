//
//  WebViewComponents.swift
//  SwearBy
//
//  Created by Colin Power on 1/20/25.
//


import Foundation
import SwiftUI
import WebKit

// Set up Actions
public enum WebViewAction {
    case idle,                                  // idle is always needed as actions need an empty state
         load(URLRequest),
         save
}

// Set up States
public struct WebViewState {
    public internal(set) var isLoading: Bool
    public internal(set) var pageTitle: String?
    public internal(set) var error: Error?
    public internal(set) var currentURL: String?

    public static let empty = WebViewState(isLoading: false,
                                            pageTitle: nil,
                                            error: nil,
                                            currentURL: "google.com")
}
