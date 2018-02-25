//
//  PlacesService.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import QuadratTouch
import CoreLocation
import PromiseKit

enum PlacesServiceError : Error {
    case noLocation
}

class PlacesService : NSObject, CLLocationManagerDelegate {
    
    static let shared = PlacesService()
    
    var fsqSession : Session {
        return Session.sharedSession()
    }
    
    var locationManager : CLLocationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        NotificationCenter.default.post(name: BuddySettings.locationUpdatedNotification, object: self.currentLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.distanceFilter = CLLocationDistance(exactly: 0.75)!
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        setupFoursquareSession()
    }
    
    func setupFoursquareSession() {
        let client = Client(clientID: BuddySettings.foursquareClientId,
                            clientSecret: BuddySettings.foursquareClientSecret,
                            redirectURL: "")
        let configuration = Configuration(client:client)
        Session.setupSharedSessionWithConfiguration(configuration)
    }
    
    
    func authorizeLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    
    var bestGuessSearch : Promise<FoursquareVenue?>?

    func requestBestGuessForLocation(withRetryAttempts retryAttempts: Int = 0) -> Promise<FoursquareVenue?> {
        guard CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            return Promise<FoursquareVenue?>(error: PlacesServiceError.noLocation)
        }

        guard bestGuessSearch == nil else {
            return bestGuessSearch!
        }
        
        guard let location = currentLocation else {
            if retryAttempts > 0 {
                return requestBestGuessForLocation(withRetryAttempts: retryAttempts - 1)
            } else {
                return Promise<FoursquareVenue?>(error: PlacesServiceError.noLocation)
            }
        }

        let latLongString = String(format: "%f,%f", location.coordinate.latitude, location.coordinate.longitude)
        let req = VenueRequest()
        req.ll = latLongString
        req.categoryId = "4bf58dd8d48988d1f9941735,4bf58dd8d48988d103951735"
        bestGuessSearch = FoursquareApi.shared.venueSearch(request: req).then(execute: { (venues) -> FoursquareVenue? in
            return venues.first
        })
        
        return bestGuessSearch!
    }
    
    var venueListSearch : Promise<[FoursquareVenue]>?


    func requestListOfPossibleLocations(withRetryAttempts retryAttempts: Int = 0) -> Promise<[FoursquareVenue]> {
        guard CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            return Promise<[FoursquareVenue]>(error: PlacesServiceError.noLocation)
        }
        
        guard venueListSearch == nil || venueListSearch?.isResolved == true else {
            return venueListSearch!
        }
        
        venueListSearch = nil
        
        guard let location = currentLocation else {
            if retryAttempts > 0 {
                return requestListOfPossibleLocations(withRetryAttempts: retryAttempts - 1)
            } else {
                return Promise<[FoursquareVenue]>(error: PlacesServiceError.noLocation)
            }
        }
        
        let latLongString = String(format: "%f,%f", location.coordinate.latitude, location.coordinate.longitude)
        let req = VenueRequest()
        req.ll = latLongString
        req.limit = "30"
//        req.categoryId = "4bf58dd8d48988d1f9941735,4bf58dd8d48988d103951735"
        venueListSearch = FoursquareApi.shared.venueSearch(request: req)
        
        return venueListSearch!
    }
    
    
    func updateLocation() {
        self.locationManager.requestLocation()
    }
    
}
