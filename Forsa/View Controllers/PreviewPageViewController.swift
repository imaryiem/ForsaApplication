//
//  PreviewPageViewController.swift
//  Forsa
//
//  Created by BP-36-201-18 on 25/12/2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PreviewPageViewController: UIViewController {
    
    var documentID: String? // Store the document ID here
    var cvData: [String: Any]? // Declare cvData to store the fetched CV data
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var CVnameLabel: UILabel!
    @IBOutlet weak var FullnameLabel: UILabel!
    @IBOutlet weak var ContactInfoLabel: UILabel!
    @IBOutlet weak var DegreeLabel: UILabel!
    @IBOutlet weak var YearofgraduationLabel: UILabel!
    @IBOutlet weak var CertificationsLabel: UILabel!
    @IBOutlet weak var SkillsLabel: UILabel!
    @IBOutlet weak var Workofexperince: UILabel!
    @IBOutlet weak var CompanynameLabel: UILabel!
    @IBOutlet weak var DurationLabel: UILabel!
    
    @IBAction func deleteButton(_ sender: Any) {
        showAlertView() // Show confirmation alert for deletion
        }
    
    @IBAction func exportToPdfButton(_ sender: Any) {
    // Fetch CV data and generate PDF
    if let documentID = self.documentID {
    fetchCV(documentID: documentID) { [weak self] in
    if let pdfURL = self?.generateCVPDF() {
    // Share the generated PDF
    self?.sharePDF(pdfURL: pdfURL)
                        } else {
    self?.showErrorAlert(message: "Failed to generate PDF.")
                        }
                    }
                }
            }
    
    @IBAction func saveAsButton(_ sender: Any) {
    // Ensure cvData is not nil before saving
    guard let cvData = self.cvData else {
    showErrorAlert(message: "No CV data to save.")
    return
               }
    print("CV Data: \(cvData)") // Debug log
    // Save the CV locally
    saveCvLocally(cvData: cvData)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Fetch CV data if documentID is available
    if let documentID = self.documentID {
    fetchCV(documentID: documentID) {
    // Do something after data is fetched, if needed
                    }
    } else {
    print("Document ID is nil.")
                }

            }
    
    // Show alert to confirm deletion
    func showAlertView() {
    let alert = UIAlertController(
                title: "Delete CV?",
                message: "This CV will be permanently deleted.",
                preferredStyle: .alert
            )
            
            // Delete action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.handleDeleteAction()
            }
            
            // Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            // Present the alert
            present(alert, animated: true, completion: nil)
        }
        
        // Handle delete action
        func handleDeleteAction() {
            guard let documentID = self.documentID else {
                showErrorAlert(message: "No document ID found.")
                return
            }
            
            let db = Firestore.firestore()
            db.collection("CV").document(documentID).delete { error in
            if let error = error {
            self.showErrorAlert(message: "Error deleting CV: \(error.localizedDescription)")
                } else {
            self.showErrorAlert(message: "CV deleted successfully.")
            // Optionally, navigate back or update the UI
                }
            }
        }
        
        // Function to fetch CV data from Firestore
        func fetchCV(documentID: String, completion: @escaping () -> Void) {
            let db = Firestore.firestore()
            
            db.collection("CV").document(documentID).getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("CV document does not exist.")
                    return
                }
                
                let data = document.data()
                
                // Populate the labels with data
                DispatchQueue.main.async {
                    self.CVnameLabel.text = data?["CVName"] as? String ?? "N/A"
                    self.FullnameLabel.text = data?["FullName"] as? String ?? "N/A"
                    self.ContactInfoLabel.text = data?["ContactInfo"] as? String ?? "N/A"
                    self.DegreeLabel.text = data?["Degree"] as? String ?? "N/A"
                    self.YearofgraduationLabel.text = data?["YearOfGraduation"] as? String ?? "N/A"
                    self.CertificationsLabel.text = data?["Certification"] as? String ?? "N/A"
                    self.SkillsLabel.text = data?["Skills"] as? String ?? "N/A"
                    self.Workofexperince.text = data?["WorkOfExperience"] as? String ?? "N/A"
                    self.CompanynameLabel.text = data?["CompanyName"] as? String ?? "N/A"
                    self.DurationLabel.text = data?["Duration"] as? String ?? "N/A"
                    self.cvData = data // Save fetched data
                    completion() // Call completion handler once data is populated

                }
            }
        }
        
        // Function to show error alert with a message
        func showErrorAlert(message: String) {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            
            // Add action with a non-optional closure
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
    

    
    // Save CV locally using UserDefaults
    func saveCvLocally(cvData: [String: Any]) {
    var savedCVs = UserDefaults.standard.dictionary(forKey: "savedCVs") as? [String: [String: Any]] ?? [:]
    // Save the CV data using a unique name or identifier
    if let cvName = cvData["CVName"] as? String {
        savedCVs[cvName] = cvData
        UserDefaults.standard.set(savedCVs, forKey: "savedCVs")
        print("Saved CVs: \(savedCVs)") // Debug log
        showErrorAlert(message: "CV saved locally.")
           } else {
        showErrorAlert(message: "Failed to save CV. No CV name found.")
           }
       }

    // Function to generate a PDF from the CV data
    func generateCVPDF() -> URL? {
        // Create a file URL for the PDF to be saved
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentDirectory.appendingPathComponent("CV.pdf")
        
        // Define the correct A4 page size in points (595 x 842)
        let pdfPageBounds = CGRect(x: 0, y: 0, width: 595, height: 842)
        
        // Create a renderer for generating the PDF
        let renderer = UIGraphicsPDFRenderer(bounds: pdfPageBounds)
        
        do {
            try renderer.writePDF(to: pdfURL, withActions: { (context) in
                context.beginPage()
                
                // Define fonts and colors
                let titleFont = UIFont.boldSystemFont(ofSize: 18)
                let textFont = UIFont.systemFont(ofSize: 12)
                let textColor = UIColor.black
                
                // Set margins and initial Y position
                let margin: CGFloat = 20
                var yPosition: CGFloat = margin
                
                // CV Name (Title)
                let titleText = CVnameLabel.text ?? "CV Name"
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: textColor
                ]
                let titleAttributedString = NSAttributedString(string: titleText, attributes: titleAttributes)
                titleAttributedString.draw(at: CGPoint(x: margin, y: yPosition))
                yPosition += 30
                
                // Full Name
                let fullNameText = "Full Name: \(FullnameLabel.text ?? "N/A")"
                let fullNameAttributes: [NSAttributedString.Key: Any] = [
                    .font: textFont,
                    .foregroundColor: textColor
                ]
                let fullNameAttributedString = NSAttributedString(string: fullNameText, attributes: fullNameAttributes)
                fullNameAttributedString.draw(at: CGPoint(x: margin, y: yPosition))
                yPosition += 20
                
                // Contact Info
                let contactInfoText = "Contact Info: \(ContactInfoLabel.text ?? "N/A")"
                let contactInfoAttributedString = NSAttributedString(string: contactInfoText, attributes: fullNameAttributes)
                contactInfoAttributedString.draw(at: CGPoint(x: margin, y: yPosition))
                yPosition += 20
                
                // Degree
                let degreeText = "Degree: \(DegreeLabel.text ?? "N/A")"
                let degreeAttributedString = NSAttributedString(string: degreeText, attributes: fullNameAttributes)
                degreeAttributedString.draw(at: CGPoint(x: margin, y: yPosition))
                yPosition += 20
                
                // Add other sections like Skills, Certifications, etc.
                let sections = [
                    ("Year of Graduation", YearofgraduationLabel.text),
                    ("Certifications", CertificationsLabel.text),
                    ("Skills", SkillsLabel.text),
                    ("Work Experience", Workofexperince.text),
                    ("Company Name", CompanynameLabel.text),
                    ("Duration", DurationLabel.text)
                ]
                
                for (title, value) in sections {
                    let sectionText = "\(title): \(value ?? "N/A")"
                    let sectionAttributedString = NSAttributedString(string: sectionText, attributes: fullNameAttributes)
                    sectionAttributedString.draw(at: CGPoint(x: margin, y: yPosition))
                    yPosition += 20
                }
                
                // Ensure that the content fits within the page bounds
                if yPosition > pdfPageBounds.height - margin {
                    context.beginPage() // Create a new page if content exceeds the current page
                    yPosition = margin
                }
                
            })
            return pdfURL
        } catch {
            print("Error generating PDF: \(error)")
            return nil
        }
    }


    // Function to share the generated PDF
        func sharePDF(pdfURL: URL) {
            let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            
            // Exclude unnecessary activity types
            activityViewController.excludedActivityTypes = [
                .addToReadingList,
                .assignToContact,
                .print,
                .postToFacebook
            ]
            
            // Present the share sheet
            present(activityViewController, animated: true, completion: nil)
        }
    
    
    func createPDFView() -> UIView? {
        // Create a UIView for the PDF content
        let pdfView = UIView(frame: CGRect(x: 0, y: 0, width: 612, height: 792))
        pdfView.backgroundColor = .white
        
        // Add labels and populate with CV data
        let cvNameLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 572, height: 30))
        cvNameLabel.text = CVnameLabel.text ?? "CV NAME"
        cvNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        cvNameLabel.textAlignment = .center
        pdfView.addSubview(cvNameLabel)
        
        // Full Name
        let fullNameLabel = UILabel(frame: CGRect(x: 20, y: 70, width: 572, height: 20))
        fullNameLabel.text = "Full Name: \(FullnameLabel.text ?? "N/A")"
        fullNameLabel.font = UIFont.systemFont(ofSize: 16)
        pdfView.addSubview(fullNameLabel)
        
        // Contact Info
        let contactInfoLabel = UILabel(frame: CGRect(x: 20, y: 100, width: 572, height: 20))
        contactInfoLabel.text = "Contact Info: \(ContactInfoLabel.text ?? "N/A")"
        contactInfoLabel.font = UIFont.systemFont(ofSize: 16)
        pdfView.addSubview(contactInfoLabel)
        
        // Degree
        let degreeLabel = UILabel(frame: CGRect(x: 20, y: 130, width: 572, height: 20))
        degreeLabel.text = "Degree: \(DegreeLabel.text ?? "N/A")"
        degreeLabel.font = UIFont.systemFont(ofSize: 16)
        pdfView.addSubview(degreeLabel)
        
        // Add other labels for Year of Graduation, Certifications, Skills, etc.
        let additionalLabels = [
            ("Year of Graduation", YearofgraduationLabel.text),
            ("Certifications", CertificationsLabel.text),
            ("Skills", SkillsLabel.text),
            ("Work of Experience", Workofexperince.text),
            ("Company Name", CompanynameLabel.text),
            ("Duration", DurationLabel.text)
        ]
        
        var yOffset = 160
        for (title, value) in additionalLabels {
            let label = UILabel(frame: CGRect(x: 20, y: yOffset, width: 572, height: 20))
            label.text = "\(title): \(value ?? "N/A")"
            label.font = UIFont.systemFont(ofSize: 16)
            pdfView.addSubview(label)
            yOffset += 30
        }
        
        return pdfView
    }
            

    // Save CV Data URL to Firestore
        func saveCvDataToFirestore(cvData: [String: Any], pdfURL: String) {
            var updatedCvData = cvData
            updatedCvData["pdfUrl"] = pdfURL
            updatedCvData["savedAt"] = Date()
            
            let db = Firestore.firestore()
            db.collection("CV").addDocument(data: updatedCvData) { error in
                if let error = error {
                    print("Error saving CV data to Firestore: \(error.localizedDescription)")
                    self.showErrorAlert(message: "Failed to save CV data to Firestore.")
                } else {
                    print("CV data saved to Firestore successfully.")
                    self.showErrorAlert(message: "CV saved successfully with PDF.")
                }
            }
        }

    }


        




