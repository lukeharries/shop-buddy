//
//  VenueRequest.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

class VenueRequest : FoursquareRequest {
    
    var ll : String?
    var query : String?

    var limit : String = "5"
    var categoryId : String?

    override func requestParameters() -> [String : Any] {
        var params = super.requestParameters()
        
        if ll != nil {
            params["ll"] = ll!
        }
        
        if query != nil {
            params["query"] = query!
        }
        
        if categoryId != nil {
            params["categoryId"] = categoryId!
        }
        
        params["limit"] = limit
        
        return params
    }
    
    
}
