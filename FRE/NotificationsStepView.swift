//
//  NotificationsStepView.swift
//  SwearBy
//
//  Created by Colin Power on 11/23/25.
//

import SwiftUI
import UserNotifications

struct NotificationsStepView: View {
    var onFinished: () -> Void
    
    @State private var isRequesting: Bool = false
    @State private var granted: Bool? = nil
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Stay in the loop")
                .font(.title2.bold())
            
            Text("Enable push notifications so we can let you know when new discounts are available.")
                .multilineTextAlignment(.center)
            
            if let granted {
                Text(granted ? "Notifications enabled ✅" : "Notifications not enabled.")
                    .foregroundColor(granted ? .green : .secondary)
            }
            
            Button {
                requestNotifications()
            } label: {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Enable Notifications")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isRequesting)
            
            Button("Skip for now") {
                onFinished()
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
    }
    
    private func requestNotifications() {
        isRequesting = true
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    self.isRequesting = false
                    self.granted = granted
                    // Regardless of result, we consider this step done.
                    self.onFinished()
                }
            }
    }
}
