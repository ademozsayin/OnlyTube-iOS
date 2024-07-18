//
//  SettingsTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 6.06.2024.
//

import DesignSystem
import Env
import Foundation
import Models
import Network
import Nuke
import SwiftData
import SwiftUI


@MainActor
struct SettingsTabs: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    @Environment(AuthenticationManager.self) private var authenticationManager

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
                otherSections
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
//                    case .tabAndSidebarEntries:
//                        EmptyView()
//                    
//                }
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
    
    @ViewBuilder
    private var generalSection: some View {
        Section("settings.section.general") {
            
            NavigationLink(destination: DisplaySettingsView()) {
                Label("settings.general.display", systemImage: "paintpalette")
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone || horizontalSizeClass == .compact {
                NavigationLink(destination: TabbarEntriesSettingsView()) {
                    Label("settings.general.tabbarEntries", systemImage: "platter.filled.bottom.iphone")
                }
            } else if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
                NavigationLink(destination: SidebarEntriesSettingsView()) {
                    Label("settings.general.sidebarEntries", systemImage: "sidebar.squares.leading")
                }
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
    
    private var accountsSection: some View {
        Section("settings.section.accounts") {
            if let account = authenticationManager.currentAccount {
                HStack {
                    if isEditingAccount {
                        Button {
                            Task {
                                do {
                                    try await authenticationManager.signOut()
                                } catch {
                                    print(error)
                                }
                                if isModal {
                                    dismiss()
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                                .renderingMode(.template)
                                .tint(.red)
                        }
                    }
                  
                    AppAccountView(
                        viewModel: .init(
                            appAccount: account),
                        isParentPresented: .constant(false)
                    )
                }
                
                editAccountButton
            } else {
                addAccountButton
            }

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
            
            VStack {
                Toggle(isOn: $preferences.enableAutoPlayAtStart) {
                    Label("settings.other.auto-start-video", systemImage: "play.square")
                }
//                Text("It will play The Special One song at startup")
//                    .font(.footnote)
//                    .fontWeight(.light)
//                    .frame(maxWidth: .infinity, alignment: .leading)
               
            }
            
            Toggle(isOn: $preferences.showBackgroundImage) {
                Label("Background Image", systemImage: "photo.tv")
            }
        
        } header: {
            Text("settings.section.other")
        } footer: {
            Text("")
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
            
            NavigationLink(destination: AboutView()) {
                Label("settings.app.about", systemImage: "info.circle")
            }
            
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
            LoginView(siteUrl: "Adem")
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
}
