//
//  CreateTableViewController.swift
//  Forsa
//
//  Created by BP-36-201-18 on 25/12/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CreateTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet weak var CVname: UITextField!
    @IBOutlet weak var Fullname: UITextField!
    @IBOutlet weak var ContactInfo: UITextField!
    @IBOutlet weak var Degree: UITextField!
    @IBOutlet weak var Yearofgraduation: UITextField!
    @IBOutlet weak var Certification: UITextField!
    @IBOutlet weak var Skill: UITextField!
    @IBOutlet weak var Workofexperince: UITextField!
    @IBOutlet weak var Comanyname: UITextField!
    @IBOutlet weak var Duration: UITextField!
    
    
    
    @IBAction func CreateCvButton(_ sender: Any) {
    if areFieldsEmpty() {
    showErrorAlert(message: "Please fill in all fields before submitting.")
               } else {
    saveCvInfoToFirestore() // Save CV info to Firestore
    showAlertView2() // Show success alert
               }
    }

    // Show success alert
    func showAlertView2() {
        let alert = UIAlertController(
            title: "CV Created",
            message: "CV successfully created.",
            preferredStyle: .alert
        )
        
        // Close action that performs the segue
        let closeAction = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            // Perform the segue after the alert is closed
            self?.performSegue(withIdentifier: "goToNextPage", sender: nil)
        }
        
        alert.addAction(closeAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    // Check if any fields are empty
    func areFieldsEmpty() -> Bool {
        return CVname.text?.isEmpty ?? true ||
               Fullname.text?.isEmpty ?? true ||
               ContactInfo.text?.isEmpty ?? true ||
               Degree.text?.isEmpty ?? true ||
               Yearofgraduation.text?.isEmpty ?? true ||
               Certification.text?.isEmpty ?? true ||
               Skill.text?.isEmpty ?? true ||
               Workofexperince.text?.isEmpty ?? true ||
               Comanyname.text?.isEmpty ?? true ||
               Duration.text?.isEmpty ?? true
    }

    // In CreateTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToNextPage" {
    if let previewVC = segue.destination as? PreviewPageViewController {
    // Pass the documentID to the PreviewPageViewController
    previewVC.documentID = self.documentID
            }
        }
    }
    
    func goToNextPage() {
        if !areFieldsEmpty() {
            performSegue(withIdentifier: "goToNextPage", sender: nil)
        } else {
            print("Fields are empty. Navigation prevented.")
        }
    }
    

    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Define a property to store the document ID
    var documentID: String?
    
    func saveCvInfoToFirestore() {
        guard let cvName = CVname.text,
              let fullName = Fullname.text,
              let contactInfo = ContactInfo.text,
              let degree = Degree.text,
              let yearOfGraduation = Yearofgraduation.text,
              let certification = Certification.text,
              let skills = Skill.text,
              let workOfExperience = Workofexperince.text,
              let companyName = Comanyname.text,
              let duration = Duration.text else {
            showErrorAlert(message: "Please fill in all fields before submitting.")
                   return
        }

        // Database reference
        let db = Firestore.firestore()
        // Firestore will generate a document ID
        let newDocRef = db.collection("CV").document()

        // Data to save
        let cvData: [String: Any] = [
            "docId": newDocRef.documentID,
            "CVName": cvName,
            "FullName": fullName,
            "ContactInfo": contactInfo,
            "Degree": degree,
            "YearOfGraduation": yearOfGraduation,
            "Certification": certification,
            "Skills": skills,
            "WorkOfExperience": workOfExperience,
            "CompanyName": companyName,
            "Duration": duration
        ]

        // Save data
        newDocRef.setData(cvData) { error in
        if let error = error {
        print("Error saving CV data: \(error.localizedDescription)")
        self.showErrorAlert(message: "Error saving CV data: \(error.localizedDescription)")
            } else {
        print("CV data saved successfully: \(newDocRef.documentID)")
        self.documentID = newDocRef.documentID // Store the document ID
            }
                }
        

            }
        }
