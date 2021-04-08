//
//  TableViewCell.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 08/04/2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabelForCell: UILabel!
    @IBOutlet weak var sizeLabelForCell: UILabel!
    @IBOutlet weak var areaLabelForCell: UILabel!
    @IBOutlet weak var treesLabelForCell: UILabel!
    @IBOutlet weak var animalsLabelForCell: UILabel!
    @IBOutlet weak var sizeValueLabelForCell: UILabel!
    @IBOutlet weak var areaValueLabelForCell: UILabel!
    @IBOutlet weak var treesValueLabelForCell: UILabel!
    @IBOutlet weak var animalsValueLabelForCell: UILabel!
    
    @IBOutlet weak var imageForCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
