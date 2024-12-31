//
//  ReviewingResourcesTableViewCell.swift
//  Forsa
//
//  Created by BP-36-201-19 on 25/12/2024.
//

import UIKit

class ReviewingResourcesTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewingResourceSaveButton: UIButton!
    @IBOutlet weak var reviewingResourceExtraDetails: UILabel!
    @IBOutlet weak var reviewingResourceDetails: UILabel!
    @IBOutlet weak var reviewingResourceType: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    private let arrowButton = UIButton(type: .system) // Create a button

  
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        override func awakeFromNib() {
            super.awakeFromNib()
            // Configure the arrow button using SF Symbols
            arrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal) // SF Symbol for arrow
            arrowButton.tintColor = .gray // Change the arrow color
            arrowButton.contentMode = .scaleAspectFit
            arrowButton.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the arrow button to the container view
            containerView.addSubview(arrowButton)
            
            // Add constraints to position the arrow to the right
            NSLayoutConstraint.activate([
                arrowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                arrowButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                arrowButton.widthAnchor.constraint(equalToConstant: 16),
                arrowButton.heightAnchor.constraint(equalToConstant: 16)
            ])
        }
        
        func commonInit(
            _ resourceType: String,
            _ details: String,
            _ extradetails: String
        ) {
            reviewingResourceType.text = resourceType
            reviewingResourceDetails.text = details
            reviewingResourceExtraDetails.text = extradetails
            
        }
        
        // Define a method to set the background color of the containerView
        func setContainerViewColor(_ color: UIColor) {
            containerView.backgroundColor = color
        }
        
    }

