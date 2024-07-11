//
//  SupportAppView.swift
//  OnsaTube
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
        case protector, ten
        
        init(productId: String) {
            self = .init(rawValue: String(productId.split(separator: ".")[2]))!
        }
        
        var productId: String {
            "onlyjose.tip.\(rawValue)"
        }
        var title: LocalizedStringKey {
            switch self {
                case .ten:
                    "settings.support.four.title"
//                case .five:
//                    "settings.support.five.title"
//                case .ten:
//                    "settings.support.six.title"
                case .protector:
                    "settings.support.supporter.title"
            }
        }
        
        var subtitle: LocalizedStringKey {
            switch self {
                case .ten:
                    "settings.support.four.subtitle"
//                case .five:
//                    "settings.support.five.subtitle"
//                case .ten:
//                    "settings.support.six.subtitle"
                case .protector:
                    "settings.support.supporter.subtitle"
            }
        }
    }
    
    @Environment(\.openURL) private var openURL

    @Environment(Theme.self) private var theme
    @Environment(InAppPurchaseManager.self) private var inAppPurchaseManager
   
    var body: some View {
        
        @Bindable var bindableInAppPurchaseManager = inAppPurchaseManager

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
        .alert("settings.support.alert.title", isPresented: $bindableInAppPurchaseManager.purchaseSuccessDisplayed, actions: {
            Button { inAppPurchaseManager.purchaseSuccessDisplayed = false } label: { Text("alert.button.ok") }
        }, message: {
            Text("settings.support.alert.message")
        })
        .alert("alert.error", isPresented: $bindableInAppPurchaseManager.purchaseErrorDisplayed, actions: {
            Button { inAppPurchaseManager.purchaseErrorDisplayed = false } label: { Text("alert.button.ok") }
        }, message: {
            Text("settings.support.alert.error.message")
        })
        .onAppear {
            inAppPurchaseManager.loadingProducts = true
            Task {
                await inAppPurchaseManager.fetchStoreProducts()
                await inAppPurchaseManager.refreshUserInfo()
            }
        }
    }
    
   
    
    private func makePurchaseButton(product: StoreProduct) -> some View {
        Button {
            Task {
                await inAppPurchaseManager.purchase(product: product)
                await inAppPurchaseManager.refreshUserInfo()
            }
        } label: {
            if inAppPurchaseManager.isProcessingPurchase {
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
   
            Text("Tips provided in app do no unlock any additional content.")
                .multilineTextAlignment(.leading)
                .font(.callout)
                .overlay {
                    LinearGradient(
                        colors: [
                            .fenerbahceYellow,
                            theme.labelColor
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("Tips provided in app do no unlock any additional content.")
                            .multilineTextAlignment(.leading)
                            .font(.callout)
                    )
                }
            
            if inAppPurchaseManager.loadingProducts {
                loadingPlaceholder
            } else  {
                if inAppPurchaseManager.customerInfo?.entitlements["Supporter"]?.isActive == true {
                       
                        Text(Image(systemName: "checkmark.seal.fill"))
                            .foregroundColor(theme.tintColor)
                            .baselineOffset(-1) +
                        Text("settings.support.supporter.subscribed")
                            .font(.scaledSubheadline)
                    } else {
                        HStack {
                            if inAppPurchaseManager.customerInfo?.entitlements["Supporter"]?.isActive == true {
                                Text(Image(systemName: "checkmark.seal.fill"))
                                    .foregroundColor(theme.tintColor)
                                    .baselineOffset(-1) +
                                Text("settings.support.supporter.subscribed")
                                    .font(.scaledSubheadline)
                            } else {
                                VStack(alignment: .leading) {
                                  
                                    HStack() {
                                        VStack(alignment: .trailing) {
                                            Text("Monthly")
                                                .font(.scaledFootnote)

                                        }
                                        .foregroundStyle(.secondary)
                                    }
                                  
                                    
                                    Text(Image(systemName: "checkmark.seal.fill"))
                                        .foregroundColor(theme.tintColor)
                                        .baselineOffset(-1) +
                                    Text(Tip.protector.title)
                                        .font(.scaledSubheadline)
                                    Text(Tip.protector.subtitle)
                                        .font(.scaledFootnote)
                                        .foregroundStyle(.secondary)
                                
                                }
                                Spacer()
                                if let subscription = inAppPurchaseManager.subscription {
                                    makePurchaseButton(product: subscription)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            
        } footer: {
            if inAppPurchaseManager.customerInfo?.entitlements.active.isEmpty == true {
                Text("settings.support.supporter.subscription-info")
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var tipsSection: some View {
        Section {
            if inAppPurchaseManager.loadingProducts {
                loadingPlaceholder
            } else {
                Text("Tips")
                ForEach(inAppPurchaseManager.products, id: \.productIdentifier) { product in
                    let tip = Tip(productId: product.productIdentifier)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(tip.title)
                                .font(.scaledSubheadline)
                            Text(tip.subtitle)
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
                    Task {
                        await inAppPurchaseManager.restorePurchases()
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
                    openURL(URL(string: "https://github.com/ademozsayin/OnlyJose-iOS/blob/main/Terms.MD")!)
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

//#Preview {
//    SupportAppView()
//}

extension View {
    /// Renders a view if the provided  `condition` is met.
    /// If the `condition` is not met, an `nil`  will be used in place of the receiver view.
    ///
    func renderedIf(_ condition: Bool) -> Self? {
        guard condition else {
            return nil
        }
        return self
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
