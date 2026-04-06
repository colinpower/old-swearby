//
//  PhoneEntry.swift
//  SwearBy
//
//  Created by Colin Power on 11/23/25.
//

import SwiftUI
import FirebaseAuth

struct PhoneEntryStepView: View {
    var onCodeSent: (String) -> Void
    
    @State private var phoneNumber: String = ""
    @State private var isSending: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to SwearBy")
                .font(.title.bold())
            
            Text("Enter your phone number to create your account.")
                .multilineTextAlignment(.center)
            
            TextField("+1 (555) 123-4567", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button {
                sendCode()
            } label: {
                if isSending {
                    ProgressView()
                } else {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isSending || phoneNumber.isEmpty)
            
            Spacer()
        }
        .padding()
    }
    
    private func sendCode() {
        isSending = true
        errorMessage = nil
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            DispatchQueue.main.async {
                self.isSending = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let verificationID else { return }
            
            // Pass verificationID to next step
            DispatchQueue.main.async {
                onCodeSent(verificationID)
            }
        }
    }
}
