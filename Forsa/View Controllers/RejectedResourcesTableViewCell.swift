//
//  RejectedResourcesTableViewCell.swift
//  Forsa
//
//  Created by BP-36-201-19 on 25/12/2024.
//

import UIKit

class RejectedResourcesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ResourceType: UILabel!
    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var ExtraDetails: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var SaveButton: UIButton!
    
    private let arrowButton = UIButton(type: .system) // Create a button
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
            arrowButton.heightAnchor.constraint(equalToConstant: 16)])

            }
    
            func setContainerViewColor(_ color: UIColor) {
                    containerView.backgroundColor = color
                }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func commonInit(
        _ resourceType: String,
        _ details: String,
        _ extradetails: String
    ) {
        ResourceType.text = resourceType
        Details.text = details
        ExtraDetails.text = extradetails
        
    }
   

}
