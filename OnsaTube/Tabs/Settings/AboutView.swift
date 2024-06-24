//
//  AboutView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 23.06.2024.
//

import DesignSystem
import Env
import Models
import Network
import SwiftUI

@MainActor
struct AboutView: View {
    @Environment(RouterPath.self) private var routerPath
    @Environment(Theme.self) private var theme
   
    let versionNumber: String
    
    init() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionNumber = version + " "
        } else {
            versionNumber = ""
        }
    }
    
    var body: some View {
        List {
            Section {
#if !targetEnvironment(macCatalyst) && !os(visionOS)
                HStack {
                    Spacer()
                    Image(uiImage: .init(named: "AppIconAlternate0")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                    Image(uiImage: .init(named: "AppIconAlternate1")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                    Image(uiImage: .init(named: "AppIconAlternate2")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                    Image(uiImage: .init(named: "AppIconAlternate3")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                    Spacer()
                }
#endif
                Link(destination: URL(string: "https://github.com/ademozsayin/OnsaTube-iOS/blob/main/PRIVACY.MD")!) {
                    Label("settings.support.privacy-policy", systemImage: "lock")
                }
                
                Link(destination: URL(string: "https://github.com/ademozsayin/OnsaTube-iOS/blob/main/Terms.MD")!) {
                    Label("settings.support.terms-of-use", systemImage: "checkmark.shield")
                }
            } footer: {
                Text("\(versionNumber)© 2024 Adem Özsayın")
            }
#if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
#endif
            
            
            Section {
                Text("""
        
        • [YouTubeKit](https://github.com/b5i/YouTubeKit)
        
        • [KeychainSwift](https://github.com/evgenyneu/keychain-swift)

        • [Nuke](https://github.com/kean/Nuke)

        • [SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect)
        
        • [RevenueCat](https://github.com/RevenueCat/purchases-ios)
        
        • [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols)
        """)
                .multilineTextAlignment(.leading)
                .font(.scaledSubheadline)
                .foregroundStyle(.secondary)
            } header: {
                Text("settings.about.built-with")
                    .textCase(nil)
            }
#if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
#endif
        }
        .task {
        }
        .listStyle(.insetGrouped)
#if !os(visionOS)
        .scrollContentBackground(.hidden)
        .background(theme.secondaryBackgroundColor)
#endif
        .navigationTitle(Text("settings.about.title"))
        .navigationBarTitleDisplayMode(.large)
        .environment(\.openURL, OpenURLAction { url in
            routerPath.handle(url: url)
        })
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .environment(Theme.shared)
    }
}
