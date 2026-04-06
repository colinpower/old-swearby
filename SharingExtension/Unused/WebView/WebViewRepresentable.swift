//
//  WebViewRepresentable.swift
//  SharingExtension
//
//  Created by Colin Power on 11/16/23.
//

import Foundation
import SwiftUI
import WebKit


// how to add a progress bar with estimatedprogress
// https://github.com/anupamchugh/iowncode/blob/master/SwiftUIWebViewsProgressBars/SwiftUIWebViewsProgressBars/ContentView.swift

public struct WebViewRepresentable: UIViewRepresentable {
    
    
    @Binding var action: WebViewAction              // idle, load, reload, goBack, goForward, save
    @Binding var state: WebViewState                // isLoading, pageTitle, error, canGoBack, canGoForward, currentURL
    @Binding var product_image_urls:[String]        // Brand URL, Brand Name, Product URL, Product Name, Image URLs... (should contain all values needed for grabbing info from page)
    @Binding var product_name:String
    @Binding var initial_url: String
    @Binding var brand_favicon: String
    
//    let scrollViewDelegate = MyScrollViewDelegate()
    
    // Initialize the WebView with the received actions, states, and product struct
    public init(action: Binding<WebViewAction>,
                state: Binding<WebViewState>,
                product_image_urls: Binding<[String]>,
                product_name: Binding<String>,
                initial_url: Binding<String>,
                brand_favicon: Binding<String>) {
                    _action = action
                    _state = state
                    _product_image_urls = product_image_urls
                    _product_name = product_name
                    _initial_url = initial_url
                    _brand_favicon = brand_favicon
                }

    

    // Set up WebView, enabling Javascript and loading Google as initial URL
    public func makeUIView(context: Context) -> WKWebView {
      
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator

        DispatchQueue.main.async {

            print("this is the initial url \(initial_url)")
            
            let new_url = URL(string: initial_url)!
            
            webView.load(URLRequest(url: new_url))
            
        }
        
        return webView
    }
    
    // Set up Coordinator
    public func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(webView: self)
    }

    // Define functions for idle, load, reload, goBack, goForward, save
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        switch action {
        case .idle:
            break
        case .load(let request):
            DispatchQueue.main.async {
                uiView.load(request)
            }
        case .save:        
                       
            // 1. Set up javascript
            let product_name_js = "document.title"
            let favicon_js = "Array.from(document.getElementsByTagName('link')).filter(element => element.rel == 'icon' || element.rel == 'shortcut icon').map(elem => elem.href)[0]"
            let product_images_js = "Array.from(document.getElementsByTagName('img')).filter(element => element.currentSrc.startsWith('https://') && !element.currentSrc.includes('svg')).filter(element => element.width > 50 && element.height > 50).sort(function(a,b) { return b.width - a.width }).map(elem => elem.currentSrc)"
            
            
            // 3. Run javascript
            uiView.evaluateJavaScript(product_name_js) { (response, error) in if let response = response { product_name = response as! String } else { print("ERROR") } }
            uiView.evaluateJavaScript(favicon_js) { (response, error) in if let response = response { brand_favicon = response as! String } else { print("ERROR") } }
            uiView.evaluateJavaScript(product_images_js) { (response, error) in if let response = response { product_image_urls = response as! [String] } else { print("ERROR") } }
        }
        
        action = .idle // this is important to prevent never-ending refreshes
        
    }
}

