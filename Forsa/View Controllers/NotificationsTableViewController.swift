//
//  NotificationsTableViewController.swift
//  Forsa
//
//  Created by BP-36-201-14 on 22/12/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class NotificationsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblJob2: UILabel!
    @IBOutlet weak var lblDesc2: UILabel!
    @IBOutlet weak var lblJob3: UILabel!
    @IBOutlet weak var lblDesc3: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Fetch notification data when the view loads
        fetchNotificationData()
    }
    
    // Method to fetch notification data from Firestore
    func fetchNotificationData() {
        let db = Firestore.firestore()
        
        // Access the "Notifications" collection
        db.collection("Notifications").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching notifications: \(error.localizedDescription)")
                return
            }
            
            // Ensure there are documents to process
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No Notifications found.")
                return
            }
            // Update the UI elements with the fetched data
            if documents.count > 0 {
                let notification1 = documents[0].data()
                self.lblJob.text = notification1["Job"] as? String ?? "No Job"
                self.lblDesc.text = notification1["Description"] as? String ?? "No Description"
            }
            if documents.count > 1 {
                let notification2 = documents[1].data()
                self.lblJob2.text = notification2["Job"] as? String ?? "No Job"
                self.lblDesc2.text = notification2["Description"] as? String ?? "No Description"
            }
            if documents.count > 2 {
                let notification3 = documents[2].data()
                self.lblJob3.text = notification3["Job"] as? String ?? "No Job"
                self.lblDesc3.text = notification3["Description"] as? String ?? "No Description"
            }
        }
    }
}
