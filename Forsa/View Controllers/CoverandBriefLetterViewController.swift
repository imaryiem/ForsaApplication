//
//  CoverandBriefLetterViewController.swift
//  Forsa
//
//  Created by BP-36-201-25 on 27/12/2024.
//

import UIKit
import Firebase

class CoverandBriefLetterViewController: UIViewController, UIDocumentPickerDelegate {
    
    // Firestore Database Reference
    let db = Firestore.firestore()
    
    @IBOutlet weak var BriefLetter: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Save Brief Letter Function
    @IBAction func saveBriefLetterTapped(_ sender: UIButton) {
        // Ensure the text is not empty
        guard let briefLetterText = BriefLetter.text, !briefLetterText.isEmpty else {
            showAlert(message: "Please write a brief letter before saving.")
            return
        }
        
        
        // Data to save
        let data: [String: Any] = [
            "BriefLetter": briefLetterText
        ]
        
        // Save to a fixed document in the "BriefLetter" collection
        db.collection("BriefLetter").document("briefLetterDoc").setData(data) { error in
            if let error = error {
                print("Error saving brief letter: \(error.localizedDescription)")
                self.showAlert(message: "Failed to save the brief letter.")
            } else {
                self.showAlert(message: "Brief letter saved successfully!")
            }
        }
    }
    
    // Fetch Brief Letter Function
    func fetchBriefLetter() {
        // Fetch the fixed document from the "BriefLetter" collection
        db.collection("BriefLetter").document("briefLetterDoc").getDocument { (document, error) in
            if let error = error {
                print("Error fetching brief letter: \(error.localizedDescription)")
                self.showAlert(message: "Failed to fetch the brief letter.")
                return
            }
            
            if let document = document, document.exists {
                // Extract and display the brief letter
                let data = document.data()
                let briefLetterText = data?["BriefLetter"] as? String ?? "No brief letter found."
                self.BriefLetter.text = briefLetterText
                print("Brief letter fetched successfully: \(briefLetterText)")
            } else {
                print("Document does not exist.")
                self.BriefLetter.text = ""
            }
        }
    }
    
    // Show Alert Helper
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    
    
    // Show an alert
    @IBAction func submitApplicationistappied(_ sender: UIButton) {
        
        // Show an alert
        showAlert(title: "Success", message: "Your Application has been successfully sone.")
        
        
        // Function to display an alert
        func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            // Present the alert
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
}
