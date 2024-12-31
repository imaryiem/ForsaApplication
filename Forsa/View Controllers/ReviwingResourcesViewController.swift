//
//  ReviwingResourcesViewController.swift
//  Forsa
//
//  Created by BP-36-201-19 on 25/12/2024.
//

import UIKit

class ReviwingResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let reviewingResourceTypeArr = ["Article", "Guide", "Video", "Article", "Guide"]
    let reviewingResourceDetails = ["How could you improve your Resume?", "5 basic steps to create a good profile", "The 10 most common questions in the interview", "What to Do When Your Job Application is Stuck in Pending", "Handling Pending Job Applications and Effective Follow-Up Strategies"]
    let reviewingResourceExtraDetailsArr = ["In 5 simple steps", "","","",""]
    
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
        let nib = UINib(nibName: "ReviewingResourcesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewingResourcesCell")
        
        
    }
    
    
}
    
    
    
    
extension ReviwingResourcesViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewingResourceTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewingResourcesCell", for: indexPath) as? ReviewingResourcesTableViewCell else {
                    return UITableViewCell()
                }

                // Populate cell with data from arrays
        cell.commonInit(
            reviewingResourceTypeArr[indexPath.row],
            reviewingResourceDetails[indexPath.row],
            reviewingResourceExtraDetailsArr[indexPath.row]
        )
        // Assign color to the containerView in the cell
               let colorIndex = indexPath.row % backgroundColors.count
               cell.setContainerViewColor(backgroundColors[colorIndex])
        
                return cell
            }  }
    

