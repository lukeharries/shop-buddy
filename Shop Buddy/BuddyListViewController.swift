//
//  BuddyListViewController.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import UIKit
import GoogleMobileAds
import NVActivityIndicatorView

class BuddyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddItemViewControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate {
    
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var sessionTotalLabel: UILabel!
    @IBOutlet weak var sessionTotalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemButton: UIButton!
    
    @IBOutlet weak var buttonBarBackgroundView: UIView!
    
    @IBOutlet weak var aboutButton: CentredButton!
    @IBOutlet weak var historyButton: CentredButton!
    @IBOutlet weak var saveButton: CentredButton!
    @IBOutlet weak var clearButton: CentredButton!
    
    @IBOutlet weak var toastContainerView: UIView!
    @IBOutlet weak var toastLabel: UILabel!
    
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var locationPickerContainerView: UIView!
    @IBOutlet weak var locationPickerTableView: UITableView!
    
    var locationPickerTableManager : LocationPickerTableManager!
    
    @IBOutlet weak var bannerAdView : GADBannerView!
    var interstitialAd: GADInterstitial!

    var itemsAddedSinceLastAd : Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationListeners()
        updateSessionTotal()
        styleButtons()
        styleLocationButton()
        setupLocationPickerTable()
        
        toastContainerView.isHidden = true
        locationContainerView.isHidden = true
        locationPickerContainerView.isHidden = true
        bannerAdView.isHidden = true
        
