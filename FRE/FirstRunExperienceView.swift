//
//  FirstRunView.swift
//  SwearBy
//
//  Created by Colin Power on 11/23/25.
//

import SwiftUI
import FirebaseAuth
import UserNotifications


enum OnboardingStep: Equatable {
//    case splash
//    case howToIn3Steps
    case phoneEntry
    case codeVerification(verificationID: String)
//    case addToShareSheet1
//    case addToShareSheet2
//    case addToShareSheet3
    case notifications
    case finished
}

struct FirstRunExperienceView: View {
    @EnvironmentObject var session: SessionManager
    @State private var step: OnboardingStep = .phoneEntry
    
    var body: some View {
        ZStack {
            switch step {
            case .phoneEntry:
                PhoneEntryStepView { verificationID in
                    step = .codeVerification(verificationID: verificationID)
                }
                
            case .codeVerification(let verificationID):
                CodeVerificationStepView(verificationID: verificationID) {
                    // Phone number verified, user authenticated
                    step = .notifications
                }
                
            case .notifications:
                NotificationsStepView {
                    // Notifications handled. Onboarding is done.
                    session.markOnboardingComplete()
                    step = .finished
                }
                
            case .finished:
                // Could show a brief “All set!” screen, but SessionManager
                // will switch us to .main, so just placeholder:
                ProgressView("Finishing up…")
            }
        }
        .animation(.easeInOut, value: step)
    }
}

