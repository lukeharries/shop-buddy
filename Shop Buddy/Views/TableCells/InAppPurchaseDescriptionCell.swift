//
//  InAppPurchaseDescriptionCell.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

class InAppPurchaseDescriptionCell: UITableViewCell {

    static let cellId = "InAppPurchaseDescriptionCell"
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
