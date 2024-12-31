//
//  LoginViewController.swift
//  Forsa
//
//  Created by Shaima.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true // Hide navigation bar on the login page
        // Secure password field
        PasswordTextField.isSecureTextEntry = true
    }

    @IBAction func LoginBtn(_ sender: Any) {
        // Validate email and password
        guard let email = EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
              let password = PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showAlert(message: "Please enter both email and password.")
            return
        }
        
        // Sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: "Invalid email or password: \(error.localizedDescription)")
            } else {
                // Check the user's role in Firestore
                let db = Firestore.firestore()
                if let userID = result?.user.uid {
                    db.collection("users").document(userID).getDocument { (document, error) in
                        if let error = error {
                            self.showAlert(message: "Error fetching user data: \(error.localizedDescription)")
                            return
                        }
                        
                        if let document = document, document.exists {
                            let data = document.data()
                            let Role = data?["Role"] as? String ?? "job_seeker"
                            
                            switch Role {
                            case "admin":
                                self.navigateToAdminDashboard()
                            case "employer":
                                self.navigateToEmployerDashboard()
                            default:
                                self.performSegue(withIdentifier: "toDashboard", sender: self)
                            }
                        } else {
                            
                           self.showAlert(message: "User data not found.")
                        }
                    }
                }
            }
        }
    }
    
    // Navigate to Admin Dashboard in a different storyboard
    private func navigateToAdminDashboard() {
        let storyboard = UIStoryboard(name: "admin", bundle: nil) 
        guard let adminDashboardVC = storyboard.instantiateViewController(withIdentifier: "AdminDashboardViewController") as? AdminDashboardViewController else {
            showAlert(message: "Failed to load Admin Dashboard. Check the Storyboard ID.")
            return
        }
        
        let navigationController = UINavigationController(rootViewController: adminDashboardVC)
        self.view.window?.rootViewController = navigationController
        self.view.window?.makeKeyAndVisible()
    }

    // Navigate to Employer Dashboard in a different storyboard
    private func navigateToEmployerDashboard() {
        let storyboard = UIStoryboard(name: "employer", bundle: nil)
        guard let employerDashboardVC = storyboard.instantiateViewController(withIdentifier: "EmployerDashboardViewController") as? EmployerDashboardViewController else {
            showAlert(message: "Failed to load Employer Dashboard. Check the Storyboard ID.")
            return
        }
        
        let navigationController = UINavigationController(rootViewController: employerDashboardVC)
        self.view.window?.rootViewController = navigationController
        self.view.window?.makeKeyAndVisible()
    }

    // Navigate to Job Seeker Home/Profile in the current storyboard
    //private func navigateToUserHome() {
        // Replace "JobSeekerDashboard" with the exact name of your storyboard file (without .storyboard extension)
//        let storyboardName = "JobSeekerDashboard"
//
//        // Instantiate the storyboard
//        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
//
//        // Instantiate the view controller using the Storyboard ID from the new storyboard
//        guard let jobsViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard3.jobsViewController) as? JobsTableViewController else {
//            showAlert(message: "Failed to load User Home. Check the Storyboard ID in 'JobSeekerDashboard'.")
//            return
//        }
//
//        // Create a navigation controller with the jobsViewController as the root
//        let navigationController = UINavigationController(rootViewController: jobsViewController)
//
//        // Set the new navigation controller as the root view controller
//        self.view.window?.rootViewController = navigationController
//        self.view.window?.makeKeyAndVisible()
        
 //   }


    // Helper function to show alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
