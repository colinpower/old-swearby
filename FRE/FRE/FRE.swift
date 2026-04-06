//
//  FRE.swift
//  SwearBy
//
//  Created by Colin Power on 1/19/25.
//


import Foundation
import SwiftUI

struct FRE: View {
    
    @Binding var showFRE: Bool
    
    @State private var page: Int = 2
    
    var body: some View {
        Group {
            if page == 2 {
                FRE2(showFRE: $showFRE, page: $page)
            } else if page == 3 {
                FRE3(showFRE: $showFRE, page: $page)
            }
            else if page == 6 {
                FRE6(showFRE: $showFRE, page: $page)
            }
            else if page == 7 {
                FRE7(showFRE: $showFRE, page: $page)
            }
            else if page == 8 {
                FRE8(showFRE: $showFRE, page: $page)
            }
            else if page == 10 {
                FRE10(showFRE: $showFRE, page: $page)
            }
        }
        .onAppear {
        }
    }
}
