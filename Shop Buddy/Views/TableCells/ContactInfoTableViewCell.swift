//
//  ContactInfoTableViewCell.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {

    static let cellId = "ContactInfoTableViewCell"
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactInfoTableViewCell.colourDidChange(notification:)), name: BuddySettings.colourChangedNotification, object: nil)
        
        styleIcon()
    }
    
    
    func configure(title: String, image: UIImage) {
        titleLabel.text = title
        iconImageView.image = image
    }

    
    
    func styleIcon() {
        iconContainerView.backgroundColor = UIColor.accent
        
        let startColour = UIColor.black.withAlphaComponent(0)
        let endColour = UIColor.black.withAlphaComponent(0.05)

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColour.cgColor, endColour.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.6)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: iconContainerView.frame.size.width, height: iconContainerView.frame.size.height)
        iconContainerView.layer.insertSublayer(gradient, at: 0)
        
        iconContainerView.layer.cornerRadius = 5.0
        iconContainerView.layer.masksToBounds = true
    }

    @objc
    func colourDidChange(notification: Notification) {
        styleIcon()
    }
    
    
}