        setupAds()
        interstitialAd = createAndLoadInterstitial()
    }
    
    func setupNotificationListeners() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(BuddyListViewController.colourChanged(notification:)),
                       name: BuddySettings.colourChangedNotification, object: nil)
        nc.addObserver(self, selector: #selector(BuddyListViewController.didUpdateCurrentSessionLocation(notification:)),
                       name: BuddySettings.currentSessionLocationUpdated, object: nil)
        nc.addObserver(self, selector: #selector(BuddyListViewController.networkDidBecomeReachable(notification:)), name: BuddySettings.networkBecameReachableNotification, object: nil)
        nc.addObserver(self, selector: #selector(BuddyListViewController.didPurchaseProduct(notification:)), name: InAppPurchaseService.purchaseNotification, object: nil)
        
        
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        locationContainerView.isHidden = ShoppingSessionService.shared.currentSession.location == nil
        locationButton.setTitle(ShoppingSessionService.shared.currentSession.location?.name, for: .normal)

        setupTableView()
        
        itemsAddedSinceLastAd = 0
        
        if BuddySettings.shouldShowAds {
            interstitialAd = createAndLoadInterstitial()
            loadBannerAdIfAdsEnabled()
        } else {
            bannerAdView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateColour(animated: true)
        
    }
    

    // MARK: - Ad
    
    @objc func didPurchaseProduct(notification: Notification) {
        if !BuddySettings.shouldShowAds {
            self.bannerAdView.isHidden = true
        }
    }
    
    func setupAds() {
        bannerAdView.adSize = kGADAdSizeSmartBannerPortrait
        bannerAdView.delegate = self
        bannerAdView.adUnitID = BuddySettings.AdMobSettings.bannerAdId
        bannerAdView.rootViewController = self
    }
    
    func loadBannerAdIfAdsEnabled() {
        guard BuddySettings.shouldShowAds else {
            self.bannerAdView.isHidden = true
            return
        }
        
        let request = GADRequest()
        request.testDevices = BuddySettings.AdMobSettings.testDevices
        bannerAdView.load(request)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        guard BuddySettings.shouldShowAds else {
            self.bannerAdView.isHidden = true
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.bannerAdView.isHidden = false
        }, completion: nil)
        
    }
    
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: BuddySettings.AdMobSettings.interstitialAdId)
        interstitial.delegate = self
        
        let request = GADRequest()
        request.testDevices = BuddySettings.AdMobSettings.testDevices
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createAndLoadInterstitial()
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        dismiss(animated: true) {
            self.interstitialAd = self.createAndLoadInterstitial()
        }
    }
    
    // MARK: - Appearance
    
    @objc
    func colourChanged(notification: Notification) {
        updateColour(animated: true)
    }
    
    func updateColour(animated: Bool) {
        if let navController = self.navigationController {
            navController.navigationBar.tintColor = UIColor.accent
        }
        
        if animated {
            UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
                self.locationContainerView.backgroundColor = UIColor.accent
                self.locationButton.backgroundColor = UIColor.accent
                self.sessionTotalView.backgroundColor = UIColor.accent
                self.buttonBarBackgroundView.backgroundColor = UIColor.accent
                self.toastContainerView.backgroundColor = UIColor.accent
                self.addItemButton.backgroundColor = UIColor.accent
                self.locationPickerContainerView.backgroundColor = UIColor.accent
                self.locationPickerTableView.backgroundColor = UIColor.accent

            }, completion: nil)
        } else {
            self.locationContainerView.backgroundColor = UIColor.accent
            self.locationButton.backgroundColor = UIColor.accent
            self.sessionTotalView.backgroundColor = UIColor.accent
            self.buttonBarBackgroundView.backgroundColor = UIColor.accent
            self.toastContainerView.backgroundColor = UIColor.accent
            self.addItemButton.backgroundColor = UIColor.accent
            self.locationPickerContainerView.backgroundColor = UIColor.accent
            self.locationPickerTableView.backgroundColor = UIColor.accent

        }
    }
    
    
    func setupTableView() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        showMessageIfTableIsEmpty()
    }
    
    func styleButtons() {
        let buttons : [UIButton] = [aboutButton, historyButton, saveButton, clearButton, locationButton]
        let tintColour = UIColor.white
        let highlightColour = UIColor.white.withAlphaComponent(0.5)
        
        for button in buttons {
            button.tintColor = tintColour
            button.setTitleColor(tintColour, for: .normal)
            button.setTitleColor(highlightColour, for: .highlighted)
            button.setTitleColor(highlightColour, for: .disabled)
            
            if let image = button.image(for: .normal) {
                button.setImage(image.recolour(as: highlightColour), for: .highlighted)
            }
        }
    }
    
    func styleLocationButton() {
        locationButton.layer.cornerRadius = 8.0
        locationButton.tintColor = UIColor.white
        locationButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    // MARK: - Button Actions
    
    
    @IBAction func clearListAction(_ sender: Any) {
        if ShoppingSessionService.shared.currentSession.items.count == 0 {
            // Nothing to clear
            return
        }
        
        let alert = UIAlertController(title: "Clear Current Session", message: "Do you want to clear everything from your current list?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        }
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.clearCurrentSession()
            return
        }
        alert.addAction(cancelAction)
        alert.addAction(clearAction)
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func saveAction(_ sender: Any) {
        if ShoppingSessionService.shared.currentSession.items.count == 0 {
            displayToast(withMessage: "There is nothing to save.")
            return
        }
        
        saveCurrentSessionToArchive()
    }
    
    @IBAction func showAboutAction(_ sender: Any) {
        print("show about")
        fatalError()
    }
    
    
    // MARK: - Location
    
    @objc func networkDidBecomeReachable(notification: Notification) {
        if ShoppingSessionService.shared.currentSession.location == nil {
            ShoppingSessionService.shared.guessLocationAndOverwriteCurrentSessionLocation()
        }

        locationPickerTableManager.reloadLocationData()
    }
    
    func setupLocationPickerTable() {
        locationPickerTableManager = LocationPickerTableManager(tableView: locationPickerTableView)
        
        locationPickerContainerView.backgroundColor = UIColor.accent
        locationPickerTableView.layer.cornerRadius = 8.0
    }
    
    
    
    @IBAction func didTapLocationPickerButton(_ sender: Any) {
        if !locationTableTransitionInProgress {
            self.toggleLocationTableVisible()
        }
    }

    
    @objc func didUpdateCurrentSessionLocation(notification: Notification) {
        if let venue = ShoppingSessionService.shared.currentSession.location {
            self.locationButton.setTitle(venue.name, for: .normal)
            
            self.setLocationTableVisible(visible: false)

            if self.locationContainerView.isHidden {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.locationContainerView.isHidden = false
                }, completion: nil)
            }
            return
        } else {
            if !self.locationContainerView.isHidden {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.locationContainerView.isHidden = true
                }, completion: nil)
            }
        }
    }

    
    var locationTableTransitionInProgress = false
    
    func toggleLocationTableVisible() {
        setLocationTableVisible(visible: self.locationPickerContainerView.isHidden)
    }
    
    func setLocationTableVisible(visible: Bool) {
        if visible {
            locationPickerTableManager.reloadLocationData()
            
            if !self.locationPickerContainerView.isHidden {
                return
            }
            
            locationTableTransitionInProgress = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.locationPickerContainerView.isHidden = false
                
                self.tableView.isHidden = true
                self.buttonBarBackgroundView.isHidden = true
                self.addItemButton.isHidden = true
                
            }, completion: { _ in
                self.locationTableTransitionInProgress = false
            })
        } else {
            if self.locationPickerContainerView.isHidden {
                return
            }

            locationTableTransitionInProgress = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.locationPickerContainerView.isHidden = true
                
                self.tableView.isHidden = false
                self.buttonBarBackgroundView.isHidden = false
                self.addItemButton.isHidden = false
            }, completion: { _ in
                self.locationTableTransitionInProgress = false
            })
        }
    }
    
    
    // MARK: - Session Actions
    
    func clearCurrentSession() {
    ShoppingSessionService.shared.clearCurrentSession()
        self.tableView.reloadData()
        showMessageIfTableIsEmpty()
        updateSessionTotal()
    }


    
    
    func showMessageIfTableIsEmpty() {
        if ShoppingSessionService.shared.currentSession.items.count == 0 {
            let message = "No items to show. \nTo begin, tap \"Add Item\" below."
            
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
    
    
    var toastEndTask : DispatchWorkItem?
    
    func displayToast(withMessage message: String) {
        if toastEndTask != nil && toastEndTask?.isCancelled != true {
            toastEndTask!.cancel()
        }
        
        toastLabel.text = message
        
        toastEndTask = DispatchWorkItem {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.toastContainerView.isHidden = true
            }, completion: nil)
        }
        
        if !toastContainerView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: toastEndTask!)
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.toastContainerView.isHidden = false
            }, completion: { (completed) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: self.toastEndTask!)
            })
        }
    }
    
    // MARK: - Save
    
    func saveCurrentSessionToArchive() {

        archiveAndStartNewSession()
        
        
    }
    
    
    
    func archiveAndStartNewSession() {
        let sessionToSave = ShoppingSessionService.shared.currentSession
        
        StorageService.addSessionToArchive(session: sessionToSave)
        ShoppingSessionService.shared.clearCurrentSession()
        
        self.tableView.reloadData()
        showMessageIfTableIsEmpty()
        updateSessionTotal()
        
        let message = "Your session has been saved. \nYou can view it in the History list."
        displayToast(withMessage: message)
    }

    
    
    func updateSessionTotal() {
        let session = ShoppingSessionService.shared.currentSession
        let totalString = CurrencyHelper.shared.format(priceInCents: session.sessionTotalCents)
        sessionTotalLabel.text = totalString
    }
    
    

    func addItemViewController(didFinish sender: AddItemViewController, cancelled: Bool) {
        tableView.reloadData()
        showMessageIfTableIsEmpty()
        updateSessionTotal()
        dismiss(animated: true) {
            
            if BuddySettings.shouldShowAds && !cancelled {
                self.itemsAddedSinceLastAd += 1
                
                if self.itemsAddedSinceLastAd >= BuddySettings.AdMobSettings.interstitialFrequency {
                    if self.interstitialAd != nil && self.interstitialAd?.isReady == true {
                        self.itemsAddedSinceLastAd = 0
                        self.interstitialAd!.present(fromRootViewController: self)
                    } else {
                        self.interstitialAd = self.createAndLoadInterstitial()
                    }
                }
                
            } else {
                return
            }
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingSessionService.shared.currentSession.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as? ShoppingItemCell else {
            return UITableViewCell()
        }
        let shoppingItem = ShoppingSessionService.shared.currentSession.items[indexPath.row]
        cell.populate(withItem: shoppingItem)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let shoppingItem = ShoppingSessionService.shared.currentSession.items[indexPath.row]
        ShoppingSessionService.shared.currentSession.removeItem(withId: shoppingItem.id)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        updateSessionTotal()
        return
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addItemPopupSegue" {
            if let popup = segue.destination as? AddItemViewController {
                popup.delegate = self
            }
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

