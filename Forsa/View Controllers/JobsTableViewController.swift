//
//  JobsTableViewController.swift
//  Forsa
//
//  Created by BP-36-201-14 on 22/12/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class JobsTableViewController: UITableViewController, UISearchBarDelegate, FilterDelegate {
  

    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblJobTitle2: UILabel!
    @IBOutlet weak var lblCompanyName2: UILabel!
    @IBOutlet weak var lblJobTitle3: UILabel!
    @IBOutlet weak var lblCompanyName3: UILabel!
    @IBOutlet weak var lblJobTitle4: UILabel!
    @IBOutlet weak var lblCompanyName4: UILabel!
    @IBOutlet weak var lblJobTitle5: UILabel!
    @IBOutlet weak var lblCompanyName5: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    @IBOutlet weak var viewDetailsButton1: UIButton!
    @IBOutlet weak var viewDetailsButton2: UIButton!
    @IBOutlet weak var viewDetailsButton3: UIButton!
    @IBOutlet weak var viewDetailsButton4: UIButton!
    @IBOutlet weak var viewDetailsButton5: UIButton!


   
    
    @IBAction func bookmarkButton2(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < jobs.count else { return }

        let job = jobs[jobIndex]
        if let jobID = job["JobID"], bookmarkedJobs.contains(jobID) {
            removeJobFromFirestore(jobID: jobID)
        } else {
            saveJobToFirestore(job: job)
        }
    }
    
    @IBAction func bookmarkButton3(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < jobs.count else { return }

        let job = jobs[jobIndex]
        if let jobID = job["JobID"], bookmarkedJobs.contains(jobID) {
            removeJobFromFirestore(jobID: jobID)
        } else {
            saveJobToFirestore(job: job)
        }
    }
    @IBAction func bookmarkButton4(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < jobs.count else { return }

        let job = jobs[jobIndex]
        if let jobID = job["JobID"], bookmarkedJobs.contains(jobID) {
            removeJobFromFirestore(jobID: jobID)
        } else {
            saveJobToFirestore(job: job)
        }
    }
    @IBAction func bookmarkButton5(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < jobs.count else { return }

        let job = jobs[jobIndex]
        if let jobID = job["JobID"], bookmarkedJobs.contains(jobID) {
            removeJobFromFirestore(jobID: jobID)
        } else {
            saveJobToFirestore(job: job)
        }
    }
   
    
    @IBAction func viewDetails4(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < filteredJobs.count else { return } // Ensure valid index

        let jobID = filteredJobs[jobIndex]["dTXt3xcdUuBre3UPq20a"] // Retrieve the document ID for the selected job
        performSegue(withIdentifier: "showDetails", sender: jobID)
    }
    
    @IBAction func viewDetails5(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < filteredJobs.count else { return } // Ensure valid index

        let jobID = filteredJobs[jobIndex]["say2eHN4YwBndLXd5YzT"] // Retrieve the document ID for the selected job
        performSegue(withIdentifier: "showDetails", sender: jobID)
    }
    
    @IBAction func viewDetails3(_ sender: UIButton) {  let jobIndex = sender.tag
        guard jobIndex < filteredJobs.count else { return } // Ensure valid index

        let jobID = filteredJobs[jobIndex]["RGs1SisuYHeHSe3Kun0k"] // Retrieve the document ID for the selected job
        performSegue(withIdentifier: "showDetails", sender: jobID)
    }
    
    
    @IBAction func viewDetails1(_ sender: UIButton) { let jobIndex = sender.tag
        guard jobIndex < filteredJobs.count else { return } // Ensure valid index

        let jobID = filteredJobs[jobIndex]["37cR9cr64KM0G8W9D3jf"] // Retrieve the document ID for the selected job
        performSegue(withIdentifier: "showDetails", sender: jobID)
    }
    
    
    @IBAction func ClearsFiltersButton(_ sender: UIButton) {
        
        // Reset the filtered jobs to show all jobs
           filteredJobs = jobs

           // Fetch all jobs from Firestore without any filters
           fetchJobData(filters: nil)

           // Update the UI
           updateUI()
    }
    
    
    @IBOutlet weak var imgJob1: UIImageView!
    @IBOutlet weak var imgJob2: UIImageView!
    @IBOutlet weak var imgJob3: UIImageView!
    @IBOutlet weak var imgJob4: UIImageView!
    @IBOutlet weak var imgJob5: UIImageView!
    
    
    @IBOutlet weak var bookmarkButton1: UIButton!
    @IBOutlet weak var bookmarkButton2: UIButton!
    @IBOutlet weak var bookmarkButton3: UIButton!
    @IBOutlet weak var bookmarkButton4: UIButton!
    @IBOutlet weak var bookmarkButton5: UIButton!
    
    
    @IBAction func viewDetails2(_ sender: UIButton) {
        let jobIndex = sender.tag
            guard jobIndex < filteredJobs.count else { return }

            let jobID = filteredJobs[jobIndex]["NEXrL05khlSFhnQpS2YA"] 
        
      
            performSegue(withIdentifier: "showDetails", sender: jobID)
    }
    
    
    @IBAction func bookmarkButton1(_ sender: UIButton) {
        let jobIndex = sender.tag
               guard jobIndex < jobs.count else { return }

               let job = jobs[jobIndex]
               if let jobID = job["JobID"], bookmarkedJobs.contains(jobID) {
                   removeJobFromFirestore(jobID: jobID)
               } else {
                   saveJobToFirestore(job: job)
               }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "showDetails" {
              let detailsVC = segue.destination as! DetailsViewController
              detailsVC.jobID = sender as? String
          } else if segue.identifier == "showFilter" {
              let filterVC = segue.destination as! FilterTableViewController
              filterVC.delegate = self
          }
      }

    
    // Variables for storing Jobs Listing
        var jobs: [[String: String]] = [] // All jobs fetched from Firestore
    
    
        var filteredJobs: [[String: String]] = [] // Jobs matching search criteria
    
    
    var bookmarkedJobs: [String] = [] // List of bookmarked job IDs

        let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Keep the existing functionality
        searchBar.delegate = self
        
        fetchJobData() // Fetch jobs from Firestore
        
       
    }

    
    func applyFilter(filters: [String: String]) {
        fetchJobData(filters: filters)
    }

     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
            
            // Reset filtered jobs, show all UI elements, and restore default colors
            filteredJobs = jobs
            setUIElementsVisibility(isHidden: false, visibleElementsCount: jobs.count)
       
        } else {
            
            
            
            // Filter jobs
            filteredJobs = jobs.filter { job in
                let jobTitle = job["Job"]?.lowercased() ?? ""
                let companyName = job["Company"]?.lowercased() ?? ""
                return jobTitle.contains(searchText.lowercased()) || companyName.contains(searchText.lowercased())
            }
            setUIElementsVisibility(isHidden: false, visibleElementsCount: filteredJobs.count)
          
        }
        updateUI()
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
    
    
    
    
    func fetchJobData(filters: [String: String]? = nil) {
            let db = Firestore.firestore()
            var query: Query = db.collection("JobDetails")
        
        
        // Applying filters dynamically if any exist
            if let filters = filters, !filters.isEmpty {
                for (key, value) in filters {
                    query = query.whereField(key, isEqualTo: value)
                }
            }

           query.getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error fetching job listings: \(error.localizedDescription)")
                   return
               }

               guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                   print("No job listings found.")
                   self.filteredJobs = []
                   self.updateUI()
                   return
               }

               self.jobs = documents.compactMap { doc in
                   var jobData: [String: String] = [:]
                   let data = doc.data()

                   jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                   jobData["Company"] = data["Company"] as? String ?? "No Company"
                   jobData["Location"] = data["Location"] as? String ?? "No Location"
                   jobData["Years"] = data["Years"] as? String ?? "No Experience"
                   jobData["Type"] = data["Type"] as? String ?? "No Type"
                   jobData["Industry"] = data["Industry"] as? String ?? "No Industry"
                   jobData["JobID"] = doc.documentID

                   // Safely extract and cast each field as String
                       jobData["37cR9cr64KM0G8W9D3jf"] = doc.documentID // Store the document ID
                       jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                       jobData["Company"] = data["Company"] as? String ?? "No Company"
                       jobData["Icon"] = data["Icon"] as? String ?? "" // Fetch image URL
                       // Safely extract and cast each field as String
                       jobData["NEXrL05khlSFhnQpS2YA"] = doc.documentID // Store the document ID
                       jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                       jobData["Company"] = data["Company"] as? String ?? "No Company"
                       jobData["Icon"] = data["Icon"] as? String ?? "" // Fetch image URL
                       // Safely extract and cast each field as String
                       jobData["RGs1SisuYHeHSe3Kun0k"] = doc.documentID // Store the document ID
                       jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                       jobData["Company"] = data["Company"] as? String ?? "No Company"
                       jobData["Icon"] = data["Icon"] as? String ?? "" // Fetch image URL
                       // Safely extract and cast each field as String
                       jobData["dTXt3xcdUuBre3UPq20a"] = doc.documentID // Store the document ID
                       jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                       jobData["Company"] = data["Company"] as? String ?? "No Company"
                       jobData["Icon"] = data["Icon"] as? String ?? "" // Fetch image URL

                       // Safely extract and cast each field as String
                       jobData["say2eHN4YwBndLXd5YzT"] = doc.documentID // Store the document ID
                       jobData["Job"] = data["Job"] as? String ?? "No Job Title"
                       jobData["Company"] = data["Company"] as? String ?? "No Company"
                       jobData["Icon"] = data["Icon"] as? String ?? "" // Fetch image URL
                    
                       return jobData
                   }

                   self.filteredJobs = self.jobs
                 
               self.updateUI()
               }
       }

    
 
    
    func setUIElementsVisibility(isHidden: Bool, visibleElementsCount: Int = 0) {
        // Labels
        lblJobTitle.isHidden = visibleElementsCount < 1 || isHidden
        lblCompanyName.isHidden = visibleElementsCount < 1 || isHidden
        lblJobTitle2.isHidden = visibleElementsCount < 2 || isHidden
        lblCompanyName2.isHidden = visibleElementsCount < 2 || isHidden
        lblJobTitle3.isHidden = visibleElementsCount < 3 || isHidden
        lblCompanyName3.isHidden = visibleElementsCount < 3 || isHidden
        lblJobTitle4.isHidden = visibleElementsCount < 4 || isHidden
        lblCompanyName4.isHidden = visibleElementsCount < 4 || isHidden
        lblJobTitle5.isHidden = visibleElementsCount < 5 || isHidden
        lblCompanyName5.isHidden = visibleElementsCount < 5 || isHidden

        // Buttons
        viewDetailsButton1.isHidden = visibleElementsCount < 1 || isHidden
        viewDetailsButton2.isHidden = visibleElementsCount < 2 || isHidden
        viewDetailsButton3.isHidden = visibleElementsCount < 3 || isHidden
        viewDetailsButton4.isHidden = visibleElementsCount < 4 || isHidden
        viewDetailsButton5.isHidden = visibleElementsCount < 5 || isHidden

        // Images
        imgJob1.isHidden = visibleElementsCount < 1 || isHidden
        imgJob2.isHidden = visibleElementsCount < 2 || isHidden
        imgJob3.isHidden = visibleElementsCount < 3 || isHidden
        imgJob4.isHidden = visibleElementsCount < 4 || isHidden
        imgJob5.isHidden = visibleElementsCount < 5 || isHidden

        // Bookmark buttons
        bookmarkButton1.isHidden = visibleElementsCount < 1 || isHidden
        bookmarkButton2.isHidden = visibleElementsCount < 2 || isHidden
        bookmarkButton3.isHidden = visibleElementsCount < 3 || isHidden
        bookmarkButton4.isHidden = visibleElementsCount < 4 || isHidden
        bookmarkButton5.isHidden = visibleElementsCount < 5 || isHidden
    }


    func updateUI() {
        // Pair each set of labels and buttons
        let labelsAndButtons: [(UILabel?, UILabel?, UIButton?, UIButton?)] = [
            (lblJobTitle, lblCompanyName, viewDetailsButton1, bookmarkButton1),
            (lblJobTitle2, lblCompanyName2, viewDetailsButton2, bookmarkButton2),
            (lblJobTitle3, lblCompanyName3, viewDetailsButton3, bookmarkButton3),
            (lblJobTitle4, lblCompanyName4, viewDetailsButton4, bookmarkButton4),
            (lblJobTitle5, lblCompanyName5, viewDetailsButton5, bookmarkButton5)
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
        // Dynamically hide/show elements based on the filtered job count
            setUIElementsVisibility(isHidden: false, visibleElementsCount: filteredJobs.count)
      
    }

   

    

    func setUIElementsVisibility(isHidden: Bool) {
        // Hiding and showing additional labels and buttons
       
        lblJobTitle2.isHidden = isHidden
        lblCompanyName2.isHidden = isHidden
        lblJobTitle3.isHidden = isHidden
        lblCompanyName3.isHidden = isHidden
        lblJobTitle4.isHidden = isHidden
        lblCompanyName4.isHidden = isHidden
        lblJobTitle5.isHidden = isHidden
        lblCompanyName5.isHidden = isHidden

      
        viewDetailsButton2.isHidden = isHidden
        viewDetailsButton3.isHidden = isHidden
        viewDetailsButton4.isHidden = isHidden
        viewDetailsButton5.isHidden = isHidden

      
       imgJob2.isHidden = isHidden
       imgJob3.isHidden = isHidden
       imgJob4.isHidden = isHidden
       imgJob5.isHidden = isHidden
        
        
        
        
        bookmarkButton2.isHidden = isHidden
        bookmarkButton3.isHidden = isHidden
        bookmarkButton4.isHidden = isHidden
        bookmarkButton5.isHidden = isHidden
    }
    


   }


