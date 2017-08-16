//
//  StorageService.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit
import JSONCodable

class StorageService {
    
    static var archivedSessionsKey = "shopbuddy_sessions"
    static var currentSessionKey = "shopbuddy_currentsessions"
    static var accentColourKey = "shopbuddy_accentColour"

    struct SessionList : JSONCodable {
        var sessions : [ShoppingSession]
        
        init(sessions: [ShoppingSession]) {
            self.sessions = sessions
        }
        
        init(object: JSONObject) throws {
            let decoder = JSONDecoder(object: object)
            sessions = try decoder.decode("sessions")
        }
        
        func toJSON() throws -> Any {
            return try JSONEncoder.create({ (encoder) -> Void in
                try encoder.encode(sessions, key: "sessions")
            })
        }
    }
    
    static func getAccentColour() -> ThemeOption {
        let value = UserDefaults.standard.integer(forKey: StorageService.accentColourKey)
        if let option = ThemeOption(rawValue: value) {
            return option
        }
        
        return ThemeOption(rawValue: 0)!
    }
    
    static func saveAccentColour(colour: ThemeOption) {
        UserDefaults.standard.set(colour.rawValue, forKey: StorageService.accentColourKey)
    }
    
    
    static func getCurrentSession() -> ShoppingSession? {
        guard let data = UserDefaults.standard.string(forKey: StorageService.currentSessionKey) else {
            return nil
        }
        
        do {
            let session = try ShoppingSession(JSONString: data)
            return session
        } catch {
            return nil
        }
    }
    
    static func storeCurrentSession(session: ShoppingSession) {
        do {
            let data = try session.toJSONString()
            UserDefaults.standard.set(data, forKey: StorageService.currentSessionKey)
        } catch {
            return
        }
    }
    
    static func getArchivedSessions() -> [ShoppingSession] {
        guard let data = UserDefaults.standard.string(forKey: StorageService.archivedSessionsKey) else {
            return [ShoppingSession]()
        }
        
        do {
            let sessionList = try SessionList(JSONString: data)
            return sessionList.sessions
        } catch {
            return [ShoppingSession]()
        }
    }
    
    fileprivate static func storeArchivedSessions(_ sessions: [ShoppingSession]) {
        do {
            let sessionList = SessionList(sessions: sessions)
            let data = try sessionList.toJSONString()
            UserDefaults.standard.set(data, forKey: StorageService.archivedSessionsKey)
        } catch {
            return
        }
    }
    
    static func addSessionToArchive(session : ShoppingSession) {
        var sessions = StorageService.getArchivedSessions()
        sessions.append(session)
        StorageService.storeArchivedSessions(sessions)
    }
    
    static func removeSessionFromArchive(withID id : UUID) {
        let sessions = StorageService.getArchivedSessions()
        let filteredSessions = sessions.filter { $0.sessionId != id }
        StorageService.storeArchivedSessions(filteredSessions)
    }
    
    
}
