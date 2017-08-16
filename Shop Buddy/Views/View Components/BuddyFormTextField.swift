//
//  BuddyFormTextField.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum TextFieldStyle {
    case standard
    case currency
    case quantity
}

class BuddyFormTextField : UITextField {
    
    var textFieldStyle : TextFieldStyle = .standard {
        didSet {
            applyStyle()
            updatePrefixLabel()
        }
    }
    
    override var font: UIFont? {
        didSet {
            updatePrefixLabel()
        }
    }
    
    var baseColour : UIColor = UIColor.black {
        didSet { applyStyle() }
    }
    
    var prefixLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPrefixLabel()
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPrefixLabel()
        applyStyle()
    }
    
    func setupPrefixLabel() {
        addSubview(prefixLabel)
        prefixLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(8.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func updatePrefixLabel() {
        prefixLabel.font = self.font
        switch textFieldStyle {
        case .currency:
            prefixLabel.text = getSymbolForCurrencyCode()
            prefixLabel.isHidden = false
        case .quantity:
            prefixLabel.text = "x"
            prefixLabel.isHidden = false
        default:
            prefixLabel.text = nil
            prefixLabel.isHidden = true
        }
    }
    
    func getSymbolForCurrencyCode() -> String {
        let locale = NSLocale.current
        return locale.currencySymbol ?? "$"
    }
    
    func applyStyle() {
        backgroundColor = baseColour.withAlphaComponent(0.05)
        borderStyle = .none

        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
    var paddingLeft: CGFloat {
        if textFieldStyle == .standard {
            return 8.0
        } else {
            return 16.0 + prefixLabel.frame.width
        }
    }
    var verticalPadding : CGFloat = 8.0
    var paddingRight: CGFloat = 8.0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y + verticalPadding, width: bounds.size.width - (paddingLeft + paddingRight), height: bounds.size.height - (2.0 * verticalPadding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    
}


