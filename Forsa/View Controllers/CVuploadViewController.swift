//
//  CVuploadViewController.swift
//  Forsa
//
//  Created by BP-36-201-25 on 27/12/2024.
//

import UIKit

class CVuploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
