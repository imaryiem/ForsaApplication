//
//  EducationViewController.swift
//  Forsa
//
//  Created by BP-36-201-25 on 27/12/2024.
//

import UIKit
import Firebase

class EducationViewController: UITableViewController {

    @IBOutlet weak var EducationLevel: UITextField!
    @IBOutlet weak var Universityorinstitution: UITextField!
    @IBOutlet weak var LocationtheCountry: UITextField!
    @IBOutlet weak var City: UITextField!
    @IBOutlet weak var GraduationDate: UITextField!
    @IBOutlet weak var FieldofStudyMajor: UITextField!
  
    
    // Firestore Database
        let db = Firestore.firestore()

    // Save Data to Firebase
        func saveDataToFirebase() {
            // Validate input
            guard let EducationLevel = EducationLevel.text, !EducationLevel.isEmpty,
                  let UUniversityorinstitution = Universityorinstitution.text, !UUniversityorinstitution.isEmpty,
                  let LocationtheCountry = LocationtheCountry.text, !LocationtheCountry.isEmpty,
                  let City = City.text, !City.isEmpty,
                  let GraduationDate = GraduationDate.text, !GraduationDate.isEmpty,
                    let FieldofStudyMajor = FieldofStudyMajor.text, !FieldofStudyMajor.isEmpty
            else {
                // Check which fields are empty and show a detailed alert
                showMissingFieldsAlert()
                return
            }

        // Create a dictionary with the data to save
             let dataToSave: [String: Any] = [
                 "Education Level": EducationLevel,
                 "University or institution": UUniversityorinstitution,
                 "Location(Country)": LocationtheCountry,
                 "City": City,
                 "Field of Study(Major)" : FieldofStudyMajor,
                 "Graduation Date": GraduationDate
             ]
              
        // Save the data to Firebase
               db.collection("Education").addDocument(data: dataToSave) { error in
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

            // Fetch existing Education data
        fetchEducationData()
        }

    func clearForm() {
        EducationLevel.text = ""
        Universityorinstitution.text = ""
        LocationtheCountry.text = ""
        City.text = ""
        FieldofStudyMajor.text = ""
        GraduationDate.text = ""
        
        }

    func showMissingFieldsAlert() {
          var missingFields: [String] = []
          if EducationLevel.text?.isEmpty ?? true { missingFields.append("Education Level") }
          if Universityorinstitution.text?.isEmpty ?? true { missingFields.append("University or institution") }
          if LocationtheCountry.text?.isEmpty ?? true { missingFields.append("Location(Country)") }
          if City.text?.isEmpty ?? true { missingFields.append("City") }
        if FieldofStudyMajor.text?.isEmpty ?? true { missingFields.append("Field of Study(Major)") }
        if GraduationDate.text?.isEmpty ?? true { missingFields.append("Graduation Date") }

        
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

    func fetchEducationData() {
        db.collection("Education").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                self.showAlert(message: "Failed to fetch data. Please try again.")
            } else {
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No documents found in Education collection")
                    return
                }

                for document in documents {
                    let data = document.data()
                    let educationLevel = data["Education Level"] as? String ?? "N/A"
                    let universityOrInstitution = data["University or institution"] as? String ?? "N/A"
                    let locationTheCountry = data["Location the Country"] as? String ?? "N/A"
                    let city = data["City"] as? String ?? "N/A"
                    let graduationDate = data["Graduation Date"] as? String ?? "N/A"
                    let fieldOfStudyMajor = data["Field of Study Major"] as? String ?? "N/A"

                    print("""
                    Document ID: \(document.documentID)
                    Education Level: \(educationLevel)
                    University or Institution: \(universityOrInstitution)
                    Location (Country): \(locationTheCountry)
                    City: \(city)
                    Graduation Date: \(graduationDate)
                    Field of Study/Major: \(fieldOfStudyMajor)
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

   


        


  
    

