//
//  InterviewiedResourcesViewController.swift
//  Forsa
//
//  Created by BP-36-201-03 on 26/12/2024.
//

import UIKit

class InterviewiedResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    // Do any additional setup after loading the view.
    
    
    
    //Creating Arrays
    let ResourceTypeArr = ["Article", "Guide", "Video", "Article", "Guide"]
    let DetailsArr = ["Tips to answer the questions related to Salary", "How could you evaluate and choose the best job offers", "Advice for after the Interview","How to Write a Follow-Up Email for a Job Application or Interview","Guide to Following Up After Job Interviews"]
    let ExtraDetailsArr = ["","","Follow-up Strategies to increase your chances of success","",""]
    // Array with the colors using hex values
    let backgroundColors: [UIColor] = [
        UIColor(hexColor: "#D5CDF7"), // Light Purple
        UIColor(hexColor: "#CBDDDA"), // Light Green
        UIColor(hexColor: "#C6C6C6")  // Light Gray
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "InterviewiedResourcesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "InterviewedResourcesCell")
        
        
    }
    
    
}



extension InterviewiedResourcesViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourceTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InterviewedResourcesCell", for: indexPath) as? InterviewiedResourcesTableViewCell else {
                    return UITableViewCell()
                }

                // Populate cell with data from arrays
        cell.commonInit(
            ResourceTypeArr[indexPath.row],
            DetailsArr[indexPath.row],
            ExtraDetailsArr[indexPath.row]
        )

        // Assign color to the containerView in the cell
               let colorIndex = indexPath.row % backgroundColors.count
               cell.setContainerViewColor(backgroundColors[colorIndex])
        
                return cell
            }
    
}



