//
//  CodeVerificationStepView.swift
//  SwearBy
//
//  Created by Colin Power on 11/23/25.
//

import SwiftUI
import FirebaseAuth

struct CodeVerificationStepView: View {
    let verificationID: String
    var onVerified: () -> Void
    
    @State private var code: String = ""
    @State private var isVerifying: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter the code we sent you")
                .font(.title2.bold())
            
            TextField("123456", text: $code)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button {
                verifyCode()
            } label: {
                if isVerifying {
                    ProgressView()
                } else {
                    Text("Verify")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isVerifying || code.isEmpty)
            
            Spacer()
        }
        .padding()
    }
    
    private func verifyCode() {
        isVerifying = true
        errorMessage = nil
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            DispatchQueue.main.async {
                self.isVerifying = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            // Signed in! SessionManager will see auth change.
            DispatchQueue.main.async {
                onVerified()
            }
        }
    }
}
