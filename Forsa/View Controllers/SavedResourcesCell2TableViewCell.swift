//
//  SavedResourcesCell2TableViewCell.swift
//  Forsa
//
//  Created by BP-36-201-03 on 26/12/2024.
//

import UIKit

class SavedResourcesCell2TableViewCell: UITableViewCell {

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
                arrowButton.heightAnchor.constraint(equalToConstant: 16)
            ])
            
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func commonInit(_ type : String, _ edetails : String, _ detalis : String)
    {
        ResourceType.text = type
        Details.text = detalis
        ExtraDetails.text = edetails
        
    }
    
    
    
    
    
    
    
    
    
    
}
