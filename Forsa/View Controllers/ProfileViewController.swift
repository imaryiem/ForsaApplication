import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    // UI Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var preferredIndustriesLabel: UILabel!
    @IBOutlet weak var careerInterestsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch and display user data when the view loads
        fetchUserData()
        
        // Listen for profile updates
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("ProfileUpdated"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData() // Ensure data is refreshed every time the view appears
    }

    deinit {
        // Remove observer to prevent memory leaks
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ProfileUpdated"), object: nil)
    }

    // Fetch user data from Firestore
    func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                
                // Debugging: Print the fetched data
                print("Fetched user data: \(data ?? [:])")
                
                // Update UI elements on the main thread
                DispatchQueue.main.async {
                    self.nameLabel.text = data?["FullName"] as? String ?? "N/A"
                    self.genderLabel.text = data?["Gender"] as? String ?? "N/A"
                    self.dobLabel.text = data?["DOB"] as? String ?? "N/A"
                    self.countryLabel.text = data?["Country"] as? String ?? "N/A"
                    self.emailLabel.text = data?["Email"] as? String ?? "N/A"
                    self.contactNumberLabel.text = data?["ContactNum"] as? String ?? "N/A"
                    self.jobTitleLabel.text = data?["JobTitle"] as? String ?? "N/A"
                    self.educationLabel.text = data?["Education"] as? String ?? "N/A"
                    self.experienceLabel.text = data?["ExperienceLevel"] as? String ?? "N/A"
                    self.jobTypeLabel.text = data?["JobType"] as? String ?? "N/A"
                    self.skillsLabel.text = data?["Skills"] as? String ?? "N/A"
                    self.preferredIndustriesLabel.text = data?["PreferredIndustries"] as? String ?? "N/A"
                    self.careerInterestsLabel.text = data?["CareerInterests"] as? String ?? "N/A"
                }
            } else {
                print("Document does not exist.")
            }
        }
    }

    // Refresh data when profile updates
    @objc func refreshData() {
        print("ProfileUpdated notification received. Refreshing data...")
        fetchUserData()
    }
}
