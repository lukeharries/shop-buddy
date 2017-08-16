//
//  ShoppingSession.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import JSONCodable


class ShoppingSession : JSONCodable {
    
    var sessionId: UUID
    var sessionDate : Date?
    var location : FoursquareVenue?
    
    var isUserSpecifiedLocation : Bool = false
    
    init() {
        sessionId = UUID()
    }
    
    init(session: ShoppingSession) {
        sessionId = UUID()
        self.location = session.location
        self._items = session._items
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        sessionId = try decoder.decode("sessionId", transformer: JSONTransformerStringToUUID)
        sessionDate = try decoder.decode("sessionDate", transformer: JSONTransformers.StringToDate)
        location = try decoder.decode("location")
        isUserSpecifiedLocation = try decoder.decode("isUserSpecifiedLocation")
    }
    
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(isUserSpecifiedLocation, key: "isUserSpecifiedLocation")
            try encoder.encode(location, key: "location")
            try encoder.encode(sessionDate, key: "sessionDate", transformer: JSONTransformers.StringToDate)
            try encoder.encode(sessionId, key: "sessionId", transformer: JSONTransformerStringToUUID)
        })
    }
    
    
    fileprivate var _items : [ShoppingItem] = [ShoppingItem]()
    var items : [ShoppingItem] {
        return _items.reversed()
    }
    
    var sessionTotalCents : Int {
        guard !items.isEmpty else { return 0 }
        let sessionTotal = items.reduce(0) { (total, nextItem) -> Int in
            return total + nextItem.totalPriceCents
        }
        return sessionTotal
    }
    
    func add(item: ShoppingItem) {
        if items.count == 0 {
            sessionDate = Date()
        }
        
        _items.append(item)
    }
    
    func removeItem(withId id: UUID) {
        if let index = _items.index(where: { $0.id == id }) {
            _items.remove(at: index)
        }
    }
    
    func update(item: ShoppingItem) {
        if let index = _items.index(where: { $0.id == item.id }) {
            _items.remove(at: index)
        }
        _items.append(item)
    }
    
}
