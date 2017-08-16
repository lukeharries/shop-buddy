//
//  ColourPickerTableViewCell.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit
import SnapKit

class ColourPickerTableViewCell: UITableViewCell {
    
    static let cellId = "ColourPickerTableViewCell"

    @IBOutlet weak var colourButtonStackView: UIStackView!
    
    var circles : [ColourSelectionView] = [ColourSelectionView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }
    
    func setupButtons() {
        circles.removeAll()
        for themeOptionIndex in 0..<ThemeOption.count {
            let themeOption = ThemeOption(rawValue: themeOptionIndex)!
            let colour = UIColor.colours[themeOption]!
            
            let itemView = UIView()
            
            let circleView = ColourSelectionView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            circleView.selectionColour = colour
            circleView.tag = themeOptionIndex
            circleView.setSelected(isSelected: themeOption == UIColor.theme, animated: false)
            circles.append(circleView)
            
            itemView.addSubview(circleView)
            circleView.snp.makeConstraints({ (make) in
                make.edges.greaterThanOrEqualToSuperview()
                make.centerX.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(circleView.snp.height)
            })
            
            let button = UIButton(type: .custom)
            button.setTitle(nil, for: .normal)
            button.tag = themeOptionIndex
            button.addTarget(self, action: #selector(ColourPickerTableViewCell.didSelectButton(_:)), for: .touchUpInside)
            itemView.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })

            colourButtonStackView.addArrangedSubview(itemView)
        }
        
        colourButtonStackView.setNeedsLayout()
        colourButtonStackView.layoutIfNeeded()
    }
    
    @objc func didSelectButton(_ button: UIButton) {
        let tag = button.tag
        guard let themeOption = ThemeOption(rawValue: tag) else { return }
        
        UIColor.theme = themeOption
        
        for circle in circles {
            circle.setSelected(isSelected: circle.tag == tag, animated: false)
        }
    }
    


}
