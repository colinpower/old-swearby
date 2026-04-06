//
//  ShareViewController.swift
//  SharingExtension
//
//  Created by Colin Power on 4/5/23.
//


// Overall note: See files before Apr 18, 2024 for all the tested / commented out work


import UIKit
import MobileCoreServices
import SwiftUI
import UniformTypeIdentifiers
import Social
import CoreServices
import Mixpanel

// Critical for parsing the plain-text for any urls
// https://medium.com/@damisipikuda/how-to-receive-a-shared-content-in-an-ios-application-4d5964229701

// Issues when loading the share extension two times
// https://github.com/alinz/react-native-share-extension/issues/100

// Grabbing multiple data types when loading share sheet
// https://medium.com/@ales.musto/making-a-share-extension-that-accepts-text-and-urls-in-combination-with-coredata-swift-3-a0139c0f9800

// Possible solution for getting the URL metadata using npm
// https://www.npmjs.com/package/url-metadata

// Helpful for splitting into functions
// https://medium.com/@damisipikuda/how-to-receive-a-shared-content-in-an-ios-application-4d5964229701


// Removing these temporarily:
    // NSExtensionActivationSupportsWebPageWithMaxCount
    // NSExtensionJavaScriptPreprocessingFile



class ShareViewController: UIViewController {
    
    let sharedDefault = UserDefaults(suiteName: "group.UncommonInc.SwearBy")!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Mixpanel.initialize(token: "5654b0695c7a70c8905f6d8755c47764", trackAutomaticEvents: false)
        
        var foundPublicURL: Bool = false
        var foundPlainText: Bool = false
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            for (index, _) in (item.attachments?.enumerated())! {
                if let itemProvider = item.attachments?[index] as? NSItemProvider {

                    // print out the registered type identifiers so we can see what's there
                    itemProvider.registeredTypeIdentifiers.forEach {
                        print (String(describing: $0))
                        
                        if String(describing: $0) == "public.url" {
                            print("MATCHED PUBLIC.URL")
                            foundPublicURL = true
                        } else if String(describing: $0) == "public.plain-text" {
                            print("MATCHED PUBLIC.URL")
                            foundPlainText = true
                        }
                    }
                }
            }
        }
        
        if foundPublicURL {
            handleURL()
        } else if foundPlainText {
            handleText()
        } else {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            
            //UIApplication.shared.open(URL(string: "https://www.google.com")!)
            
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("open-app"), object: nil, queue: nil) { _ in
            
            do {
                let result = self.openURL(URL(string: "https://swearby.page.link")!)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    
    private func handleURL() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
                
                let sheet_attributed_text = item.attributedContentText?.string ?? "no_attributed_text"
                let sheet_attributed_title = item.attributedTitle?.string ?? "no_attributed_title"
                
                for attachment in item.attachments! {
                    
                    // 2. Grab URL
                    if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier as String) {
                        
                        attachment.loadItem(forTypeIdentifier: UTType.url.identifier as String) { item, _ in
                            let sheet_urlString = (item as! NSURL).absoluteURL!
                            
                            DispatchQueue.main.async {
                                self.setupViews(url: sheet_urlString.absoluteString,
                                                sheet_attributed_text: sheet_attributed_text,
                                                sheet_attributed_title: sheet_attributed_title,
                                                raw_text: "",
                                                type: "public.url")
                            }
                            
                            return
                            
                        }
                    }
                }
            }
        }
    }
    
    
    private func handleText() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
                
                let sheet_attributed_text = item.attributedContentText?.string ?? "no_attributed_text"
                let sheet_attributed_title = item.attributedTitle?.string ?? "no_attributed_title"
                    
                for attachment in item.attachments! {
                    
                    // 3. Grab Text
                    if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier as String) {
                        
                        attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier as String) { item, _ in
                            
                            if let text = item as? String {
                                do {
                                    
                                    // Add CHECK FOR NORDSTROM TEXT IN ADDITION TO ABERCROMBIE TEXT!!!!!
                                    if checkForAbercrombieText(text: text) {
                                        let abercrombie_url_pct_encoded = convertAbercrombieText(text: text)
                                        let abercrombie_url = abercrombie_url_pct_encoded.removingPercentEncoding
                                        
                                        DispatchQueue.main.async {
                                            self.setupViews(url: abercrombie_url!,
                                                            sheet_attributed_text: sheet_attributed_text,
                                                            sheet_attributed_title: sheet_attributed_title,
                                                            raw_text: text,
                                                            type: "plain-text")
                                        }
                                        
                                        return
                                        
                                    } else {
                                        // Detect URLs in String
                                        let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                                        let matches = detector.matches(
                                            in: text,
                                            options: [],
                                            range: NSRange(location: 0, length: text.utf16.count)
                                        )
                                        // Get first URL found
                                        if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                                            print(text[range])
                                            
                                            let url_from_text = String(text[range])
                                            
                                            DispatchQueue.main.async {
                                                self.setupViews(url: url_from_text,
                                                                sheet_attributed_text: sheet_attributed_text,
                                                                sheet_attributed_title: sheet_attributed_title,
                                                                raw_text: text,
                                                                type: "plain-text")
                                            }
                                            
                                            return
                                            
                                        } else {
                                            print("No URL found")
                                            return
                                        }
                                    }
                                } catch let error {
                                    print("Do-Try Error: \(error.localizedDescription)")
                                    return
                                }
                            } else {
                                print("No Text Found Error")
                                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                return
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    
    private func setupViews(url: String, sheet_attributed_text: String, sheet_attributed_title: String, raw_text: String, type: String) {
        
        let userDefaults_user_id = sharedDefault.string(forKey: "user_id") ?? ""

        let swearByShareView = UIHostingController(rootView: ShareViewAuthContainer(shareViewObject: ShareObject(url: url, sheet_attributed_text: sheet_attributed_text, sheet_attributed_title: sheet_attributed_title, raw_text: raw_text, type: type), user_id: userDefaults_user_id))
                
        addChild(swearByShareView)
        self.view.addSubview(swearByShareView.view)
        swearByShareView.view.translatesAutoresizingMaskIntoConstraints = false
        swearByShareView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        swearByShareView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        swearByShareView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        swearByShareView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        swearByShareView.view.backgroundColor = .clear
    }
    
    //  Function must be named exactly like this so a selector can be found by the compiler!
    //  Anyway - it's another selector in another instance that would be "performed" instead.
    @objc
    func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    
}
