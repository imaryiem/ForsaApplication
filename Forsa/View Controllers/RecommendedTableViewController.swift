//
//  RecommendedTableViewController.swift
//  Forsa
//
//  Created by BP-36-208-05 on 26/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RecommendedTableViewController: UITableViewController, FilterDelegate {
    func applyFilter(filters: [String : String]) {
      
    }
    

    // Variables for storing jobs
        var jobs: [[String: String]] = [] // All jobs fetched from Firestore
    
        var filteredJobs: [[String: String]] = [] // Jobs matching search criteria
    
    var bookmarkedJobs: [String] = [] // List of bookmarked job IDs

        let db = Firestore.firestore()

    
    @IBOutlet weak var lblJobTitle: UILabel!
    
    @IBOutlet weak var lblCompanyName: UILabel!

    @IBOutlet weak var viewDetailsButton1: UIButton!
  
    @IBAction func viewDetailsButton(_ sender: UIButton) {
        let jobIndex = sender.tag
             guard jobIndex < filteredJobs.count else { return }

        
           // Retrieve the document ID for the selected job
             let jobID = filteredJobs[jobIndex]["JobID"]
             print("Navigating to details for jobID: \(jobID ?? "No ID")")
        
        
             performSegue(withIdentifier: "showDetails", sender: jobID)
         }
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBAction func bookmarkButton(_ sender: UIButton) { let jobIndex = sender.tag
        guard jobIndex < jobs.count else { return }
        
        let job = jobs[jobIndex]
        if let jobID = job["JobID"], bookmarkedJobs.contains(jobID) {
            removeJobFromFirestore(jobID: jobID)
        } else {
            saveJobToFirestore(job: job)
        }
        
    }
    
    @IBOutlet weak var Image: UIImageView!
    
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if segue.identifier == "showDetails" {
                 let detailsVC = segue.destination as! DetailsViewController
                 detailsVC.jobID = sender as? String
             }
         }

         override func viewDidLoad() {
             super.viewDidLoad()

             // Fetch user details and then fetch recommended jobs
             fetchUserDetails { [weak self] userDetails in
                 self?.fetchRecommendedJobs(userDetails: userDetails) { jobs in
                     self?.displayJobs(jobs: jobs) // Display recommended jobs
                 }
             }
         }


         func fetchRecommendedJobs(userDetails: [String: String], completion: @escaping ([[String: String]]) -> Void) {
             let db = Firestore.firestore()
             var query: Query = db.collection("JobDetails")

             // Apply filters based on user details
             if let industry = userDetails["PreferredIndustries"] {
                 query = query.whereField("Industry", isEqualTo: industry)
             }
             if let location = userDetails["Country"] {
                 query = query.whereField("Location", isEqualTo: location)
             }
             if let jobType = userDetails["JobType"] {
                 query = query.whereField("Type", isEqualTo: jobType)
             }
             if let years = userDetails["ExperienceLevel"] {
                 query = query.whereField("Years", isEqualTo: years)
             }

             query.getDocuments { (querySnapshot, error) in
                 if let error = error {
                     print("Error fetching job listings: \(error.localizedDescription)")
                     return
                 }

                 guard let documents = querySnapshot?.documents else {
                     print("No job listings found.")
                     return
                 }

                 // Map document data to job array
                 self.jobs = documents.compactMap { doc in
                     var jobData: [String: String] = [:]
                     let data = doc.data()

                     jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                     jobData["Company"] = data["Company"] as? String ?? "No Company"
                     jobData["Location"] = data["Location"] as? String ?? "No Location"
                     jobData["Years"] = data["Years"] as? String ?? "No Experience"
                     jobData["Type"] = data["Type"] as? String ?? "No Type"
                     jobData["Industry"] = data["Industry"] as? String ?? "No Industry"
                     jobData["JobID"] = doc.documentID // Add the document ID

                     return jobData
                 }

                 completion(self.jobs)
             }
         }

    
    // Display the job based on the logged in user
         func fetchUserDetails(completion: @escaping ([String: String]) -> Void) {
             guard let currentUser = Auth.auth().currentUser else {
                 print("No user is logged in.")
                 return
             }
             
             
             // Dynamically get the logged-in user's ID
             let userID = currentUser.uid

             let db = Firestore.firestore()
             db.collection("users").document(userID).getDocument { (document, error) in
                 if let error = error {
                     print("Error fetching user details: \(error.localizedDescription)")
                     return
                 }

                 guard let userData = document?.data() as? [String: String] else {
                     print("User data not found.")
                     return
                 }

                 completion(userData)
             }
         }
    
    // Bookmark the job and save it in firebasefirestore
    func saveJobToFirestore(job: [String: String]) {
           guard let jobID = job["JobID"], let jobTitle = job["Job"], let companyName = job["Company"] else { return }

           let savedJob = ["Job": jobTitle, "Company": companyName]

           db.collection("SavedJobs").document(jobID).setData(savedJob) { error in
               if let error = error {
                   print("Error saving job: \(error.localizedDescription)")
               } else {
                   print("Job saved successfully.")
                   self.bookmarkedJobs.append(jobID)
                   self.updateUI()
               }
           }
       }

    
    // Remove the Bookmark and remove the job from firebasefirestore
    func removeJobFromFirestore(jobID: String) {
            db.collection("SavedJobs").document(jobID).delete { error in
                if let error = error {
                    print("Error removing job: \(error.localizedDescription)")
                } else {
                    print("Job removed successfully.")
                    if let index = self.bookmarkedJobs.firstIndex(of: jobID) {
                        self.bookmarkedJobs.remove(at: index)
                        self.updateUI()
                    }
                }
            }
        }
    

    func updateUI() {
          // Pair each set of labels and buttons
          let labelsAndButtons: [(UILabel?, UILabel?, UIButton?, UIButton?)] = [
              (lblJobTitle, lblCompanyName, viewDetailsButton1, bookmarkButton)
            
          ]

          for (index, tuple) in labelsAndButtons.enumerated() {
                  if index < filteredJobs.count {
                      let job = filteredJobs[index]
                  tuple.0?.text = job["Job"] ?? "No Job Title"
                  tuple.1?.text = job["Company"] ?? "No Company"
                  tuple.2?.tag = index

                  if let bookmarkButton = tuple.3 {
                      let jobID = job["JobID"] ?? ""
                      let iconName = bookmarkedJobs.contains(jobID) ? "bookmark.fill" : "bookmark"
                      bookmarkButton.setImage(UIImage(systemName: iconName), for: .normal)
                  }
              } else {
                  tuple.0?.text = ""
                  tuple.1?.text = ""

                  if let bookmarkButton = tuple.3 {
                      bookmarkButton.setImage(nil, for: .normal) // Set to no image
                  }
              }
          }
      }
           func displayJobs(jobs: [[String: String]]) {
               filteredJobs = jobs // Store filtered jobs for button action

               // Display the first job (adjust as needed for multiple jobs)
               if let firstJob = jobs.first {
                   lblJobTitle.text = firstJob["Job"] ?? "No Job Title"
                   lblCompanyName.text = firstJob["Company"] ?? "No Company"
                   viewDetailsButton1.tag = 0
                   viewDetailsButton1.isHidden = false
               } else {
                   lblJobTitle.text = "No Job Title"
                   lblCompanyName.text = "No Company"
                   viewDetailsButton1.isHidden = true
                   bookmarkButton.isHidden = true
                   Image.isHidden = true
               }
           }
    
    
    
    func setUIElementsVisibility(isHidden: Bool) {
        
           bookmarkButton.isHidden = isHidden
        Image.isHidden = isHidden
       }
    
       }
