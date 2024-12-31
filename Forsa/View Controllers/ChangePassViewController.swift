import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ChangePassViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Validate fields
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
              let currentPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !currentPassword.isEmpty,
              let newPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        // Ensure new password and current password do not match
        guard newPassword != currentPassword else {
            showAlert(message: "New password cannot be the same as the current password.")
            return
        }

        // Get current user
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "No user is currently signed in.")
            return
        }

        // Reauthenticate user
        reauthenticateUser(email: email, currentPassword: currentPassword) { [weak self] success, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: "Re-authentication failed: \(error.localizedDescription)")
                return
            }

            if success {
                // Update password
                self.updatePassword(for: user, newPassword: newPassword)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Secure password fields
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }

    // Reauthenticate the user
    private func reauthenticateUser(email: String, currentPassword: String, completion: @escaping (Bool, Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }

    // Update the user's password
    private func updatePassword(for user: User, newPassword: String) {
        user.updatePassword(to: newPassword) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to update password: \(error.localizedDescription)")
            } else {
                self?.showAlertWithRedirect(message: "Password successfully updated.")
            }
        }
    }

    // Helper method to show alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Helper method to show alerts and redirect
    func showAlertWithRedirect(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.redirectToSettings()
        }))
        present(alert, animated: true, completion: nil)
    }

    // Redirect to settings page
    private func redirectToSettings() {
        if let settingsViewController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
    }
}
