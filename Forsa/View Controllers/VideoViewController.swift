//
//  VideoViewController.swift
//  Forsa
//
//  Created by BP-36-201-01 on 26/12/2024.
//

import UIKit
import Firebase

class VideoViewController: UIViewController {

    // The YouTube video URL
        let videoURL = "https://youtu.be/HG68Ymazo18"

        override func viewDidLoad() {
            super.viewDidLoad()
            // Additional setup if needed
        }
    
    @IBAction func playButton2(_ sender: Any) {
        // Open the YouTube video URL in Safari
        guard let url = URL(string: videoURL) else {
            print("Invalid URL")
            return
    }
        // Save the video URL to Firestore
        saveVideoURLToFirestore(url: videoURL)
        
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("Successfully opened the video")
                } else {
                    print("Failed to open the video")
                }
            }
        }    
    // Function to save the video URL to Firestore
    func saveVideoURLToFirestore(url: String) {
        // Reference to Firestore
        let db = Firestore.firestore()
        
        // Reference to a collection
        let newDocRef = db.collection("CV").document()
        
        // Save the URL
        newDocRef.setData([
            "url": url,
            "timestamp": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error saving video URL: \(error.localizedDescription)")
            } else {
                print("Video URL successfully saved!")
            }
        }
    }
    }
