////
////  UpcLookupRequest.swift
////  Shop Buddy
////
////  Created by Luke Harries on 12/08/17.
////  Copyright © 2017 Luke Harries. All rights reserved.
////
//
//import Foundation
//
///*
// upc_code: is the UPC , EAN, GTIN, APN or JPN code for which information is desired;
// 2. app_key: is the application identification key of the party making the request;
// 3. signature: created using the upc_code and auth_key. Code examples are in Appendix D;
// 4. language: the two-character ISO language code for the preferred language of response
// 
// (“en”,”es”, etc.)
// */
//
//class UpcLookupRequest {
//    var upc_code : String
//    var app_key : String
//    var signature : String
//    var language : String = "en"
//    
//    init(upc: String) {
//        self.upc_code = upc
//        self.app_key = BuddySettings.digitEyesAppKey
//        
//        let nsUpc = upc as NSString
//        let signature = nsUpc.hashedValue(BuddySettings.digitEyesAuthKey) ?? ""
//        self.signature = signature as String
//    }
//}

