//
//  InAppPurchaseProduct.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseProduct {
    
    var headline : String
    var description : String
    
    var product : SKProduct
    
    var purchased : Bool = false
    
    var productName : String {
        return product.localizedTitle
    }
    
    var priceString : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        guard let priceStr = formatter.string(from: product.price)  else {
            assertionFailure()
            return ""
        }
        return priceStr
    }
    
    init(headline: String, description: String, product : SKProduct) {
        self.headline = headline
        self.description = description
        self.product = product
    }
}
