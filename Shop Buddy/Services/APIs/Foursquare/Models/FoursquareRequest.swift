//
//  FoursquareRequest.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

class FoursquareRequest {
    
    var version : String = "20170814"
    var mode : String  = "foursquare"
    var client_id : String  = BuddySettings.foursquareClientId
    var client_secret : String  = BuddySettings.foursquareClientSecret
    
    
    func requestParameters() -> [String : Any] {
        var params = [String : Any]()
        
        params["client_id"] = client_id
        params["client_secret"] = client_secret
        
        params["v"] = version
        params["m"] = mode
        return params
    }
}

