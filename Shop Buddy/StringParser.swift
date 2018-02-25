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
    
    static var numberFormatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current
        formatter.generatesDecimalNumbers = true
        formatter.currencyDecimalSeparator = NSLocale.current.decimalSeparator
        return formatter
    }
    
    
    static var numberToStringFormatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current
        formatter.generatesDecimalNumbers = true
        formatter.currencyDecimalSeparator = NSLocale.current.decimalSeparator
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    static func getPriceInCents(fromString string: String?) throws -> Int {
        guard let nonNilString = string, !nonNilString.isEmpty else {
            throw StringParserError.invalidPriceString
        }
        
        guard let decimalNumber = numberFormatter.number(from: nonNilString)?.decimalValue else {
            throw StringParserError.invalidPriceString
        }
        
        let decimal = decimalNumber as NSDecimalNumber
        let centsDecimal = decimal.multiplying(byPowerOf10: 2)
        let centsInt = centsDecimal.intValue
        return centsInt
    }
    
    static func getUnits(fromString string: String?) throws -> Double {
        guard let nonNilString = string, !nonNilString.isEmpty else {
            throw StringParserError.invalidUnitsString
        }
        
        guard let double = numberFormatter.number(from: nonNilString)?.doubleValue else {
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
