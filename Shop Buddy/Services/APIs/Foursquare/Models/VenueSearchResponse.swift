//
//  VenueSearchResponse.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import ObjectMapper

class VenueSearchResponse: Mappable {
    var meta : Meta!
    var response : VenueListResponse!
    
    // Mappable
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        meta <- map["meta"]
        response <- map["response"]
    }
}

class Meta : Mappable {
    var code : Int!
    var requestId : String!
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        requestId <- map["requestId"]
    }
}

class VenueListResponse : Mappable {
    var venues : [FoursquareVenue]?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        venues <- map["venues"]
    }
}
