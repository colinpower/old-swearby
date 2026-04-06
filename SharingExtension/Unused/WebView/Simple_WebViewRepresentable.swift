//
//  Simple_WebViewRepresentable.swift
//  SharingExtension
//
//  Created by Colin Power on 11/20/23.
//

import Foundation
import SwiftUI
import WebKit

// progress bar!!
// https://dev.to/quangdecember/creating-simple-web-browser-with-wkwebview-uinavigationcontroller-2kn6

// how to add a progress bar with estimatedprogress
// https://github.com/anupamchugh/iowncode/blob/master/SwiftUIWebViewsProgressBars/SwiftUIWebViewsProgressBars/ContentView.swift

public struct Simple_WebViewRepresentable: UIViewRepresentable {
    
//    @ObservedObject var observe = observable()     // Variables
    
    @Binding var action: Simple_WebViewAction              // idle, load
    @Binding var state: Simple_WebViewState                // isLoading, currentURL
    @Binding var initial_url: String
    
    // Initialize the WebView with the received actions, states, and product struct
    public init(action: Binding<Simple_WebViewAction>,
                state: Binding<Simple_WebViewState>,
                initial_url: Binding<String>) {
                    _action = action
                    _state = state
                    _initial_url = initial_url
                }

    

    // Set up WebView, enabling Javascript and loading Google as initial URL
    public func makeUIView(context: Context) -> WKWebView {
        
        let configuration = WKWebViewConfiguration()

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        DispatchQueue.main.async {
            webView.load(URLRequest(url: URL(string: initial_url)!))
        }
        
        return webView
    }
    
    // Set up Coordinator
    public func makeCoordinator() -> Simple_WebViewCoordinator {
        Simple_WebViewCoordinator(webView: self)
    }

    // Define functions for idle, load, reload, goBack, goForward, save
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        
        switch action {
        case .idle:
            break
        case .load(let request):
            DispatchQueue.main.async {
                uiView.load(request)
//                observe.observation = uiView.observe(\WKWebView.title, options: .new) { view, change in
//                    if let title = view.title {
//                        observe.loggedIn = true     // We loaded the page
//                        state.pageTitle = title     // Grab the title
//                        print("Page loaded: \(title)")
//                    }
//                }
            }
            action = .idle // this is important to prevent never-ending refreshes
        }
    }
}


//// Small class to hold variables that we'll use in the View body
//class observable: ObservableObject {
//    @Published var observation:NSKeyValueObservation?
//    @Published var loggedIn = false
//}
