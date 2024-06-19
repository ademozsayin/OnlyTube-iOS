//
//  SettingsTab.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 6.06.2024.
//

import DesignSystem
import Env
import Foundation
import Nuke
import SwiftData
import SwiftUI

@MainActor
struct SettingsTabs: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    
    @State private var routerPath = RouterPath()
    @State private var addAccountSheetPresented = false
    @State private var isEditingAccount = false
    @State private var cachedRemoved = false
    
    @Binding var popToRootTab: Tab
    
    let isModal: Bool
       
    @State private var startingPoint: SettingsStartingPoint? = nil

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            Form {
                appSection
                accountsSection
                generalSection
//                otherSections
//                cacheSection
            }
            .scrollContentBackground(.hidden)
#if !os(visionOS)
            .background(theme.secondaryBackgroundColor)
#endif
            .navigationTitle(Text("settings.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
            .toolbar {
                if isModal {
                    ToolbarItem {
                        Button {
                            dismiss()
                        } label: {
                            Text("action.done").bold()
                        }
                    }
                }
                if UIDevice.current.userInterfaceIdiom == .pad, !preferences.showiPadSecondaryColumn, !isModal {
                    SecondaryColumnToolbarItem()
                }
            }
            .withAppRouter()
            .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
            .onAppear {
                startingPoint = RouterPath.settingsStartingPoint
                RouterPath.settingsStartingPoint = nil
            }
//            .navigationDestination(item: $startingPoint) { targetView in
//                switch targetView {
//                    case .display:
//                        DisplaySettingsView()
//                }
//            }
        }
        .onAppear {
//            routerPath.client = client
        }
        .task {
//            if appAccountsManager.currentAccount.oauthToken != nil {
//                await currentInstance.fetchCurrentInstance()
//            }
        }
        .withSafariRouter()
        .environment(routerPath)
        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
            if newValue == .notifications {
                routerPath.path = []
            }
        }
    }
    
    private var accountsSection: some View {
        Section("settings.section.accounts") {
      
            addAccountButton
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    @ViewBuilder
    private var generalSection: some View {
        Section("settings.section.general") {
            
            NavigationLink(destination: DisplaySettingsView()) {
                Label("settings.general.display", systemImage: "paintpalette")
            }
            
#if !targetEnvironment(macCatalyst)
            Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                Label("settings.system", systemImage: "gear")
            }
            .tint(theme.labelColor)
#endif
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    @ViewBuilder
    private var otherSections: some View {
        @Bindable var preferences = preferences
        Section {

            Toggle(isOn: $preferences.soundEffectEnabled) {
                Label("settings.other.sound-effect", systemImage: "hifispeaker")
            }
        
        } header: {
            Text("settings.section.other")
        } footer: {
            Text("settings.section.other.footer")
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var appSection: some View {
        Section {
#if !targetEnvironment(macCatalyst) && !os(visionOS)
            NavigationLink(destination: IconSelectorView()) {
                Label {
                    Text("settings.app.icon")
                } icon: {
                    let icon = IconSelectorView.Icon(string: UIApplication.shared.alternateIconName ?? "AppIcon")
                    Image(uiImage: .init(named: icon.appIconName)!)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .cornerRadius(4)
                }
            }
#endif
            
            
            NavigationLink(destination: SupportAppView()) {
                Label("settings.app.support", systemImage: "wand.and.stars")
            }
//            
//            if let reviewURL = URL(string: "https://apps.apple.com/app/id\(AppInfo.appStoreAppId)?action=write-review") {
//                Link(destination: reviewURL) {
//                    Label("settings.rate", systemImage: "link")
//                }
//                .accessibilityRemoveTraits(.isButton)
//                .tint(theme.labelColor)
//            }
//            
//            NavigationLink(destination: AboutView()) {
//                Label("settings.app.about", systemImage: "info.circle")
//            }
            
        } header: {
            Text("settings.section.app")
        } footer: {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Text("settings.section.app.footer \(appVersion)").frame(maxWidth: .infinity, alignment: .center)
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var addAccountButton: some View {
        Button {
            addAccountSheetPresented.toggle()
        } label: {
            Text("settings.account.add")
        }
        .sheet(isPresented: $addAccountSheetPresented) {
//            AddAccountView()
            Text("Add Account")
        }
    }
    
    private var editAccountButton: some View {
        Button(role: isEditingAccount ? .none : .destructive) {
            withAnimation {
                isEditingAccount.toggle()
            }
        } label: {
            if isEditingAccount {
                Text("action.done")
            } else {
                Text("account.action.logout")
            }
        }
    }
    
    private var cacheSection: some View {
        Section("settings.section.cache") {
            if cachedRemoved {
                Text("action.done")
                    .transition(.move(edge: .leading))
            } else {
                Button("settings.cache-media.clear", role: .destructive) {
                    ImagePipeline.shared.cache.removeAll()
                    withAnimation {
                        cachedRemoved = true
                    }
                }
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
}
