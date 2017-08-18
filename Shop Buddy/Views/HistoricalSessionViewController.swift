//
//  HistoricalSessionViewController.swift
//  Shop Buddy
//
//  Created by Luke Harries on 13/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit

class HistoricalSessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var useListButton: UIBarButtonItem!
    
    
    var pageSession: ShoppingSession?
    func setSession(session: ShoppingSession) {
        pageSession = session
        if let date = session.sessionDate {
            self.title = DateHelper.shared.format(date: date)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeader()
        applyStyle()
        toolbar.tintColor = UIColor.accent
    }
    
    func applyStyle() {
        headerView.backgroundColor = UIColor.accent
    }
    
    
    func setupHeader() {
        totalLabel.text = CurrencyHelper.shared.format(priceInCents: pageSession?.sessionTotalCents ?? 0)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, toolbar.frame.height, 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 56
        
        tableView.reloadData()
    }
    
    @IBAction func useListAction(_ sender: Any) {
        
        if ShoppingSessionService.shared.currentSession.items.count > 0 {
            let alert = UIAlertController(title: "Clear Current Session", message: "Do you want to overwrite your current items?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                return
            }
            let clearAction = UIAlertAction(title: "Overwrite", style: .destructive) { _ in
                self.useList()
                return
            }
            alert.addAction(cancelAction)
            alert.addAction(clearAction)
            present(alert, animated: true, completion: nil)
        } else {
            useList()
        }
    }
    
    func useList() {
        guard let session = pageSession, let navigationController = self.navigationController else { return }
        
        let newSession = ShoppingSession(session: session)
        newSession.sessionDate = Date()
        
        ShoppingSessionService.shared.restore(archivedSession: newSession)
        
        if let buddyListVC = navigationController.viewControllers.first as? BuddyListViewController {
            buddyListVC.tableView.reloadData()
            buddyListVC.updateSessionTotal()
            buddyListVC.showMessageIfTableIsEmpty()
        }
        
        navigationController.popToRootViewController(animated: true)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageSession?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as? ShoppingItemCell,
            let item = pageSession?.items[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.populate(withItem: item)
        return cell
    }
    


}
