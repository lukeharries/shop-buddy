//
//  BuddySettings.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import GoogleMobileAds

class BuddySettings {
    
    static var colourChangedNotification = Notification.Name(rawValue: "shopBuddyColourChanged")
    static var locationUpdatedNotification = Notification.Name(rawValue: "shopBuddyLocationUpdated")

    static var currentSessionLocationUpdated = Notification.Name(rawValue: "shopBuddyCurrentSessionLocationUpdated")

    static var networkBecameReachableNotification = Notification.Name(rawValue: "shopBuddyNetworkBecameReachable")

    
    static var foursquareClientId : String = "C5O502KR4HSFMR0SVZPV0M2ASWZUAC1S3ZTL4K2UMVSWCJTV"
    static var foursquareClientSecret : String = "A3VL5O0K1FYT3DGSZD3Q55AGOV1X41BDNUVDLORN00EDEVB5"
    
    
    static var scanningEnabled : Bool = false
    static var locationEnabled : Bool = true
    
    
    static var shouldShowAds : Bool {
        let paidToHideAds = InAppPurchaseService.shared.isProductPurchased(InAppPurchaseService.adFreeProduct)
        return !paidToHideAds
    }
        
    struct AdMobSettings {
        static let appId = "ca-app-pub-6360645230621222~3303433691"
        static let bannerAdId = "ca-app-pub-6360645230621222/7612367882"
        static let interstitialAdId = "ca-app-pub-6360645230621222/2868991872"
        static let historyInlineAd = "ca-app-pub-6360645230621222/4974079337"
        static let interstitialFrequency = 5
        
        static let testDevices = [AnyObject]()
//        [
//            kGADSimulatorID,
//            "3cb1d08d5d830180d4e54a4675e326e2" as AnyObject
//        ]
    }

}
