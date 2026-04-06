//
//  WebViewCoordinator.swift
//  SwearBy
//
//  Created by Colin Power on 1/20/25.
//

import Foundation
import SwiftUI
import WebKit

public class WebViewCoordinator: NSObject, UIScrollViewDelegate {
    private let webView: WebViewRepresentable
    
    init(webView: WebViewRepresentable) {
        self.webView = webView
    }
    
    // Convenience method, used later
    func setLoading(_ isLoading: Bool, error: Error? = nil) {
        var newState =  webView.state
        newState.isLoading = isLoading
        if let error = error {
            newState.error = error
        }
        webView.state = newState
    }
}

extension WebViewCoordinator: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setLoading(false)
        
        // Automatically trigger the thing to save
        self.webView.action = .save
        
        var newState1 = self.webView.state
        newState1.isLoading = false
        self.webView.state = newState1
        
        if let url = webView.url?.absoluteString {
            
            print("PRINTING URL: \(url)")
            self.webView.state.currentURL = url
        }
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
