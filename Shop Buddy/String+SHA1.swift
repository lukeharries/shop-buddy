//
//  String+SHA1.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

extension String {
    
    func hmacsha1(key: String) -> String? {
        let dataToDigest = self.data(using: String.Encoding.utf8)
        let keyData = key.data(using: String.Encoding.utf8)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), (keyData! as NSData).bytes, keyData!.count, (dataToDigest! as NSData).bytes, dataToDigest!.count, result)
        
        let data = Data(bytes: UnsafePointer<UInt8>(result), count: digestLength)
        
        let base64EncodedData = data.base64EncodedData(options: [])
        return NSString(data: base64EncodedData, encoding: String.Encoding.utf8.rawValue) as! String
        
//        return String(data: data, encoding: String.Encoding.utf8)
    }
}
