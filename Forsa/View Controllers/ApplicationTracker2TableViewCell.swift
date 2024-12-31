//
//  ApplicationTracker2TableViewCell.swift
//  Forsa
//
//  Created by BP-36-201-03 on 26/12/2024.
//

import UIKit

class ApplicationTracker2TableViewCell: UITableViewCell {
    @IBOutlet weak var CompanyImage: UIImageView!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var CompanyName: UILabel!
    @IBOutlet weak var ApplicationDate: UILabel!
    @IBOutlet weak var ApplicationStatusLabel: UILabel!
    @IBOutlet weak var ApplicationStatusView: UIView!
    @IBOutlet weak var ApplicationStatusInsideLabel: UILabel!
    @IBOutlet weak var ViewDetailsButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var RecommandedResources: UIButton!
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        func commonInit(
            _ jobtitlename: String,
            _ image: String,
            _ companyname: String,
            _ applicationDate: String,
            _ applicationsstatusinsidelabel: String
        ) {
            JobTitle.text = jobtitlename
            CompanyName.text = companyname
            ApplicationDate.text = applicationDate
            
            
            print("Assigning values in commonInit:")
            print("Job Title: \(jobtitlename)")
            print("Company Name: \(companyname)")
            print("Application Date: \(applicationDate)")
            
            CompanyImage.image = UIImage(named: image) ?? UIImage(named: "defaultImage") // Use default image if not found
            
            let hexToColor: (String, CGFloat) -> UIColor = { hex, alpha in
                var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
                
                var rgb: UInt64 = 0
                Scanner(string: hexSanitized).scanHexInt64(&rgb)
                
                let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                let blue = CGFloat(rgb & 0x0000FF) / 255.0
                
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
            
            ApplicationStatusInsideLabel.text = applicationsstatusinsidelabel
            switch applicationsstatusinsidelabel {
            case "Rejected":
                ApplicationStatusView.backgroundColor = hexToColor("#FF0000", 1.0) // Red
                ApplicationStatusInsideLabel.textColor = hexToColor("#FFFFFF", 1.0) // White
            case "Interviewed":
                ApplicationStatusView.backgroundColor = hexToColor("#909394", 1.0) // Custom Gray
                ApplicationStatusInsideLabel.textColor = hexToColor("#FFFFFF", 1.0) // White
            case "Reviewing":
                ApplicationStatusView.backgroundColor = hexToColor("#007AFF", 1.0) // Custom Blue
                ApplicationStatusInsideLabel.textColor = hexToColor("#FFFFFF", 1.0) // White
            default:
                ApplicationStatusView.backgroundColor = hexToColor("#D3D3D3", 1.0) // Light Gray
                ApplicationStatusInsideLabel.textColor = hexToColor("#000000", 1.0) // Black
            }
            
            ApplicationStatusView.layer.cornerRadius = ApplicationStatusView.frame.height / 2
            ApplicationStatusView.layer.masksToBounds = true
            
            switch applicationsstatusinsidelabel{
            case"Rejected" :
                ViewDetailsButton.isHidden = false
                DeleteButton.isHidden = false
                RecommandedResources.isHidden = false
                
            case "Interviewed" :
                ViewDetailsButton.isHidden = false
                DeleteButton.isHidden = false
                RecommandedResources.isHidden = false
                
                
            case "Reviewing" :
                ViewDetailsButton.isHidden = false
                DeleteButton.isHidden = false
                RecommandedResources.isHidden = false
            default:
                ViewDetailsButton.isHidden = true
                DeleteButton.isHidden = true
                RecommandedResources.isHidden = false
            }
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    

