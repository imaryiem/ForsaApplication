//
//  CurrentOccupationDetailsViewController.swift
//  Forsa
//
//  Created by BP-36-201-25 on 27/12/2024.
//

import UIKit
import Firebase
class CurrentOccupationDetailsViewController: UITableViewController {

    
    @IBOutlet weak var JobTitle: UITextField!
    @IBOutlet weak var JobField: UITextField!
    @IBOutlet weak var CompanyOrMinistiryName: UITextField!
    @IBOutlet weak var JobLocation: UITextField!
    @IBOutlet weak var EndDate: UITextField!
    @IBOutlet weak var StartDate: UITextField!
    @IBOutlet weak var Description: UITextField!
    

    @IBAction func NextButtonTapped(_ sender: UIButton) {
        // Validate required fields
           guard let jobTitle = JobTitle.text, !jobTitle.isEmpty,
                 let startDate = StartDate.text, !startDate.isEmpty,
                 let endDate = EndDate.text, !endDate.isEmpty,
                 let jobField = JobField.text, !jobField.isEmpty,
                 let companyOrMinistryName = CompanyOrMinistiryName.text, !companyOrMinistryName.isEmpty,
                 let jobLocation = JobLocation.text, !jobLocation.isEmpty else {
               // Show alert for missing required fields
               showMissingFieldsAlert()
               return
           }
           
           // If all required fields are filled, save the data
           saveDataToFirebase()

    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrentOccupationDetailsData()
    }
    
    // Firestore Database
    let db = Firestore.firestore()
    
    // Save Data to Firebase
    func saveDataToFirebase() {
        // Safely unwrap optional fields
           let description = Description.text ?? "" // Optional field defaults to empty string if not provided

           // Create a dictionary with the data to save
           let dataToSave: [String: Any] = [
               "Job Title": JobTitle.text ?? "",
               "Start Date": StartDate.text ?? "",
               "End Date": EndDate.text ?? "",
               "Job Field": JobField.text ?? "",
               "Company-Ministry Name": CompanyOrMinistiryName.text ?? "",
               "Job Location": JobLocation.text ?? "",
               "Description": description // Description is optional
           ]

           // Save the data to Firebase
           db.collection("CurrentOccupationDetails").addDocument(data: dataToSave) { error in
               if let error = error {
                   print("Error saving data: \(error.localizedDescription)")
                   self.showAlert(message: "Failed to save data. Please try again.")
               } else {
                   print("Data saved successfully!")
                   self.showAlert(message: "Data saved successfully!")
                   self.clearForm()
               }
           }
       }
                

    
    func clearForm() {
        JobTitle.text = ""
        StartDate.text = ""
        EndDate.text = ""
        JobField.text = ""
        CompanyOrMinistiryName.text = ""
        JobLocation.text = ""
        Description.text = ""
        }

    func showMissingFieldsAlert() {
          var missingFields: [String] = []
            if JobTitle.text?.isEmpty ?? true { missingFields.append("Job Title") }
            if StartDate.text?.isEmpty ?? true { missingFields.append("Start Date") }
            if EndDate.text?.isEmpty ?? true { missingFields.append("End Date") }
            if JobField.text?.isEmpty ?? true { missingFields.append("Job Field") }
            if CompanyOrMinistiryName.text?.isEmpty ?? true { missingFields.append("Company-Ministry Name") }
            if JobLocation.text?.isEmpty ?? true { missingFields.append("Job Location") }
        
          let missingFieldsList = missingFields.joined(separator: ", ")

          let alert = UIAlertController(
              title: "Incomplete Form",
              message: "Please complete the following required fields: \(missingFieldsList).",
              preferredStyle: .alert
          )
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
    
    // MARK: - Helper Methods
      func showAlert(message: String) {
          let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
    
    func fetchCurrentOccupationDetailsData() {
        db.collection("CurrentOccupationDetails").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                self.showAlert(message: "Failed to fetch data. Please try again.")
            } else {
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No documents found in Experience collection")
                    return
                }

                for document in documents {
                    let data = document.data()
                    let JobTitle = data["Job Title"] as? String ?? "N/A"
                    let startDate = data["Start Date"] as? String ?? "N/A"
                    let EndDate = data["End Date"] as? String ?? "N/A"
                    let JobField = data["Job Field"] as? String ??
                    data["Job Field"] as? String ?? "N/A"
                    let CompanyOrMinistiryName = data["Company-Ministry Name"] as? String ?? "N/A"
                    let JobLocation = data["Job Location"] as? String ?? "N/A"
                    let Description = data["Description"] as? String ?? "N/A"


                    print("""
                    Document ID: \(document.documentID)
                    Job Title: \(JobTitle)
                    Start Date: \(startDate)
                    End Date: \(EndDate)
                    Job Field: \(JobField)
                    Start Company-Ministry Name: \(CompanyOrMinistiryName)
                    Job Location: \(JobLocation)
                    Description: \(Description)
                    
                    """)
                }
            }
        }
       
            }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
