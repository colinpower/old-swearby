//
//  KeyboardAwareModifier.swift
//  SwearBy
//
//  Created by Colin Power on 3/20/23.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    var offset:CGFloat

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .transition(.move(edge: .bottom))
            .animation(.spring(response: 0.32, dampingFraction: 1, blendDuration: 0.32), value: keyboardHeight)
            .padding(.bottom, keyboardHeight != 0 ? offset : 0)
//            .padding(.bottom, keyboardHeight != 0 ? keyboardHeight - 50 : 0)
        
//            .padding(.bottom, keyboardHeight != 0 ? keyboardHeight : 0)
            
        
        //.padding(.bottom, keyboardHeight)
            //.animation(.easeIn(duration: 0.5), value: keyboardHeight)
            //.animation(.linear(duration: 0.4))
            //.animation(.interpolatingSpring(stiffness: 100, damping: 200, initialVelocity: 4.5), value: keyboardHeight)
            
            .onReceive(keyboardHeightPublisher) {
                self.keyboardHeight = $0
            }
    }
}

struct KeyboardAwareModifier2: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    var offset:CGFloat

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
//            .transition(.move(edge: .bottom))
//            .animation(.spring(response: 0.32, dampingFraction: 1, blendDuration: 0.32), value: keyboardHeight)
            .padding(.bottom, keyboardHeight != 0 ? keyboardHeight - offset : 0)
//            .padding(.bottom, keyboardHeight != 0 ? keyboardHeight - 50 : 0)
        
//            .padding(.bottom, keyboardHeight != 0 ? keyboardHeight : 0)
            
        
        //.padding(.bottom, keyboardHeight)
            //.animation(.easeIn(duration: 0.5), value: keyboardHeight)
            //.animation(.linear(duration: 0.4))
            //.animation(.interpolatingSpring(stiffness: 100, damping: 200, initialVelocity: 4.5), value: keyboardHeight)
            
            .onReceive(keyboardHeightPublisher) {
                self.keyboardHeight = $0
            }
    }
}


extension View {
    func KeyboardAwarePadding(offset: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier(offset: offset))
    }
    
    func KeyboardAwarePadding2(offset: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier2(offset: offset))
    }
    
}



