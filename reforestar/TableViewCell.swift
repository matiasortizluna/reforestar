//
//  TableViewCell.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabelForCell: UILabel!
    @IBOutlet weak var imageForCell: UIImageView!
    
    @IBOutlet weak var sizeValueLabel: UILabel!
    
    @IBOutlet weak var treesValueLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
