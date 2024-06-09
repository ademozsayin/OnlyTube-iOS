//
//  AppView.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 5.06.2024.
//
import DesignSystem
import Env
import SwiftUI

@MainActor
struct AppView: View {
    
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(Theme.self) private var theme

    @Environment(\.openWindow) var openWindow
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var selectedTab: Tab
    
    @State var popToRootTab: Tab = .other
    @State var iosTabs = iOSTabs.shared
    @State var sidebarTabs = SidebarTabs.shared
    
    var body: some View {
#if os(visionOS)
#else
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
        } else {
            tabBarView
        }
#endif
    }
    
    var availableTabs: [Tab] {
        return Tab.loggedOutTab()
    }
    
    var tabBarView: some View {
        TabView(selection: .init(get: {
            selectedTab
        }, set: { newTab in

            if newTab == selectedTab {
                /// Stupid hack to trigger onChange binding in tab views.
                popToRootTab = .other
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    popToRootTab = selectedTab
                }
            }
            
            HapticManager.shared.fireHaptic(.tabSelection)
            SoundEffectManager.shared.playSound(.tabSelection)
            
            selectedTab = newTab
        })) {
            ForEach(availableTabs) { tab in
                tab.makeContentView(selectedTab: $selectedTab, popToRootTab: $popToRootTab)
                    .tabItem {
                        if userPreferences.showiPhoneTabLabel {
                            tab.label
                                .environment(\.symbolVariants, tab == selectedTab ? .fill : .none)
                        } else {
                            Image(systemName: tab.iconName)
                        }
                    }
                    .tag(tab)
                    .badge(badgeFor(tab: tab))
                    .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .tabBar)
            }
        }
    }
    
    private func badgeFor(tab: Tab) -> Int {
        return 0
    }
}

