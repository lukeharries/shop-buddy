//
//  ColourSelectionButton.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit
import SnapKit

class ColourSelectionView: UIView {

    var selectionColour : UIColor = UIColor.black {
        didSet { updateAppearance() }
    }
    
    fileprivate var isRadioButtonSelected : Bool = false
    
    var circleView : UIView = UIView()
    var circleLayer : CAShapeLayer?
    var strokeLayer : CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.addSubview(circleView)
        circleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
        setSelected(isSelected: isRadioButtonSelected, animated: false)
    }
    
    func setSelected(isSelected selected: Bool, animated: Bool) {
        self.isRadioButtonSelected = selected
        
        if self.strokeLayer != nil {
            self.strokeLayer!.removeFromSuperlayer()
        }
        
        if selected {
            let size = self.bounds.size
            let smallestDimension = min(size.height, size.width)
            let radius = (smallestDimension / 2.0) - 2.0
            let centre = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
            let circlePath = UIBezierPath(arcCenter: centre, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2.0), clockwise: true)
            self.strokeLayer = CAShapeLayer()
            self.strokeLayer!.path = circlePath.cgPath
            self.strokeLayer!.fillColor = UIColor.clear.cgColor
            self.strokeLayer!.strokeColor = selectionColour.cgColor
            self.strokeLayer!.lineWidth = 2.0
            circleView.layer.addSublayer(self.strokeLayer!)
        }
    }
    
    fileprivate func updateAppearance() {
        let size = self.bounds.size
        let smallestDimension = min(size.height, size.width)
        let radius = (smallestDimension / 2.0) - 4.0
        let centre = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)

        let circlePath = UIBezierPath(arcCenter: centre, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2.0), clockwise: true)
        
        if self.circleLayer != nil {
            self.circleLayer!.removeFromSuperlayer()
        }
        
        self.circleLayer = CAShapeLayer()
        self.circleLayer!.path = circlePath.cgPath
        
        self.circleLayer!.fillColor = selectionColour.cgColor

        circleView.layer.addSublayer(self.circleLayer!)
    }
    
    
    
    
    
    
    
    

}
