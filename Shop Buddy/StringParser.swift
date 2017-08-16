//
//  StringParser.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

enum StringParserError : Error {
    case invalidPriceString
    case invalidUnitsString
}

class StringParser {
    
    
    static func getPriceInCents(fromString string: String?) throws -> Int {
        guard let nonNilString = string, !nonNilString.isEmpty else {
            throw StringParserError.invalidPriceString
        }
        
        guard let double = NumberFormatter().number(from: nonNilString)?.doubleValue else {
            throw StringParserError.invalidPriceString
        }
        
        let decimal = NSDecimalNumber(value: double)
        let centsDecimal = decimal.multiplying(byPowerOf10: 2)
        let centsInt = centsDecimal.intValue
        return centsInt
    }
    
    static func getUnits(fromString string: String?) throws -> Double {
        guard let nonNilString = string, !nonNilString.isEmpty else {
            throw StringParserError.invalidUnitsString
        }
        
        guard let double = NumberFormatter().number(from: nonNilString)?.doubleValue else {
            throw StringParserError.invalidUnitsString
        }
        
        return double
    }
    
    
    
    static func validatePriceString(_ string: String?) -> Bool {
        do {
            _ = try getPriceInCents(fromString: string)
            return true
        } catch {
            return false
        }
    }
    
    static func validateUnitsString(_ string: String?) -> Bool {
        do {
            _ = try getUnits(fromString: string)
            return true
        } catch {
            return false
        }
    }
    
    
}
