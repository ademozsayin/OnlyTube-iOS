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
    @Binding var appRouterPath: RouterPath

    @State var popToRootTab: Tab = .other
    @State var iosTabs = iOSTabs.shared
    @State var sidebarTabs = SidebarTabs.shared
    
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @Namespace private var sheetAnimation
    
    var addToPlaylistBinding = SheetsModel.shared.makeSheetBinding(.addToPlaylist)
    var settingsSheetBinding = SheetsModel.shared.makeSheetBinding(.settings)
    var watchVideoBinding = SheetsModel.shared.makeSheetBinding(.watchVideo)

    @State private var SM = SheetsModel.shared

    var body: some View {
#if os(visionOS)
        tabBarView
#else
        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
            sidebarView
        } else {
            tabBarView
        }
#endif
    }
    
    var availableTabs: [Tab] {
//        guard appAccountsManager.currentClient.isAuth else {
//            return Tab.loggedOutTab()
//        }
        if UIDevice.current.userInterfaceIdiom == .phone || horizontalSizeClass == .compact {
            return Tab.loggedOutTab()//iosTabs.tabs
        } else if UIDevice.current.userInterfaceIdiom == .vision {
            return Tab.loggedOutTab()//Tab.visionOSTab()
        }
        return sidebarTabs.tabs.map { $0.tab }
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
        .safeAreaInset(edge: .bottom, content: {
            if  VPM.currentItem != nil {
                NowPlayingBarView(
                    sheetAnimation: sheetAnimation,
                    isSheetPresented: watchVideoBinding,
                    isSettingsSheetPresented: settingsSheetBinding.wrappedValue
                )
            }
        })
        .sheet(isPresented: watchVideoBinding, content: {
            WatchVideoView()
                .presentationDragIndicator(.hidden)
        })
        .withSheetDestinations(sheetDestinations: $appRouterPath.presentedSheet)

    }
    
#if !os(visionOS)
    var sidebarView: some View {
        SideBarView(selectedTab: $selectedTab,
                    popToRootTab: $popToRootTab,
                    tabs: availableTabs)
        {
            HStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    ForEach(availableTabs) { tab in
                        tab
                            .makeContentView(selectedTab: $selectedTab, popToRootTab: $popToRootTab)
                            .tabItem {
                                tab.label
                            }
                            .tag(tab)
                    }
                }
                .introspect(.tabView, on: .iOS(.v17), .visionOS(.v1)) { (tabview: UITabBarController) in
                    tabview.tabBar.isHidden = horizontalSizeClass == .regular
                    tabview.customizableViewControllers = []
                    tabview.moreNavigationController.isNavigationBarHidden = true
                }
                if horizontalSizeClass == .regular,
//                   appAccountsManager.currentClient.isAuth,
                   userPreferences.showiPadSecondaryColumn
                {
                    Divider().edgesIgnoringSafeArea(.all)
//                    notificationsSecondaryColumn
                }
            }
        }
        .environment(appRouterPath)
        .safeAreaInset(edge: .bottom, content: {
            HStack(spacing: 0) {
                if  VPM.currentItem != nil {
                    NowPlayingBarView(
                        sheetAnimation: sheetAnimation,
                        isSheetPresented: watchVideoBinding,
                        isSettingsSheetPresented: settingsSheetBinding.wrappedValue
                    )
                    .frame(height: 70)
                    .padding(.top, 40)
                    .padding(.leading, userPreferences.isSidebarExpanded ? 18 : 0)
//                    .offset(x: 0, y: 50)
                }
                
          
            }
            .background(.thinMaterial)
            .padding(.leading, .sidebarWidth)
//            .frame(width: userPreferences.isSidebarExpanded ? .sidebarWidthExpanded : .sidebarWidth)
        })
        .sheet(isPresented: watchVideoBinding, content: {
            WatchVideoView()
                .presentationDragIndicator(.hidden)
        })
        .withSheetDestinations(sheetDestinations: $appRouterPath.presentedSheet)
    }
#endif
    
    private func badgeFor(tab: Tab) -> Int {
        return 0
    }
    
    
    var notificationsSecondaryColumn: some View {
        Text("Notifs")
//        NotificationsTab(selectedTab: .constant(.notifications),
//                         popToRootTab: $popToRootTab, lockedType: nil)
//        .environment(\.isSecondaryColumn, true)
//        .frame(maxWidth: .secondaryColumnWidth)
//        .id(appAccountsManager.currentAccount.id)
    }
}

