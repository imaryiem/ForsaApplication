//
//  ExperienceViewController.swift
//  Forsa
//
//  Created by BP-36-201-14 on 27/12/2024.
//

import UIKit
import Firebase


class ExperienceViewController: UITableViewController {

    //Outlets
    @IBOutlet weak var TrainingTopic: UITextField!
    @IBOutlet weak var InstitutionName: UITextField!
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var StartDate: UITextField!
    @IBOutlet weak var CompletionDate: UITextField!


    // Firestore Database
        let db = Firestore.firestore()

    // Save Data to Firebase
        func saveDataToFirebase() {
            // Validate input
            guard let institutionName = InstitutionName.text, !institutionName.isEmpty,
                  let startDate = StartDate.text, !startDate.isEmpty,
                  let completionDate = CompletionDate.text, !completionDate.isEmpty,
                  let trainingTopic = TrainingTopic.text, !trainingTopic.isEmpty else {
                // Check which fields are empty and show a detailed alert
                showMissingFieldsAlert()
                return
            }

        // Create a dictionary with the data to save
             let dataToSave: [String: Any] = [
                 "Institution Name": institutionName,
                 "Start Date": startDate,
                 "Completion Date": completionDate,
                 "Training Topic": trainingTopic
             ]
              
        // Save the data to Firebase
               db.collection("Experience").addDocument(data: dataToSave) { error in
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

              
 
   
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        saveDataToFirebase()

    }
    // Ensure the applicantID is available
        // Update: Added a guard statement to validate `applicantID`
           
    override func viewDidLoad() {
            super.viewDidLoad()

            // Fetch existing experience data
        fetchExperienceData()
        }

    func clearForm() {
            InstitutionName.text = ""
            StartDate.text = ""
            CompletionDate.text = ""
            TrainingTopic.text = ""
        }

    func showMissingFieldsAlert() {
          var missingFields: [String] = []
          if InstitutionName.text?.isEmpty ?? true { missingFields.append("Institution Name") }
          if StartDate.text?.isEmpty ?? true { missingFields.append("Start Date") }
          if CompletionDate.text?.isEmpty ?? true { missingFields.append("Completion Date") }
          if TrainingTopic.text?.isEmpty ?? true { missingFields.append("Training Topic") }

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

    func fetchExperienceData() {
        db.collection("Experience").getDocuments { snapshot, error in
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
                    let institutionName = data["Institution Name"] as? String ?? "N/A"
                    let startDate = data["Start Date"] as? String ?? "N/A"
                    let completionDate = data["Completion Date"] as? String ?? "N/A"
                    let trainingTopic = data["Training topic"] as? String ??
                    data["Training Topic"] as? String ?? "N/A"

                    print("""
                    Document ID: \(document.documentID)
                    Institution Name: \(institutionName)
                    Start Date: \(startDate)
                    Completion Date: \(completionDate)
                    Training Topic: \(trainingTopic)
                    """)
                }
            }
        }
       
            }
    
    // Show an alert
    @IBAction func uploadistappied(_ sender: UIButton) {
    
        // Show an alert
            showAlert(title: "Success", message: "Your file has been successfully uploaded.")
        }

        // Function to display an alert
        func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            // Present the alert
            self.present(alertController, animated: true, completion: nil)
        }
    
    
    
        }

        

