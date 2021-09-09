//
//  ProjectsTableViewCell.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 05/09/2021.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var projects_name_label: UILabel!
    @IBOutlet weak var projects_status_label: UILabel!
    @IBOutlet weak var projects_status_value: UILabel!
    @IBOutlet weak var projects_trees_label: UILabel!
    @IBOutlet weak var projects_trees_value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
