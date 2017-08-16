//
//  SavedSessionTableViewCell.swift
//  Shop Buddy
//
//  Created by Luke Harries on 13/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

class SavedSessionTableViewCell: UITableViewCell {

    @IBOutlet weak var priceDollarsLabel: UILabel!
    @IBOutlet weak var priceCentsLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceDollarsLabel.textColor = UIColor.accent
        priceCentsLabel.textColor = UIColor.accent
    }
    
    func configure(withSession session : ShoppingSession) {
        let priceComponents = CurrencyHelper.shared.formatComponents(priceInCents: session.sessionTotalCents)
        priceDollarsLabel.text = priceComponents.0
        priceCentsLabel.text = priceComponents.1
        priceCentsLabel.isHidden = priceComponents.1 == nil
        
        
        if let date = session.sessionDate {
            dateLabel.text = DateHelper.shared.format(date: date)
        } else {
            dateLabel.text = "No Date"
        }
        
        locationLabel.text = session.location?.name
        locationLabel.isHidden = session.location == nil
        
        let detailFormat = "%d items"
        detailLabel.text = String(format: detailFormat, session.items.count)
    }
    
    

    

}
