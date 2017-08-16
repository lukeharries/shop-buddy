//
//  FoursquareVenue.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import ObjectMapper
import JSONCodable

class FoursquareVenue : Mappable, JSONCodable {
    var id : String!
    var name : String!
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    

    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
    }

    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(id, key: "id")
            try encoder.encode(name, key: "name")
        })
    }
    
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
