//
//  ShoppingSessionService.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation

class ShoppingSessionService {
    
    static let shared = ShoppingSessionService()
    
    init() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ShoppingSessionService.didUpdateLocation(notification:)),
                       name: BuddySettings.locationUpdatedNotification, object: nil)
    }
    
    
    fileprivate var _currentSession : ShoppingSession?
    var currentSession : ShoppingSession {
        if _currentSession == nil {
            _currentSession = ShoppingSession()
            guessLocationAndOverwriteCurrentSessionLocation()
        }
        
        return _currentSession!
    }
    
    func saveCurrentSession() {
        StorageService.storeCurrentSession(session: currentSession)
    }
    
    func restore(archivedSession session: ShoppingSession) {
        _currentSession = session
        guessLocationAndOverwriteCurrentSessionLocation()
        saveCurrentSession()
    }
    
    func restoreCurrentSession() {
        if let session = StorageService.getCurrentSession() {
            _currentSession = session
            guessLocationAndOverwriteCurrentSessionLocation()
        }
    }
    
    func clearCurrentSession() {
        _currentSession = nil
        saveCurrentSession()
    }
    
    
    @objc func didUpdateLocation(notification: Notification) {
        guard currentSession.location == nil else {
            return
        }
        
        guessLocationAndOverwriteCurrentSessionLocation()
    }
    
    
    func guessLocationAndOverwriteCurrentSessionLocation() {
        guard !currentSession.isUserSpecifiedLocation else { return }
        
        PlacesService.shared.requestBestGuessForLocation().then { (venue) -> Void in
            self.currentSession.location = venue
            self.saveCurrentSession()
            NotificationCenter.default.post(name: BuddySettings.currentSessionLocationUpdated, object: nil)
        }.catch { (error) -> Void in
            return
        }
    }
    
    
    func setLocationOverride(newLocation: FoursquareVenue) {
        currentSession.location = newLocation
        currentSession.isUserSpecifiedLocation = true
        saveCurrentSession()
        NotificationCenter.default.post(name: BuddySettings.currentSessionLocationUpdated, object: nil)
    }

    
}
