//
//  ShoppingItemCell.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemTotalLabel: UILabel!
    
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemTotalLabel.textColor = UIColor.accent
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingItemCell.coloursChanged(notification:)),
                       name: BuddySettings.colourChangedNotification, object: nil)
    }
    
    @objc
    func coloursChanged(notification: Notification) {
        itemTotalLabel.textColor = UIColor.accent
    }
    
    func populate(withItem item: ShoppingItem) {
        itemNameLabel.text = item.product.name
        itemTotalLabel.text = CurrencyHelper.shared.format(priceInCents: item.totalPriceCents)
        
        qtyLabel.text = String(format: "%.2f x", item.units)
        unitPriceLabel.text = CurrencyHelper.shared.format(priceInCents: item.unitPriceCents)
    }

}
