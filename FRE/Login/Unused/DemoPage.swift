//
//  DemoPage.swift
//  SwearBy
//
//  Created by Colin Power on 6/29/23.
//

import Foundation
import SwiftUI


struct DemoPage: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var startpath: NavigationPath
    
    @State var startDate = Date.now
    @State var timeElapsed: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
            
        ZStack(alignment: .top) {
            
            Color("SwearByGold").ignoresSafeArea()
            
//                TabView {
//                    Text("First")
//                    Text("Second")
//                    Text("Third")
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
            
            VStack(alignment: .center, spacing: 0) {
                
                Spacer()
                    
                let w = UIScreen.main.bounds.width / 3 * 2
                let h = w * 7 / 11
                
                // dimensions are 550w x 350h
                Image("AppIcon_blank")
                    .resizable()
                    .frame(width: w, height: h)
                    .padding(.bottom, 16)
                
                Text("SwearBy Demo")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                
                Spacer()
                
                Text("For Apple iOS App Review")
//                        .font(.system(size: 16, weight: .medium).italic())
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 8)
                
                
                Spacer()                    
                
                if timeElapsed < 6 {
                    Text("Entering in \(String(5 - timeElapsed))")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 60)
                        .onReceive(timer) { firedDate in
                            
                            timeElapsed = Int(firedDate.timeIntervalSince(startDate))
                            
                        }
                }
                
            }
        }
        .navigationTitle("")
//        .onAppear {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                
//                let eml = "demo@swearby.app"
//                let pw = "appledemo"
//                
//                SessionManager().signIn(email: eml, password: pw) { result in
//                    
//                    switch result {
//                    
//                    case let .success(user):
//                        viewModel.listen(users_vm: users_vm)
//                        
//                    case let .failure(error):
//                        alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
//                    }
//                    
//                }
//            }
//        }
    }
}

