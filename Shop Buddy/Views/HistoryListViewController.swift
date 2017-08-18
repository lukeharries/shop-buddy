//
//  HistoryListViewController.swift
//  Shop Buddy
//
//  Created by Luke Harries on 13/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

class HistoryListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupTableView()
    }

    fileprivate var _archivedSessions :  [ShoppingSession]?
    var archivedSessions : [ShoppingSession] {
        if _archivedSessions == nil {
            _archivedSessions = StorageService.getArchivedSessions()
        }

        return _archivedSessions!
    }
    func clearArchiveCache() {
        _archivedSessions = nil
    }
    
    
    func setupTableView() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        tableView.reloadData()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 56
        
        showMessageIfTableIsEmpty()
    }
    
    func showMessageIfTableIsEmpty() {
        if archivedSessions.count == 0 {
            let message = "No saved lists."
            
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            messageLabel.text = message
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            return
        } else {
            tableView.backgroundView = nil
            return
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archivedSessions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedSessionTableViewCell", for: indexPath) as! SavedSessionTableViewCell

        let session = archivedSessions[indexPath.row]
        cell.configure(withSession: session)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let itemToRemove = archivedSessions[indexPath.row]
            StorageService.removeSessionFromArchive(withID: itemToRemove.sessionId)
            clearArchiveCache()
            tableView.deleteRows(at: [indexPath], with: .fade)
            showMessageIfTableIsEmpty()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "historicalSessionDetailSegue" {
            if let destination = segue.destination as? HistoricalSessionViewController,
                let selectedIndex = tableView.indexPathForSelectedRow {
                let session = archivedSessions[selectedIndex.row]
                destination.setSession(session: session)
            }
        }
    }
    

}
