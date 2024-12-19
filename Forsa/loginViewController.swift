//
//  LoginViewController.swift
//  Forsa
//
//  Created by Shaima on 07/12/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PasswordTextField.isSecureTextEntry = true
        
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        //validation
        guard let email = EmailTextField.text, !email.isEmpty,
        let password = PasswordTextField.text, !password.isEmpty else {
            print("Missing Field Data!")
            showAlert(message: "Please enter both email and password.")
            return
    }
    
    }
    
    // Helper function to show alert
      func showAlert(message: String) {
          let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
