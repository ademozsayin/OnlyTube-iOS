//
//  IconSelectorView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 19.06.2024.
//

import DesignSystem
import SwiftUI
import Env

@MainActor
struct IconSelectorView: View {
    enum Icon: Int, CaseIterable, Identifiable {
        var id: String {
            "\(rawValue)"
        }
        
        init(string: String) {
            if string == "AppIcon" {
                self = .primary
            } else {
                self = .init(rawValue: Int(String(string.replacing("AppIconAlternate", with: "")))!)!
            }
        }
        
        case primary = 0
        case alt1, alt2, alt3, alt4, alt5, alt6, alt7
        
        var appIconName: String {
            return "AppIconAlternate\(rawValue)"
        }
        
        var isPremium: Bool {
            switch self {
                case .alt4:
                    return true
                default:
                    return false
            }
        }
    }
    
    struct IconSelector: Identifiable {
        var id = UUID()
        let title: String
        let icons: [Icon]
        
        static let items = [
            IconSelector(title: "settings.app.icon.official".localized, icons: [
                .primary,
                .alt1,
                .alt2,
                .alt3,
                .alt4,
                .alt5,
                .alt6,
                .alt7
            ])
        ]
    }
    
    @Environment(Theme.self) private var theme
    @State private var currentIcon = UIApplication.shared.alternateIconName ?? Icon.primary.appIconName
    @Environment(UserPreferences.self) private var preferences
    @Environment(RouterPath.self) private var routerPath

    private let columns = [GridItem(.adaptive(minimum: 125, maximum: 1024))]
    
    @Environment(InAppPurchaseManager.self) private var inAppPurchaseManager

    var body: some View {
        ScrollView (.vertical){
            VStack(alignment: .leading) {
                ForEach(IconSelector.items) { item in
                    Section {
                        makeIconGridView(icons: item.icons)
                    } header: {
                        Text(item.title)
                            .font(.scaledHeadline)
                    }
                }
            }
            .padding(6)
            .navigationTitle("settings.app.icon.navigation-title")
        }
        .onAppear {
            print("inAppPurchaseManager.isSupporter : \(inAppPurchaseManager.isSupporter)")
        }
#if !os(visionOS)
        .background(theme.primaryBackgroundColor)
#endif
    }
    
    private func makeIconGridView(icons: [Icon]) -> some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(icons) { icon in
                Button {
                    
                    if !inAppPurchaseManager.isSupporter && icon.isPremium {
                        routerPath.presentedSheet = .support
                    } else {
                        
                        currentIcon = icon.appIconName
                        preferences.appIcon = currentIcon
                        
                        if icon.rawValue == Icon.primary.rawValue {
                            UIApplication.shared.setAlternateIconName(nil)
                        } else {
                            UIApplication.shared.setAlternateIconName(icon.appIconName) { err in
                                guard let err else { return }
                                assertionFailure("\(err.localizedDescription) - Icon name: \(icon.appIconName)")
                            }
                        }
                    }
                 
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: .init(named: icon.appIconName) ?? .init())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minHeight: 125, maxHeight: 1024)
                            .cornerRadius(6)
                            .shadow(radius: 3)
                        if icon.appIconName == currentIcon {
                            Image(systemName: "checkmark.seal.fill")
                                .padding(4)
                                .tint(.green)
                        }
                        if icon.isPremium && !inAppPurchaseManager.isSupporter {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "lock.fill")
                                        .padding(4)
                                        .tint(theme.tintColor) // Set the color of the lock image
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
