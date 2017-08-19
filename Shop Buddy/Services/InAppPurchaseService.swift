//
//  InAppPurchaseService.swift
//  Shop Buddy
//
//  Created by Luke Harries on 14/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class InAppPurchaseService: NSObject {
    
    static let shared = InAppPurchaseService()

    static let productsRetrieved = NSNotification.Name(rawValue: "IAPHelperProductsRetrieved")
    static let purchaseNotification = NSNotification.Name(rawValue: "IAPHelperPurchaseNotification")
    static let purchaseFailedNotification = NSNotification.Name(rawValue: "IAPHelperPurchaseFailedNotification")
    
    var retrievedProducts : [InAppPurchaseProduct] = [InAppPurchaseProduct]()

    static let adFreeProduct = "nz.co.lukeharries.shopbuddy.premium_ad_free"
    
    
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    override init() {
        productIdentifiers = [InAppPurchaseService.adFreeProduct]

        super.init()
        SKPaymentQueue.default().add(self)
        
        setupProductRequestCompletionHandler()
        
        NotificationCenter.default.addObserver(self, selector: #selector(InAppPurchaseService.appBecameReachable(notification:)), name: BuddySettings.networkBecameReachableNotification, object: nil)
        
        for productIdentifier in productIdentifiers {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
            }
        }
        
        requestAndUpdateProductsIfNeeded()
    }
    
    
    func setupProductRequestCompletionHandler() {
        self.productsRequestCompletionHandler = { (success, products) in
            guard let confirmedProducts = products else {
                return
            }
            
            self.retrievedProducts.removeAll()
            
            for product in confirmedProducts {
                var headline = ""
                var description = ""
                if product.productIdentifier == InAppPurchaseService.adFreeProduct {
                    headline = "Hate ads?"
                    description = "Remove them with this In-App Purchase, and support the development of this app."
                }
                
                let appProduct = InAppPurchaseProduct(headline: headline, description: description, product: product)
                appProduct.purchased = self.isProductPurchased(product.productIdentifier)
                self.retrievedProducts.append(appProduct)
            }
            
            NotificationCenter.default.post(name: InAppPurchaseService.productsRetrieved, object: nil)
        }
    }
    
    
    @objc func appBecameReachable(notification: Notification) {
        requestAndUpdateProductsIfNeeded()
    }
    
    public func requestAndUpdateProductsIfNeeded() {
        if self.retrievedProducts.count > 0 {
            return
        }
        
        guard productsRequestCompletionHandler != nil else { return }
        
        self.requestProducts(completionHandler: productsRequestCompletionHandler!)
    }
    
    
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
}


extension InAppPurchaseService: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequest()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequest()
    }
    
    private func clearRequest() {
        productsRequest = nil
    }
}


extension InAppPurchaseService: SKPaymentTransactionObserver {
    
    
    public func checkIfProductIsDeferred(identifier: String?) -> Bool {
        if SKPaymentQueue.default().transactions.count > 0 {
            for transaction in SKPaymentQueue.default().transactions {
                if (identifier ?? "") == transaction.payment.productIdentifier {
                    if transaction.transactionState == .deferred || transaction.transactionState == .failed {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        deliverPurchaseFailureNotification()
        
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: InAppPurchaseService.purchaseNotification, object: identifier)
    }
    
    private func deliverPurchaseFailureNotification() {
        NotificationCenter.default.post(name: InAppPurchaseService.purchaseFailedNotification, object: nil)
    }
}

