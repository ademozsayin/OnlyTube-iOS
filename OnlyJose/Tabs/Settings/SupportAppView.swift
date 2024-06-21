//
//  SupportAppView.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 18.06.2024.
//

import DesignSystem
import Env
import RevenueCat
import SwiftUI

public extension Color {
    static let navyBlue = Color(red: 0/255, green: 0/255, blue: 128/255)
}

@MainActor
struct SupportAppView: View {
    enum Tip: String, CaseIterable {
        case supporter, protector, patron, legend, five, six
        
        init(productId: String) {
            self = .init(rawValue: String(productId.split(separator: ".")[2]))!
        }
        
        var productId: String {
            "onlyjose.tip.\(rawValue)"
        }
    }
    
    @Environment(Theme.self) private var theme
    
    @Environment(\.openURL) private var openURL
    
    @State private var loadingProducts: Bool = false
    @State private var products: [StoreProduct] = []
    @State private var subscription: StoreProduct?
    @State private var subscriptions: [StoreProduct] = [] {
        didSet {
            print(subscriptions.map{$0.productIdentifier})
            print(subscriptions.count)
        }
    }
    
    @State private var customerInfo: CustomerInfo?
    @State private var isProcessingPurchase: Bool = false
    @State private var purchaseSuccessDisplayed: Bool = false
    @State private var purchaseErrorDisplayed: Bool = false
    @State private var availablePackages: [Package] = []
    
    var body: some View {
        Form {
            aboutSection
            subscriptionSection
            tipsSection
            restorePurchase
            linksSection
        }
        .navigationTitle("settings.support.navigation-title")
#if !os(visionOS)
        .scrollContentBackground(.hidden)
        .background(theme.secondaryBackgroundColor)
#endif
        .alert("settings.support.alert.title", isPresented: $purchaseSuccessDisplayed, actions: {
            Button { purchaseSuccessDisplayed = false } label: { Text("alert.button.ok") }
        }, message: {
            Text("settings.support.alert.message")
        })
        .alert("alert.error", isPresented: $purchaseErrorDisplayed, actions: {
            Button { purchaseErrorDisplayed = false } label: { Text("alert.button.ok") }
        }, message: {
            Text("settings.support.alert.error.message")
        })
        .onAppear {
            loadingProducts = true
            fetchStoreProducts()
            refreshUserInfo()
        }
    }
    
    private func purchase(product: StoreProduct) async {
        if !isProcessingPurchase {
            isProcessingPurchase = true
            do {
                let result = try await Purchases.shared.purchase(product: product)
                print(result)
                if !result.userCancelled {
                    purchaseSuccessDisplayed = true
                }
            } catch {
                purchaseErrorDisplayed = true
            }
            isProcessingPurchase = false
        }
    }
    
    private func fetchStoreProducts() {

        Purchases.shared.getOfferings { offerings,  error in
            self.subscriptions = offerings?.offering(identifier: "Supporter")?.availablePackages.map{$0.storeProduct} ?? []
            self.products = offerings?.offering(identifier: "Tips")?.availablePackages.map{$0.storeProduct} ?? []
            
            withAnimation {
                loadingProducts = false
            }
        }
    }
    
    private func refreshUserInfo() {
        Purchases.shared.getCustomerInfo { info, _ in
            customerInfo = info
        }
    }
    
    private func makePurchaseButton(product: StoreProduct) -> some View {
        Button {
            Task {
                await purchase(product: product)
                refreshUserInfo()
            }
        } label: {
            if isProcessingPurchase {
                ProgressView()
            } else {
                Text(product.localizedPriceString)
            }
        }
        .buttonStyle(.bordered)
    }
    
    private var aboutSection: some View {
        Section {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 18) {
                    Image(.me)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
    
                    HStack() {
                        Rectangle()
                            .fill(Color.yellow)
                            .frame(width: 10,height: 40)
                        
                        Rectangle()
                            .fill(Color.navyBlue)
                            .frame(width: 10,height: 40)
                    }
                }
                Text("settings.support.message-from-dev")
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var subscriptionSection: some View {
        Section {
            if loadingProducts {
                loadingPlaceholder
            } else  {
                    if customerInfo?.entitlements["Supporter"]?.isActive == true {
                        Text(Image(systemName: "checkmark.seal.fill"))
                            .foregroundColor(theme.tintColor)
                            .baselineOffset(-1) +
                        Text("settings.support.supporter.subscribed")
                            .font(.scaledSubheadline)
                    } else {
                        Text("Subscriptions")
                        ForEach(Array(subscriptions.enumerated()), id: \.element) { index, package in
                            //                    let tip = Tip(productId: package.productIdentifier)
                            let product = subscriptions[index]
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.localizedTitle)
                                        .font(.scaledSubheadline)
                                    Text(product.localizedDescription)
                                        .font(.scaledFootnote)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                makePurchaseButton(product: product)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
              
            
            
        } footer: {
            if customerInfo?.entitlements.active.isEmpty == true {
                Text("settings.support.supporter.subscription-info")
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var tipsSection: some View {
        Section {
            if loadingProducts {
                loadingPlaceholder
            } else {
                Text("Tips")
                ForEach(products, id: \.productIdentifier) { product in
                    let tip = Tip(productId: product.productIdentifier)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.localizedTitle)
                                .font(.scaledSubheadline)
                            Text(product.localizedDescription)
                                .font(.scaledFootnote)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        makePurchaseButton(product: product)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var restorePurchase: some View {
        Section {
            HStack {
                Spacer()
                Button {
                    Purchases.shared.restorePurchases { info, _ in
                        customerInfo = info
                    }
                } label: {
                    Text("settings.support.restore-purchase.button")
                }.buttonStyle(.bordered)
                Spacer()
            }
        } footer: {
            Text("settings.support.restore-purchase.explanation")
        }
#if !os(visionOS)
        .listRowBackground(theme.secondaryBackgroundColor)
#endif
    }
    
    private var linksSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 16) {
                Button {
                    openURL(URL(string: "https://github.com/ademozsayin/OnlyJose-iOS/blob/main/PRIVACY.MD")!)
                } label: {
                    Text("settings.support.privacy-policy")
                }
                .buttonStyle(.borderless)
                Button {
                    openURL(URL(string: "https://github.com/Dimillian/IceCubesApp/blob/main/TERMS.MD")!)
                } label: {
                    Text("settings.support.terms-of-use")
                }
                .buttonStyle(.borderless)
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.secondaryBackgroundColor)
#endif
    }
    
    private var loadingPlaceholder: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("placeholder.loading.short")
                    .font(.scaledSubheadline)
                Text("settings.support.placeholder.loading-subtitle")
                    .font(.scaledFootnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)
    }
}
