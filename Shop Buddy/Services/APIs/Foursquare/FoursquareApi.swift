//
//  FoursquareApi.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import AlamofireObjectMapper

enum FoursquareApiError : Error {
    case emptyResponse
}

class FoursquareApi {
    
    static let shared = FoursquareApi()
    
    static let foursquareApiBaseUrl = URL(string: "https://api.foursquare.com/v2/")!
    
    struct FSQEndpoints {
        static let venueSearch = "venues/search"
    }
    
    func venueSearch(request: VenueRequest) -> Promise<[FoursquareVenue]> {
        let requestUrl = FoursquareApi.foursquareApiBaseUrl.appendingPathComponent(FSQEndpoints.venueSearch)
        let parameters : Parameters = request.requestParameters()
        
        return Promise<[FoursquareVenue]> { fulfill, reject in
            Alamofire.request(requestUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseData(completionHandler: { (responseData) in
                
                switch responseData.result {
                case .success(let jsonData):
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves)
                        let searchResponse = VenueSearchResponse(JSON: json as! [String : Any])
                        let venues = searchResponse?.response.venues ?? []
                        fulfill(venues)
                        return
                    } catch {
                        reject(error)
                        return
                    }
                case .failure(let error):
                    reject(error)
                    return
                }
                
            })
                
                
                
//                .responseObject { (response: DataResponse<VenueSearchResponse>) in
//
//                switch response.result {
//                case .success(let data):
//                    let venues = data.response?.venues ?? []
//                    fulfill(venues)
//                case .failure(let error):
//                    reject(error)
//                    return
//                }
//            }
        }
    }
    
}


/*
 
 return Promise<[FoursquareVenue]> { fulfill, reject in
 Alamofire.request(requestUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseData(completionHandler: { (response) in
 
 switch response.result {
 case .success(let data):
 let decoder = JSONDecoder()
 do {
 let apiResponse = try decoder.decode(VenueSearchResponse.self, from: data) as? VenueSearchResponse
 guard let venues = apiResponse?.response.venues else {
 reject(FoursquareApiError.emptyResponse)
 return
 }
 
 fulfill(venues)
 return
 } catch {
 reject(error)
 return
 }
 case .failure(let error):
 reject(error)
 return
 }
 })
 
 }
 */
