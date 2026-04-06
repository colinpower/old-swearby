//
//  Simple_WebViewCoordinator.swift
//  SharingExtension
//
//  Created by Colin Power on 11/20/23.
//


import Foundation
import SwiftUI
import WebKit

public class Simple_WebViewCoordinator: NSObject, UIScrollViewDelegate {
    private let webView: Simple_WebViewRepresentable
    
    init(webView: Simple_WebViewRepresentable) {
        self.webView = webView

    }
    
    // Convenience method, used later
    func setLoading(_ isLoading: Bool, error: Error? = nil) {
        var newState =  webView.state
        newState.isLoading = isLoading
//        if let error = error {
//            newState.error = error
//        }
        webView.state = newState
    }
}

extension Simple_WebViewCoordinator: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setLoading(false)
        
        var newState1 = self.webView.state
        newState1.isLoading = false
        newState1.pageTitle = webView.title
        self.webView.state = newState1
        
        if let url = webView.url?.absoluteString {
            self.webView.state.currentURL = url
        }
        
//        webView.title
//        observe.observation = uiView.observe(\WKWebView.title, options: .new) { view, change in
//            if let title = view.title {
//                observe.loggedIn = true     // We loaded the page
//                state.pageTitle = title     // Grab the title
//                print("Page loaded: \(title)")
//            }
//        }
        
//        webView.evaluateJavaScript("document.title") { (response, error) in
//            var newState = self.webView.state
//            newState.pageTitle = response as? String
//            self.webView.state = newState
//        }
    }
    


  public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    setLoading(false)
  }

  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    setLoading(false, error: error)
  }

  public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    setLoading(true)
  }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        var newState = self.webView.state
        newState.isLoading = true
        newState.currentURL = webView.url?.absoluteString ?? ""
        self.webView.state = newState
    }
    
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            decisionHandler(WKNavigationActionPolicy(rawValue: WKNavigationActionPolicy.allow.rawValue + 2)!)
        
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // COMMENTING Sept 17.. MAYBE REVERT HERE??
        if let frame = navigationAction.targetFrame,
                frame.isMainFrame {
                return nil
            }
        
        // for _blank target or non-mainFrame target
        webView.load(navigationAction.request)
        return nil
        
    }
    
}
