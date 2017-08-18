//
//  LocationPickerTableManager.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import PromiseKit

class LocationPickerTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        self.activityIndicator = NVActivityIndicatorView(frame: frame,
                                                         type: .ballGridBeat,
                                                         color: UIColor.white.withAlphaComponent(0.4),
                                                         padding: nil)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        self.tableView.register(nibs: [LocationPickerCell.cellId])
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 56
        
        self.tableView.addSubview(refreshControl)
      

    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(LocationPickerTableManager.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.isHidden = true
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        _ = reloadLocationData()
    }
    
    var venues : [FoursquareVenue] = [FoursquareVenue]()
    
    var activityIndicator : NVActivityIndicatorView
    
    
    func reloadLocationData() -> Promise<Void> {
        
        tableView.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { (make) in
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.center.equalToSuperview()
        }
        
        self.activityIndicator.startAnimating()
        
        
        return PlacesService.shared.requestListOfPossibleLocations(withRetryAttempts: 3).then { (venues) -> Void in
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
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
