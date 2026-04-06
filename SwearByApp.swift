//
//  SwearByApp.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import UserNotifications
import Mixpanel
//import FirebaseMessaging
//import FirebaseFunctions

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        Mixpanel.initialize(token: "5654b0695c7a70c8905f6d8755c47764", trackAutomaticEvents: false)
        
        return true
    }
    

    // Handling phone auth
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Note: if you do "production", you must change your entitlements file where it says "SwearBy" above "GoogleService-Info"
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)

        // Convert deviceToken to hex string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device token received: \(token)")

        // Persist for later use
        UserDefaults.standard.set(token, forKey: "device_token")
    }
    
    func application(_ application: UIApplication,
            didReceiveRemoteNotification notification: [AnyHashable : Any],
            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
          }
          // This notification is not auth related; it should be handled separately.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            //print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}


@main
struct SwearByApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var sessionManager = SessionManager()
    
    var body: some Scene {
        
        //let viewModel = AppViewModel()
        
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
        }
    }
}
