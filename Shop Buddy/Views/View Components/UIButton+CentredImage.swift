//
//  UIButton+CentredImage.swift
//  Shop Buddy
//
//  Created by Luke Harries on 13/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CentredButton : UIButton {
    override func layoutSubviews() {
        
        let spacing: CGFloat = 6.0

        // lower the text and push it left so it appears centered
        //  below the image
        var titleEdgeInsets = UIEdgeInsets.zero
        if let image = self.imageView?.image {
            titleEdgeInsets.left = -image.size.width
            titleEdgeInsets.bottom = -(image.size.height + spacing)
        }
        self.titleEdgeInsets = titleEdgeInsets
        
        // raise the image and push it right so it appears centered
        //  above the text
        var imageEdgeInsets = UIEdgeInsets.zero
        if let text = self.titleLabel?.text, let font = self.titleLabel?.font {
            let attributes = [NSFontAttributeName: font] //NSAttributedStringKey.font
            let titleSize = text.size(attributes: attributes)
            imageEdgeInsets.top = -(titleSize.height + spacing)
            imageEdgeInsets.right = -titleSize.width
        }
        self.imageEdgeInsets = imageEdgeInsets
        
        super.layoutSubviews()
    }
}
