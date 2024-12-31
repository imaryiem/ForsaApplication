//
//  SplashScreenViewController.swift
//  Forsa
//
//  Created by Shaima on 05/12/2024.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Perform any additional setup for the splash screen, such as animations or logos
        
        // Delay of 5 seconds before navigating to the next screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigateToShaimaStoryboard()
        }
    }
    
    private func navigateToShaimaStoryboard() {
        // Load Shaima.storyboard
        let storyboard = UIStoryboard(name: "Shaima", bundle: nil)
        
        // Instantiate the initial view controller of Shaima.storyboard
        if let nextViewController = storyboard.instantiateInitialViewController() {
            // Get the active scene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = nextViewController
                window.makeKeyAndVisible()
            }
        } else {
            print("Error: Could not load the initial view controller from Shaima.storyboard")
        }
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
