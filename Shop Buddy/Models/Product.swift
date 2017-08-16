//
//  Product.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import JSONCodable

class Product : JSONCodable {
    var name : String
    var description: String?
    var imageUrl : URL?
        
    init(name: String) {
        self.name = name
    }
    
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        name = try decoder.decode("name")
        description = try decoder.decode("description")
        imageUrl = try decoder.decode("imageUrl", transformer: JSONTransformers.StringToURL)
    }
    
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(name, key: "name")
            try encoder.encode(description, key: "description")
            try encoder.encode(imageUrl, key: "imageUrl", transformer: JSONTransformers.StringToURL)
        })
    }
}
