import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var NameLabel: UILabel!

    @IBAction func SignOutBtn(_ sender: Any) {
        do {
            // Sign out the user
            try Auth.auth().signOut()

            // Transition to the login screen
            let storyboard = UIStoryboard(name: "Shaima", bundle: nil) // Replace "NewStoryboardName" with the actual name of your new storyboard
            if let loginViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? LoginViewController {
                let navigationController = UINavigationController(rootViewController: loginViewController)
                view.window?.rootViewController = navigationController
                view.window?.makeKeyAndVisible()
            }
 else {
                showAlert(message: "Failed to load the login page. Please try again.")
            }
        } catch let signOutError as NSError {
            // Handle sign-out error
            showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch and display the user's name
        fetchUserName()
    }

    // Fetch the user's name from Firestore
    func fetchUserName() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user name: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    self.NameLabel.text = data["FullName"] as? String ?? "Unknown"
                }
            } else {
                print("No user document found.")
            }
        }
    }

    // Helper function to show alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
