//
//  ReportAConcernVM.swift
//  SwearBy
//
//  Created by Colin Power on 6/20/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class ReportAConcernVM: ObservableObject, Identifiable {
    
    private var db = Firestore.firestore()
    
    func sendReport(content_type: String, content_ID: String, category: String, description: String, reported_by_user_id: String) {
        
        db.collection("report_a_concern").document()
            .setData([
                "content_type": content_type,
                "content_ID": content_ID,
                "category": category,
                "description": description,
                "reported_by_user_id": reported_by_user_id,
                "timestamp": getTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document for REPORT CONCERN - sendReport: \(err)")
                } else {
                    print("ERROR? \(err)")
                }
            }
    }
}
