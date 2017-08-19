//
//  InAppPurchaseActionCell.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

protocol InAppPurchaseActionCellDelegate: class {
    func inAppPurchaseActionCell(_ cell: InAppPurchaseActionCell, didTapActionButton tapped: Bool)
}

class InAppPurchaseActionCell: UITableViewCell {
    
    static let cellId = "InAppPurchaseActionCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    
    weak var delegate : InAppPurchaseActionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(InAppPurchaseActionCell.didUpdateColour(notification:)), name: BuddySettings.colourChangedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(InAppPurchaseActionCell.didPurchaseProduct(notification:)), name: InAppPurchaseService.purchaseNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(InAppPurchaseActionCell.purchaseDidFail(notification:)), name: InAppPurchaseService.purchaseFailedNotification, object: nil)
        
    }
    
    
    var product : InAppPurchaseProduct?
    func configure(product: InAppPurchaseProduct, delegate: InAppPurchaseActionCellDelegate?) {
        self.product = product
        titleLabel.text = product.productName
        self.delegate = delegate
        
        if InAppPurchaseService.canMakePayments() {
            actionButton.setTitle(product.priceString, for: .normal)
            defaultButtonLabel = product.priceString
            actionButton.isEnabled = true
        } else {
            actionButton.setTitle("Not Available", for: .normal)
            defaultButtonLabel = "Not Available"

            actionButton.isEnabled = false
        }
        
        actionButton.isHidden = false
    }
    
    @objc func didPurchaseProduct(notification: Notification) {
        if product != nil {
            if InAppPurchaseService.shared.isProductPurchased(product!.product.productIdentifier) {
                actionButton.setTitle("Purchased", for: .normal)
                actionButton.isEnabled = false
            }
        }
    }
    
    @objc func purchaseDidFail(notification: Notification) {
        actionButton.isEnabled = true
        actionButton.setTitle(defaultButtonLabel, for: .normal)
    }
    
    var defaultButtonLabel : String!
    
    func configure(title: String, buttonLabel: String, delegate: InAppPurchaseActionCellDelegate?, hideButton: Bool = false) {
        titleLabel.text = title
        defaultButtonLabel = buttonLabel
        actionButton.setTitle(buttonLabel, for: .normal)
        self.delegate = delegate
        
        actionButton.isHidden = hideButton
    }

    @objc func didUpdateColour(notification: Notification) {
        styleButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleButton()
    }
    
    func styleButton() {
        actionButton.setTitleColor(UIColor.accent, for: .normal)
        actionButton.setTitleColor(UIColor.accent.withAlphaComponent(0.5), for: .highlighted)
        actionButton.setTitleColor(UIColor.accent.withAlphaComponent(0.6), for: .disabled)

        
        actionButton.layer.cornerRadius = 5.0
        actionButton.layer.masksToBounds = true
        actionButton.layer.borderColor = UIColor.accent.cgColor
        actionButton.layer.borderWidth = 1.0
    }

    
    @IBAction func didTapButton(_ sender: Any) {
        actionButton.isEnabled = false
        actionButton.setTitle("Processing", for: .normal)
        delegate?.inAppPurchaseActionCell(self, didTapActionButton: true)
    }
    
}
