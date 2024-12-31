//
//  ApplicationTracker2ViewController.swift
//  Forsa
//
//  Created by BP-36-201-25 on 27/12/2024.
//

import UIKit
import UIKit

class ApplicationTracker2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

 @IBOutlet weak var tableView: UITableView!

    // Arrays for Applications
    var JobTitleArr = ["UX Designer", "Software Engineer", "Business Analyst", "Cloud Solutions Architect", "IOS Developer", "Marketer"]
    var CompanyImageArr = ["Figma", "WhatsApp Image 2024-12-22 at 16.14.10", "Amazon", "CompanyLogo5", "CompanyLogo6", "AdSphere"]
    var CompanyNameArr = ["Figma", "Google", "Amazon", "Windows", "Apple", "AdSphere"]
    var ApplicationDateArr = ["Application Date 15- 5 -2024", "Application Date 10 -10 -2024", "Application Date 20 -10 -2024", "Application Date 15 -9 -2024", "Application Date 1 -10 -2024", "Application Date 1 -4 -2024"]
    var ApplicationStatusInsideLabelArr = ["Rejected", "Interviewed", "Reviewing", "Interviewed", "Reviewing", "Interviewed"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ApplicationTracker2TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JobTitleArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ApplicationTracker2TableViewCell else {
            return UITableViewCell()
        }

        cell.commonInit(
            JobTitleArr[indexPath.row],
            CompanyImageArr[indexPath.row],
            CompanyNameArr[indexPath.row],
            ApplicationDateArr[indexPath.row],
            ApplicationStatusInsideLabelArr[indexPath.row]
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Job Title: \(JobTitleArr[indexPath.row])")
    }
    
    @objc func resourcesButtonTapped(_ sender: UIButton) {
        print("Button tapped!") // Debug print
        let index = sender.tag
        let status = ApplicationStatusInsideLabelArr[index]
        print("Button index: \(index), Status: \(status)") // Debug print

        // Navigate based on the application status
        switch status {
        case "Rejected":
            guard let rejectedVC = storyboard?.instantiateViewController(withIdentifier: "RejectedResourcesViewController") as? RejectedResourcesViewController else {
                print("Failed to instantiate RejectedResourcesViewController")
                return
            }
            print("Navigating to RejectedResourcesViewController") // Debug print
            navigationController?.pushViewController(rejectedVC, animated: true)

        case "Reviewing":
            guard let reviewingVC = storyboard?.instantiateViewController(withIdentifier: "ReviwingResourcesViewController") as? ReviwingResourcesViewController else {
                print("Failed to instantiate ReviwingResourcesViewController")
                return
            }
            print("Navigating to ReviwingResourcesViewController") // Debug print
            navigationController?.pushViewController(reviewingVC, animated: true)

        case "Interviewed":
            guard let interviewedVC = storyboard?.instantiateViewController(withIdentifier: "InterviewiedResourcesViewController") as? InterviewiedResourcesViewController else {
                print("Failed to instantiate InterviewiedResourcesViewController")
                return
            }
            print("Navigating to InterviewiedResourcesViewController") // Debug print
            navigationController?.pushViewController(interviewedVC, animated: true)

        default:
            print("Unknown status")
        }
    }




    }

