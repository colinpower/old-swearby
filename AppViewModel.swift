//
//  AppViewModel.swift
//  SwearBy
//
//  Created by Colin Power on 2/24/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine



class UserObject {
    var uid: String
    var email: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}


class AppViewModel: ObservableObject {
    
    @Published var signedIn = false
    //@Published var currentUser1: Users?
    
    @Published var isNewUserAuth = false
    
    let auth = Auth.auth()
    let email = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    var didChange = PassthroughSubject<AppViewModel, Never>()
    @Published var session: UserObject? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    //need to remove the listener so you're not constantly listening
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func listen(users_vm: UsersVM) {
        
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth1, user1) in
            
            print("here in the listen() function")
            print(auth1)
            print(user1)
            
            if let user1 = user1 {
                
                // Set up the shared auth thing
//                self.setupAndMigrateFirebaseAuth()
                
                if auth1.userAccessGroup == "group.UncommonInc.SwearBy" {
                    print("all good")
                } else {

                    print("NEED TO SET THE USER ACCESS GROUP")
                    do {
                        try auth1.useUserAccessGroup("group.UncommonInc.SwearBy")
                    } catch let error as NSError {
                        print("Error changing user access group: %@", error)
                    }
                }
                   
                
                
                // if we have a user, create a new user model
                
                print("we have a session.. setting it to UserObject of the current user")
                print("Got user: \(user1)")
                
                //UsersVM().listenForOneUser(userID: user1.uid)
                let temp_user_id = user1.uid
                print("Got user id: \(temp_user_id)")
                
                users_vm.listenForOneUser(user_id: temp_user_id)
                
                print(String(user1.uid))
                print(user1.email ?? "")
                
                self.session = UserObject(
                    uid: user1.uid,
                    email: user1.email ?? ""
                )
                
            } else {
                print("No active session found. Setting AppVM.session object to nil")
                //self.session = nil
                
            }
        }
        
    }
    
    
}


