//
//  DateHelper.swift
//  Shop Buddy
//
//  Created by Luke Harries on 13/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    let formatter : DateFormatter
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        self.formatter = formatter
    }
    
    
    func format(date: Date) -> String {        
        return formatter.string(from: date)
    }
    
}
