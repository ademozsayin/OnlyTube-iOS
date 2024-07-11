//
//  InAppPurchaseManager.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 11.07.2024.
//

import Foundation
import SwiftUI
import RevenueCat

@MainActor
@Observable final class InAppPurchaseManager {
    
    public static var shared = InAppPurchaseManager()
   
    var isSupporter: Bool = false {
        didSet {
            print("isSupporter: \(isSupporter)")
        }
    }
    
    private(set) var customerInfo: CustomerInfo?
    var loadingProducts: Bool = false
    private(set) var products: [StoreProduct] = []
    var subscription: StoreProduct?
    private(set) var subscriptions: [StoreProduct] = []
    
    var isProcessingPurchase: Bool = false
    var purchaseSuccessDisplayed: Bool = false
    var purchaseErrorDisplayed: Bool = false
    var restorePurchaseDisplayed: Bool = false
    private(set) var availablePackages: [Package] = []
    
    init() {

        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_UoVNogcNbQvbVhJdPtMSJJffSiF")
        Purchases.shared.getCustomerInfo { [weak self] info, _ in
            guard let self else { return }
//            if info?.entitlements["Supporter"]?.isActive == true {
                self.isSupporter = info?.entitlements["Supporter"]?.isActive ?? false
//            }
        }
    }
    
    func fetchStoreProducts() async {
        
        do {
           let offerings = try await Purchases.shared.offerings()
            self.subscriptions = offerings.offering(identifier: "Supporter")?.availablePackages.map{$0.storeProduct} ?? []
            self.subscription = offerings.offering(identifier: "Supporter")?.availablePackages.map{$0.storeProduct}.first
            self.products = offerings.offering(identifier: "Tips")?.availablePackages.map{$0.storeProduct} ?? []
            
            withAnimation {
                self.loadingProducts = false
            }
        } catch {
            print(error)
        }
    }
    
    func purchase(product: StoreProduct) async {
        if !isProcessingPurchase {
            isProcessingPurchase = true
            do {
                let result = try await Purchases.shared.purchase(product: product)
                print(result)
                if !result.userCancelled {
                    purchaseSuccessDisplayed = true
                }
                
            } catch {
                print(error)
                purchaseErrorDisplayed = true
            }
            isProcessingPurchase = false
        }
    }
        
        
    func refreshUserInfo() async {
        
        do {
            let info = try await Purchases.shared.customerInfo()
            self.customerInfo = info
            self.isSupporter = self.customerInfo?.entitlements["Supporter"]?.isActive ?? false

        } catch {
            print(error)
        }
        
    }
    
    func restorePurchases() async  {
        do {
            let info = try await Purchases.shared.restorePurchases()
            self.customerInfo = info
            restorePurchaseDisplayed = true
        } catch {
            print(error)
        }
    }
    
}
