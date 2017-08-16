//
//  ReachabilityService.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import Alamofire

class ReachabilityService {
    
    static let shared = ReachabilityService()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "https://apple.com/")
    
    func listenForReachability() {
        self.reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status {
            case .reachable(_):
                NotificationCenter.default.post(name: BuddySettings.networkBecameReachableNotification, object: nil)
                break
            default:
                break
            }
        }
        
        self.reachabilityManager?.startListening()
    }
}
