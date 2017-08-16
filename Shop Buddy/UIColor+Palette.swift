//
//  UIColor+Palette.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit

enum ThemeOption : Int {
    case blue = 0 // default
    case red
    case orange
    case pink
    case green
    case grey
    
    static var count = ThemeOption.grey.rawValue + 1
}

extension UIColor {
    
    static let buddyBlue = UIColor(red:0.345098, green:0.494118, blue:1.000000, alpha:1.0)
    static let buddyRed = UIColor(red:0.749020, green:0.141176, blue:0.007843, alpha:1.0)
    static let buddyOrange = UIColor(red:0.682353, green:0.403922, blue:0.000000, alpha:1.0)
    static let buddyPink = UIColor(red:0.717647, green:0.023529, blue:0.647059, alpha:1.0)
    static let buddyGreen = UIColor(red:0.250980, green:0.674510, blue:0.294118, alpha:1.0)
    static let buddyGrey = UIColor(red:0.203922, green:0.203922, blue:0.203922, alpha:1.0)
    
    static var colours : [ThemeOption : UIColor] {
        return [
            .blue : UIColor.buddyBlue,
            .red : UIColor.buddyRed,
            .orange : UIColor.buddyOrange,
            .pink : UIColor.buddyPink,
            .green : UIColor.buddyGreen,
            .grey : UIColor.buddyGrey
        ]
    }
    
    static var theme : ThemeOption {
        get {
            return StorageService.getAccentColour()
        }
        set {
            StorageService.saveAccentColour(colour: newValue)
            NotificationCenter.default.post(name: BuddySettings.colourChangedNotification, object: nil)
        }
    }
    
    static var accent : UIColor {
        get {
            let theme = StorageService.getAccentColour()
            if let colour = UIColor.colours[theme] {
                return colour
            } else {
                return UIColor.buddyBlue
            }
        }
    }
}
