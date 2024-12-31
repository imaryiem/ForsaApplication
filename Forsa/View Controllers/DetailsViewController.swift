//
//  DetailsViewController.swift
//  Forsa
//
//  Created by BP-36-201-14 on 22/12/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class DetailsViewController: UIViewController {

    var jobID: String? // Job ID passed from RecommendedTableViewController

    
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblYears: UILabel!
    
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var lblExpectations: UILabel!
    
    @IBOutlet weak var lblQualifications: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    
    
    @IBOutlet weak var lblIndustry: UILabel!
    

    override func viewDidLoad() {
           super.viewDidLoad()
           if let jobID = jobID {
               fetchJobDetails(jobID: jobID)
           }
       }

     // Fetch all jobs details from Firestore
       func fetchJobDetails(jobID: String) {
           let db = Firestore.firestore()
           db.collection("JobDetails").document(jobID).getDocument { (document, error) in
               if let error = error {
                   print("Error fetching job details: \(error.localizedDescription)")
                   return
               }

               guard let jobData = document?.data() else {
                   print("No job details found.")
                   return
               }

               // Update UI with job details
               self.lblJob.text = jobData["Job"] as? String ?? "No Job Title"
               self.lblCompany.text = jobData["Company"] as? String ?? "No Company"
               self.lblLocation.text = jobData["Location"] as? String ?? "No Location"
               self.lblYears.text = jobData["Years"] as? String ?? "No Experience"
               self.lblType.text = jobData["Type"] as? String ?? "No Type"
               self.lblIndustry.text = jobData["Industry"] as? String ?? "No Industry"
               self.lblDesc.text = jobData["JobDesc"] as? String ?? "No Description"
               self.lblExpectations.text = jobData["JobExpectations"] as? String ?? "No Expectations"
               self.lblQualifications.text = jobData["Qualifications"] as? String ?? "No Qualifications"
               self.lblSalary.text = jobData["Average Salary"] as? String ?? "No Salary Info"
           }
       }
   }
