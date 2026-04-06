//
//  SessionManager.swift
//  SwearBy
//
//  Created by Colin Power on 11/23/25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

enum AppFlowState {
    case loading        // checking auth, fetching user doc, etc.
    case onboarding     // First Run Experience
    case main           // Main tabbed app
}

final class SessionManager: ObservableObject {
    @Published var appFlowState: AppFlowState = .loading
    @Published var currentUser: User?          // FirebaseAuth.User
    @Published var onboardingComplete: Bool = false
    
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        listenToAuthChanges()
    }
    
    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func listenToAuthChanges() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            
            self.currentUser = user
            
            if let user = user {
                // User is authenticated; fetch onboarding status
                self.fetchOnboardingStatus(for: user)
            } else {
                // Not authenticated → show onboarding
                self.onboardingComplete = false
                self.appFlowState = .onboarding
            }
        }
    }
    
    private func fetchOnboardingStatus(for user: User) {
        appFlowState = .loading
        
        db.collection("new_users").document(user.uid).getDocument { [weak self] snapshot, error in
            guard let self else { return }
            
            if let error = error {
                print("Error fetching user doc: \(error)")
                // Fallback: assume onboarding not complete
                self.onboardingComplete = false
                self.appFlowState = .onboarding
                return
            }
            
            let data = snapshot?.data() ?? [:]
            let complete = data["onboardingComplete"] as? Bool ?? false
            self.onboardingComplete = complete
            self.appFlowState = complete ? .main : .onboarding
        }
    }
    
    func markOnboardingComplete() {
        guard let user = currentUser else {
            // Edge case: user somehow not signed in
            appFlowState = .onboarding
            return
        }
        
        let docRef = db.collection("new_users").document(user.uid)
        docRef.setData(["onboardingComplete": true], merge: true) { [weak self] error in
            if let error = error {
                print("Error updating onboardingComplete: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self?.onboardingComplete = true
                self?.appFlowState = .main
            }
        }
    }
    
    func passwordlessSignIn(email: String, link: String,
                                      completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, link: link) { result, error in

            if let error = error {
                
                completion(.failure(error))
            } else {

                //setupAndMigrateFirebaseAuth()
                
                completion(.success(result!.user))
            }
        }
    }
    
    func signIn(email: String, password: String,
                completion: @escaping (Result<User, Error>) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {

                //setupAndMigrateFirebaseAuth()
                
                completion(.success(result!.user))
            }
        }
    }
    

    func createAccount(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                completion(.success(result!.user))
            }
        }
    }
    
    
    func signOut(users_vm: UsersVM) -> Bool {
        do {
            
            users_vm.one_user = EmptyVariables().empty_user
            
            try Auth.auth().signOut()
            
//            self.signedIn = false
//            self.session = nil
            
            if users_vm.one_user_listener != nil {
                users_vm.one_user_listener.remove()
            }
            
            return true
            
        } catch {
            
            return false
            
        }
    }
    
}
