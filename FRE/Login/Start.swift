//
//  Start.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI


struct Start: View {
    
    var enterEmailPages: [EnterEmailPage] = [.init(screen: "CreateAccount", content: ""),
                                             .init(screen: "SignIn", content: ""),
                                             .init(screen: "EnterName", content: "")]
    
//    @EnvironmentObject var viewModel: AppViewModel
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var email: String
    
    @State var startpath = NavigationPath()
    
    @Binding var isInDemoMode: Bool
    
    @Binding var isShowing: Bool
    
    var body: some View {
        
        NavigationStack(path: $startpath) {
            
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
                    
                    Text("SwearBy")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    Text("Find influencers' discounts")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 12)
                    
                    HStack(spacing: 0) {
                        
                        Text("while you're literally shopping")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.white)
                            .underline()
                    }
                    
                    
                    Spacer()

                    NavigationLink(value: enterEmailPages[0]) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Create Account")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(Color.white.opacity(0.1)))
                        .padding(.horizontal).padding(.horizontal)
                    }
                    .padding(.bottom)
                    
                    NavigationLink(value: enterEmailPages[1]) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Sign In")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .padding(.horizontal).padding(.horizontal)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    }
                }
            }
            .navigationTitle("")
            .navigationDestination(for: EnterEmailPage.self) { page in
                if page.screen == "CreateAccount" {
                    CreateAccount(email: $email, startpath: $startpath, isInDemoMode: $isInDemoMode, isShowing: $isShowing, users_vm: users_vm)
                } else if page.screen == "SignIn" {
                    // MARK: TO DO
                        // NEED TO handle scenario where someone needs an email link or a password.. must look up address
                        
                    EnterEmail(email: $email, startpath: $startpath, isInDemoMode: $isInDemoMode, users_vm: users_vm, isShowing: $isShowing)
                    
                    // This is for the scenario where they have a username and pw
                    // EnterEmailAndPassword(users_vm: users_vm, email: $email, startpath: $startpath)
                } else if page.screen == "EnterName" {
                    EnterName(users_vm: users_vm, isShowing: $isShowing)
                }
            }
            .onAppear {
                print("START appeared")
                
            }
        }
    }
}



struct EnterEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}




