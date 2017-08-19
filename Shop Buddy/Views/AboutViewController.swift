//
//  AboutViewController.swift
//  Shop Buddy
//
//  Created by Luke Harries on 13/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import StoreKit
import Whisper

enum AboutSections : Int {
    case themeConfig = 0
    case inAppPurchase
    case developerInfo
    
    static var count = AboutSections.developerInfo.rawValue + 1
}


class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InAppPurchaseActionCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Shop Buddy"
        setupInAppPurchases()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AboutViewController.didUpdateInAppPurchaseProducts(notification:)), name: InAppPurchaseService.productsRetrieved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AboutViewController.purchaseFailed(notification:)), name: InAppPurchaseService.purchaseFailedNotification, object: nil)
        

        
        

    }
    
    
    @objc func purchaseFailed(notification: Notification) {
        let message = Message(title: "Your in-app purchase could not be completed.", backgroundColor: UIColor.errorRed)
        // Show and hide a message after delay
        guard let navigationController = self.navigationController else { return }
        Whisper.show(whisper: message, to: navigationController, action: .present)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
            Whisper.hide(whisperFrom: navigationController)
        })

    }
    
    
    func didUpdateInAppPurchaseProducts(notification: Notification) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.register(nibs: [ContactInfoTableViewCell.cellId, ColourPickerTableViewCell.cellId, InAppPurchaseDescriptionCell.cellId, InAppPurchaseActionCell.cellId])
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 56
        tableView.reloadData()
    }
    
    var inAppPurchaseProducts : [InAppPurchaseProduct] {
        return InAppPurchaseService.shared.retrievedProducts
    }
    
    func setupInAppPurchases() {
//        InAppPurchaseService.shared.requestAndUpdateProductsIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionEnum = AboutSections(rawValue: section) else { return "" }
        
        switch sectionEnum {
        case .themeConfig:
            return "Select App Theme"
        case .inAppPurchase:
            return "In-App Purchases"
        case .developerInfo:
            return "About the Developer"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AboutSections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionEnum = AboutSections(rawValue: section) else { return 0 }
        
        switch sectionEnum {
        case .themeConfig:
            return 1
        case .inAppPurchase:
            let productCount = inAppPurchaseProducts.count
            
            if productCount == 0 {
                return 0
            } else {
                return (productCount * 2) + 1
            }
        case .developerInfo:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionEnum = AboutSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        var cell : UITableViewCell
        switch sectionEnum {
        case .themeConfig:
            cell = configurationCell(forIndex: indexPath, inTable: tableView)
        case .inAppPurchase:
            cell = inAppPurchaseCell(forIndex: indexPath, inTable: tableView)
        case .developerInfo:
            cell = developerInfoCell(forIndex: indexPath, inTable: tableView)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func configurationCell(forIndex indexPath: IndexPath, inTable table: UITableView) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ColourPickerTableViewCell.cellId, for: indexPath) as! ColourPickerTableViewCell
            return cell
        }
        
        return UITableViewCell()
    }
    
    func inAppPurchaseCell(forIndex indexPath: IndexPath, inTable table: UITableView) -> UITableViewCell {
        
        var productIndex : Int
        if indexPath.row % 2 == 1 {
            productIndex = (indexPath.row - 1) / 2
        } else {
            productIndex = indexPath.row / 2
        }
        
        
        
        if productIndex < self.inAppPurchaseProducts.count {
            let cellNumber = indexPath.row % 2
            
            let product = self.inAppPurchaseProducts[productIndex]
            
            if cellNumber == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: InAppPurchaseDescriptionCell.cellId, for: indexPath) as! InAppPurchaseDescriptionCell
                cell.headline.text = product.headline
                cell.descriptionLabel.text = product.description
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: InAppPurchaseActionCell.cellId, for: indexPath) as! InAppPurchaseActionCell
                cell.configure(product: product, delegate: self)
                
                cell.selectionStyle = .none
                return cell

            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: InAppPurchaseActionCell.cellId, for: indexPath) as! InAppPurchaseActionCell
            
            let title = "Restore Purchases"
            cell.configure(title: title, buttonLabel: "", delegate: self, hideButton: true)
            
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .blue
            
            return cell
        }
    }
    
    
    
    func developerInfoCell(forIndex indexPath: IndexPath, inTable table: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactInfoTableViewCell.cellId, for: indexPath) as! ContactInfoTableViewCell
        let title : String
        let image : UIImage
        let iconSize = CGSize(width: 28, height: 28)
        
        switch indexPath.row {
        case 0:
            title = "@lukeharriesnz"
            image = UIImage.fontAwesomeIcon(name: .twitter, textColor: UIColor.white, size: iconSize)
            cell.configure(title: title, image: image)

        case 1:
            title = "lukeharries.nz"
            image = UIImage.fontAwesomeIcon(name: .safari, textColor: UIColor.white, size: iconSize)
            cell.configure(title: title, image: image)

        case 2:
            title = "Luke Harries, 2017"
            image = UIImage.fontAwesomeIcon(name: .copyright, textColor: UIColor.white, size: iconSize)
            cell.configure(title: title, image: image)

            cell.accessoryType = .none
            cell.selectionStyle = .none
        default:
            return UITableViewCell()
        }
        
        return cell

    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let sectionEnum = AboutSections(rawValue: indexPath.section) else { return }
        
        switch sectionEnum {
        case .developerInfo:
            if indexPath.row == 0 {
                let twitterUrl = URL(string: "https://www.twitter.com/lukeharriesnz")!
                open(url: twitterUrl)
            } else if indexPath.row == 1 {
                let website = URL(string: "http://lukeharries.nz/")!
                open(url: website)
            }
        case .inAppPurchase:
            if indexPath.row == (self.inAppPurchaseProducts.count * 2) {
                InAppPurchaseService.shared.restorePurchases()
            }
        default:
            break
        }
    }
    
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        }
        
    }
    
    func inAppPurchaseActionCell(_ cell: InAppPurchaseActionCell, didTapActionButton tapped: Bool) {
        if let product = cell.product {
            InAppPurchaseService.shared.buyProduct(product.product)
        }
        
        print("Did tap purchase")
    }
}
