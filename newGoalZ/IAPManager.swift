//
//  IAPManager.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/16/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    case failed
    case other
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "Your purchase has been cancelled!"
        case .other: return "An unknown error has occurred"
        }
    }
}


class IAPManager: NSObject {
    static let shared = IAPManager()
    
    static var featureEnabled: Bool{
        if let enabled = (UserDefaults.standard.value(forKey: "FEATURE_ENABLED") as? Bool){
            return enabled
        }
        return false
    }
    
    static func setFeatureEnabled(_ enabled: Bool){
        UserDefaults.standard.setValue(enabled, forKey: "FEATURE_ENABLED")
        UserDefaults.standard.synchronize()
    }
    
    let IAP_PRODUCT_ID = "ApplePayTester.PleaseWork.1231" ////"Put the IAP product id here"
    
    fileprivate var productID = String()
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        // Put here your IAP Products ID's
        let SmallCoins = "GOALZ.SmallCoins.099"
        let MedCoins = "GOALZ.mediumCoinPackage.5.00"
        let LargeCoins = "GOALZ.ultimatecoinpackage.50.00"
        let productIdentifiers = NSSet(objects: SmallCoins,MedCoins,LargeCoins)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPManager: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print( response.products.count)
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print(queue.transactions.count)
        
        var count = Int()
        
        for transaction:AnyObject in queue.transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .restored:
                    count += 1
                    break
                default:
                    break
                }
            }
        }
        
        if count > 0{
            purchaseStatusBlock?(.restored)
        }else{
            purchaseStatusBlock?(.other)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        purchaseStatusBlock?(.other)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    break
                    
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.failed)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.restored)
                    break
                    
                default:
                    break
                }
            }
        }
    }
}
