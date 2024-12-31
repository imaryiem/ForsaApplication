//
//  SavedJobsTableViewCell.swift
//  Forsa
//
//  Created by BP-36-201-03 on 26/12/2024.
//

import UIKit

class SavedJobsTableViewCell: UITableViewCell {

    @IBOutlet weak var CompanyImage: UIImageView!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var CompanyName: UILabel!
    @IBOutlet weak var ViewDetailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
    func commonInit(
        _ jobtitlename: String,
        _ companyname: String,
        _ image : String// Image name (as String)
    )
    {
        JobTitle.text = jobtitlename
        CompanyName.text = companyname
        
        // Set the image for the UIImageView
        CompanyImage.image = UIImage(named: image)  // Ensure the image name is correct and in your assets


    }
    
}
