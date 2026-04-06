//
//  ReportConcernHalfSheet.swift
//  SwearBy
//
//  Created by Colin Power on 6/20/23.
//

import Foundation
import SwiftUI


enum ReportAConcernCategory: String, CaseIterable, Identifiable {
    case none, offensive, harassment, other
    var id: Self { self }
}

struct ReportConcernHalfSheet: View {
    
    var content_type: String
    var reported_by_user_id: String
    
    @Binding var reportContentID: String
    @Binding var isReportConcernHalfSheetPresented: Bool
     
//    @State private var category: String = "It contains offensive material"
    @State private var category: ReportAConcernCategory = .none
    @State private var description: String = ""
    
    var categories = ["It contains offensive material", "It's engaged in harassment", "Another reason"]
    
    @FocusState private var descriptionFocused: Bool
    
    var body: some View {
            
        NavigationStack {
            Form {
                Section(header: Text(getHeadlineText(content_type: content_type))) {
                    Picker("Select a category", selection: $category) {
                        Text("").tag(ReportAConcernCategory.none)
                        Text("It's offensive").tag(ReportAConcernCategory.offensive)
                        Text("It's harassment").tag(ReportAConcernCategory.harassment)
                        Text("Other").tag(ReportAConcernCategory.other)
                    }
                    .pickerStyle(.menu).foregroundColor(Color("text.black"))
                }
                
                Section(header: Text("Additional details"), footer: Text("Your report is anonymous and will be reviewed within the next day. You can also email me at colin@swearby.app if necessary.")) {
                    TextField("Please add any relevant details", text: $description, axis: .vertical)
                        .textFieldStyle(.plain)
                        .font(.system(size: 17, weight: .regular))
                        .focused($descriptionFocused)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .submitLabel(.return)
                        .frame(minHeight: 80, alignment: .topLeading)
                }
                
                
                Section {
                    
                    Button {
                        
                        ReportAConcernVM().sendReport(content_type: content_type, content_ID: reportContentID, category: category.rawValue, description: description, reported_by_user_id: reported_by_user_id)
                        
                        isReportConcernHalfSheetPresented = false
                        
                    } label: {
                        
                        HStack {
                            Spacer()
                            Text("Submit Report")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor( (description.isEmpty || category == .none) ? .gray.opacity(0.4) : .blue)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .background(.white)
                        .padding(.horizontal)
                    }.disabled(description.isEmpty || category == .none)
                }
                
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                        isReportConcernHalfSheetPresented = false
                        
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .navigationTitle("Report a Concern")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
            

        
    }
    
    var sheet_header: some View {
            
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                isReportConcernHalfSheetPresented = false
            } label: {
                Text("Cancel")
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .foregroundColor(.blue)
                    .frame(height: 40)
            }
            
            Spacer()
            
            Text("Report a Concern")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .frame(height: 40)
            
            Spacer()
            
            Button {
                // submit the concern to the DB

                isReportConcernHalfSheetPresented = false
                
            } label: {
                Text("Cancel")
                    .font(.system(size: 20, weight: description.isEmpty ? .regular : .semibold, design: .rounded))
                    .foregroundColor(description.isEmpty ? Color("TextFieldGray") : .gray)
                    .frame(height: 40)
            }.disabled(description.isEmpty)
        }
        .padding(.horizontal)
        .frame(height: 40)
        .padding(.top)
    }
    
    
    private func getHeadlineText(content_type: String) -> String {
        
        if content_type == "COMMENT" {
            return "Why does this comment concern you?"
        } else if content_type == "REQUEST" {
            return "Why does this request concern you?"
        } else if content_type == "POST" {
            return "Why does this post concern you?"
        } else if content_type == "MESSAGE" {
            return "Why does this message concern you?"
        } else if content_type == "CODE" {
            return "Why does this referral code concern you?"
        } else {
            return "Why does this code concern you?"
        }
    }
}
