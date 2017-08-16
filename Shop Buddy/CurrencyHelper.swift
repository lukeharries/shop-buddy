//
//  CurrencyHelper.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

class CurrencyHelper {
    
    static let shared = CurrencyHelper()
    
    let formatter : NumberFormatter

    
    init() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        self.formatter = formatter
    }

    func format(priceInCents price: Int) -> String {
        let cents = NSDecimalNumber(value: price)
        let price = cents.multiplying(byPowerOf10: -2)
        
        if let priceString = formatter.string(from: price) {
            return priceString
        } else {
            assertionFailure("Could not format price")
            return ""
        }
    }
    
    func formatComponents(priceInCents price: Int) -> (String, String?) {
        let cents = NSDecimalNumber(value: price)
        let price = cents.multiplying(byPowerOf10: -2)
        
        if let priceString = formatter.string(from: price) {
            guard let separator = formatter.currencyDecimalSeparator else {
                return (priceString, nil)
            }
            
            let components = priceString.components(separatedBy: separator)
            guard components.count == 2 else {
                assertionFailure("Could not format price")
                return ("","")
            }
            
            let basePrice = components[0]
            let cents = String(format: "%@%@", separator, components[1])

            return (basePrice, cents)
        } else {
            assertionFailure("Could not format price")
            return ("","")
        }
    }
}
