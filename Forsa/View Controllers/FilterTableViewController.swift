//
//  FilterTableViewController.swift
//  Forsa
//
//  Created by BP-36-201-20 on 25/12/2024.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func applyFilter(filters: [String: String])
}

class FilterTableViewController: UITableViewController {

    @IBOutlet weak var txtJobName: UITextField!
    @IBOutlet weak var txtIndustry: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtExperienceLevel: UITextField!
    @IBOutlet weak var txtJobType: UITextField!

    weak var delegate: FilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func applyFilter(_ sender: UIButton) {
        var filters: [String: String] = [:]

        // Collect user inputs
        if let jobName = txtJobName.text, !jobName.isEmpty {
            filters["Job"] = jobName
        }
        if let industry = txtIndustry.text, !industry.isEmpty {
            filters["Industry"] = industry
        }
        if let location = txtLocation.text, !location.isEmpty {
            filters["Location"] = location
        }
        if let company = txtCompany.text, !company.isEmpty {
            filters["Company"] = company
        }
        if let experienceLevel = txtExperienceLevel.text, !experienceLevel.isEmpty {
            filters["Years"] = experienceLevel
        }
        if let jobType = txtJobType.text, !jobType.isEmpty {
            filters["Type"] = jobType
        }

        // Pass filters back to JobsTableViewController
        delegate?.applyFilter(filters: filters)
        navigationController?.popViewController(animated: true)
    }
}
