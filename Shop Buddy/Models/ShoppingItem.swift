//
//  ShoppingItem.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import JSONCodable

let JSONTransformerStringToUUID = JSONTransformer<String, UUID>(
    decoding: {UUID(uuidString: $0)},
    encoding: {$0.uuidString})

class ShoppingItem : JSONCodable {
    
    let id : UUID
    let product : Product
    var unitPriceCents : Int
    var units : Double
    
    
    var totalPriceCents : Int {
        let unitPriceCentsDouble = Double(self.unitPriceCents)
        let totalPriceCentsDouble = units * unitPriceCentsDouble
        let roundedPrice = Int(ceil(totalPriceCentsDouble))
        return roundedPrice
    }
    
    
    init(product: Product, unitPriceCents: Int, units: Double) {
        self.id = UUID()
        self.product = product
        self.unitPriceCents = unitPriceCents
        self.units = units
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        id = try decoder.decode("id", transformer: JSONTransformerStringToUUID)
        product = try decoder.decode("product")
        unitPriceCents = try decoder.decode("unitPriceCents")
        units = try decoder.decode("units")
    }
    
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(units, key: "units")
            try encoder.encode(unitPriceCents, key: "unitPriceCents")
            try encoder.encode(product, key: "product")
            try encoder.encode(id, key: "id", transformer: JSONTransformerStringToUUID)
        })
    }
}
