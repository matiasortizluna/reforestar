//
//  CatalogTableViewCell.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 05/09/2021.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var latin_name_label: UILabel!
    @IBOutlet weak var common_name_label: UILabel!
    @IBOutlet weak var image_tree: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(UIDevice.current.userInterfaceIdiom == .phone){
            print("UIDevice.current.userInterfaceIdiom == .phone")
            image_tree.autoresizingMask = []
            image_tree.frame.size.height = image_tree.frame.size.height / 2
            image_tree.frame.size.width = image_tree.frame.size.width / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
