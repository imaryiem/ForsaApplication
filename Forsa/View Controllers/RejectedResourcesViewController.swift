//
//  RejectedResourcesViewController.swift
//  Forsa
//
//  Created by BP-36-201-19 on 25/12/2024.
//

import UIKit

class RejectedResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!

    //Creating Arrays
    let ResourceTypeArr = ["Article", "Guide", "Video", "Article", "Guide"]
    let DetailsArr = ["How to Properly prepare for the next interview", "Tips to improve your cover letter and Resume", "Advice for aiding the job seekers to develop their skills", "5 Things to Do When You Get a Job Rejection", "How to Handle Job Rejection and Improve Your Chances Next Time"]
    let ExtraDetailsArr = ["","","","",""]
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
        let nib = UINib(nibName: "RejectedResourcesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RejectedResourcesCell")
        
        
    }
    
    
    

}

extension RejectedResourcesViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourceTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RejectedResourcesCell", for: indexPath) as? RejectedResourcesTableViewCell else {
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
