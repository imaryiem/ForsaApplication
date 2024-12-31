import UIKit
import Firebase

class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    
    enum Page {
        case savedResources
        case SavedJobs
    }
    
    var currentPage: Page = .SavedJobs // Default to the Applications page
    
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentPage = .SavedJobs
        case 1:
            currentPage = .savedResources

        default:
            break
        }
        tableView.reloadData()
    }
    

    
    //Arrays for Saved Resources
    var ResourceTypeArr = ["Tutorial", "Video", "Article", "Video", "Tutorial", "Article"]
    var DetailsArr = ["Tips to improve your cover letter and Resume", "The 10 most common questions in the  interview", "Understanding CVs", "Interview preparation", "Resume Writing", "How to Properly prepare for the next interview"]
    var ExtraDetailsArr = ["","","A guide to building your CV","Tips for acing your interview", "Step-by-step tutorial",""]
    
    
    //Arrays for Saved Jobs
    var JobTitleArr = ["Marketer", "Engineering", "Software development", "Logistics","Cloud Solutions Architect","IOS Developer" ]
    var CompanyNameArr = ["AdSphere","Skyline","NextMove Technologies","CargoByte", "Microsoft", "Apple"]
    var CompanyImageArr = ["CompanyLogo1", "CompanyLogo2", "CompanyLogo3", "CompanyLogo4","CompanyLogo5", "CompanyLogo6"]
    
   override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
       tableView.register(UINib(nibName: "SavedResourcesCell2TableViewCell", bundle: nil), forCellReuseIdentifier: "SavedResourcesCell")
       tableView.register(UINib(nibName: "SavedJobsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")


           fetchJobsFromFirestore() // Fetch data
       }



}
extension ApplicationTrackerViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentPage {
        case .SavedJobs:
            return JobTitleArr.count
        case .savedResources:
            return ResourceTypeArr.count
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(JobTitleArr[indexPath.row])
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentPage {
        case .SavedJobs:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SavedJobsTableViewCell else {
                return UITableViewCell()
            }
            
            
            
            cell.commonInit(
                JobTitleArr[indexPath.row],
                CompanyNameArr[indexPath.row],
                CompanyImageArr[indexPath.row]
                
            )
            return cell
            
        case .savedResources:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedResourcesCell", for: indexPath) as? SavedResourcesCell2TableViewCell else {
                return UITableViewCell()
            }
            
            // Configure the Saved Resources Cell
            cell.commonInit(
                ResourceTypeArr[indexPath.row],
                ExtraDetailsArr[indexPath.row],
                DetailsArr[indexPath.row]
                
            )
            return cell
            
            
        }}
    
    func fetchJobsFromFirestore() {
        let db = Firestore.firestore()

        db.collection("SavedJobs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            // Append Firestore data to existing arrays
            snapshot?.documents.forEach { document in
                let data = document.data()
                if let company = data["Company"] as? String,
                   let job = data["Job"] as? String {
                    self.JobTitleArr.append(job) // Add job title to array
                    self.CompanyNameArr.append(company) // Add company name to array
                    self.CompanyImageArr.append("CompanyPlaceholderImage") // Placeholder for images
                }
            }

            // Reload the table view with the updated data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
