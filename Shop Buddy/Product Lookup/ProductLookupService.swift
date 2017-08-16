////
////  ProductLookupService.swift
////  Shop Buddy
////
////  Created by Luke Harries on 12/08/17.
////  Copyright © 2017 Luke Harries. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import PromiseKit
//
//enum ProductLookupError: Error {
//    case noResults
//}
//
//class ProductLookupService {
//    
//    static func lookupProduct(withBarcode barcode: String) -> Promise<Product> {
//        return Promise<Product> { fulfill, reject in
//            let request = UpcLookupRequest(upc: barcode)
//            let parameters : [String: Any] = [
//                "upc_code" : request.upc_code,
//                "app_key" : request.app_key,
//                "signature" : request.signature,
//                "language" : request.language,
//            ]
//            
//            Alamofire.request(BuddySettings.digitEyesBaseUrl, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
//                debugPrint(response)
//
//                if let json = response.result.value {
//                    print("JSON: \(json)")
//                }
//            }
//
//            
//            
//        }
//        
//    }
//    
//}

