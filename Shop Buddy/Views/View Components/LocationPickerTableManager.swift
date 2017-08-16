//
//  LocationPickerTableManager.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit

class LocationPickerTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        self.tableView.register(nibs: [LocationPickerCell.cellId])

    }
    
    var venues : [FoursquareVenue] = [FoursquareVenue]()
    
    
    
    
    func reloadLocationData() {
        PlacesService.shared.requestListOfPossibleLocations(withRetryAttempts: 3).then { (venues) -> Void in
            DispatchQueue.main.async{
                self.venues = venues
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationPickerCell.cellId, for: indexPath) as! LocationPickerCell
        cell.titleLabel.text = venues[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ShoppingSessionService.shared.setLocationOverride(newLocation: venues[indexPath.row])
        return
    }
    
    
    
}
