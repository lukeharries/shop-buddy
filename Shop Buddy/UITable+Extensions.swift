//
//  UITable+Extensions.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func register(nibs: [String]) {
        for nibId in nibs {
            let uiNib = UINib(nibName: nibId, bundle: Bundle.main)
            self.register(uiNib, forCellReuseIdentifier: nibId)
        }
    }
    
}

