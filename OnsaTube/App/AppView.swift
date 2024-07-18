//
//  AppView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 5.06.2024.
//
import DesignSystem
import Env
import SwiftUI
import SwiftUIIntrospect
import YouTubeKit

@MainActor
struct AppView: View {
    
    @Environment(AuthenticationManager.self) private var authenticationManager
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
    
    @State private var disclaimerPresented = false

    @ObservedObject var PM = PopupsModel.shared

    @Environment(\.dismiss) private var dismiss

    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashView()
                .task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000) // 1 second
                    showSplash = false
                }
        } else {
#if os(visionOS)
            tabBarView
#else
            if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
                ZStack(alignment: .bottom) {
                    sidebarView
                    if !userPreferences.hasAcceptedDisclaimer {
                        DisclaimerView()
                            .background(Color.fenerbahceWhite)
                    }
                }
            } else {
                ZStack(alignment: .bottom) {
                    tabBarView
                    if !userPreferences.hasAcceptedDisclaimer {
                        DisclaimerView()
                            .background(Color.fenerbahceWhite)
                    }
                }
                
            }
#endif
        }
    }
    
    var availableTabs: [Tab] {
        guard let _ = authenticationManager.currentAccount else {
            return Tab.loggedOutTab()
        }
        if UIDevice.current.userInterfaceIdiom == .phone || horizontalSizeClass == .compact {
            return iosTabs.tabs
        } else if UIDevice.current.userInterfaceIdiom == .vision {
            return Tab.visionOSTab()
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
//                    .id(availableTabs.count) // <——Here
                
            }
        }
#if os(visionOS)
        .ornament(attachmentAnchor: .scene(.center)) {
            if  VPM.currentItem != nil {
                NowPlayingBarView(
                    sheetAnimation: sheetAnimation,
                    isSheetPresented: watchVideoBinding,
                    isSettingsSheetPresented: settingsSheetBinding.wrappedValue
                )

                
            }
        }
#else
        .safeAreaInset(edge: .bottom, content: {
            if  VPM.currentItem != nil {
                NowPlayingBarView(
                    sheetAnimation: sheetAnimation,
                    isSheetPresented: watchVideoBinding,
                    isSettingsSheetPresented: settingsSheetBinding.wrappedValue
                )
            }
            
        })
#endif
        .sheet(isPresented: watchVideoBinding, content: {
            WatchVideoView(videoId: nil)
#if os(visionOS)
                .onTapGesture {
                    openWindow(value: WindowDestinationEditor.miniPlayer(videoId: nil))
                }
#endif
#if !os(visionOS)
                .presentationDragIndicator(.hidden)
#endif
        })
        .fullScreenCover(isPresented: $disclaimerPresented, content: {
            DisclaimerView()
        })
        .overlay(alignment: .center, content: {
            ZStack {
                let imageData = PM.shownPopup?.data as? Data
                switch PM.shownPopup?.type {
                    case .addedToFavorites:
                        AddedFavoritesAlertView(imageData: imageData)
                    case .addedToPlaylist:
                        AddedToPlaylistAlertView(imageData: imageData)
                    case .cancelledDownload:
                        CancelledDownloadAlertView(imageData: imageData)
                    case .deletedDownload:
                        DeletedDownloadAlertView(imageData: imageData)
                    case .pausedDownload:
                        PausedDownloadAlertView(imageData: imageData)
                    case .playLater:
                        PlayLaterAlertView(imageData: imageData)
                    case .playNext:
                        PlayNextAlertView(imageData: imageData)
                    case .resumedDownload:
                        ResumedDownloadAlertView(imageData: imageData)
                    case .none:
                        Color.clear.frame(width: 0, height: 0)
                            .hidden()
                }
            }
//            .padding(.bottom, 200)
        })
        .id(authenticationManager.currentAccount?.uid)
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
                .id(availableTabs.count) // <——Here
                .introspect(.tabView, on: .iOS(.v17)) { (tabview: UITabBarController) in
                    tabview.tabBar.isHidden = horizontalSizeClass == .regular
                    tabview.customizableViewControllers = []
                    tabview.moreNavigationController.isNavigationBarHidden = true
                }
                if horizontalSizeClass == .regular,
                  let _ = authenticationManager.currentAccount,
                   userPreferences.showiPadSecondaryColumn
                {
                    Divider().edgesIgnoringSafeArea(.all)
#if targetEnvironment(macCatalyst)
                    notificationsSecondaryColumn
                        .withEnvironments()
#endif
                } else {
#if targetEnvironment(macCatalyst)
                    if  VPM.currentItem != nil {
                        notificationsSecondaryColumn
                            .withEnvironments()
                    }
#endif
                }
                
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            HStack(spacing: 0) {
                if  VPM.currentItem != nil {
                    NowPlayingBarView(
                        sheetAnimation: sheetAnimation,
                        isSheetPresented: watchVideoBinding,
                        isSettingsSheetPresented: settingsSheetBinding.wrappedValue
                    )
                    .frame(height: 70)
                 
#if targetEnvironment(macCatalyst)
                    .padding(.top, 0)
#else
                    .padding(.top, 40)
#endif
                    
#if targetEnvironment(macCatalyst)
//                    .padding(.leading, userPreferences.isSidebarExpanded ?  .sidebarWidthExpanded : .sidebarWidth )
                    .animation(.easeInOut(duration: 0.3), value: userPreferences.isSidebarExpanded)
                    .padding(.trailing, .secondaryColumnWidth)
#else
                    
                    .animation(.easeInOut(duration: 0.3), value: userPreferences.isSidebarExpanded)
//                    .padding(.leading, userPreferences.isSidebarExpanded ? .sidebarWidth : 0)
#endif
#if targetEnvironment(macCatalyst)
                    .offset(x: 0, y: 50)
#endif
                }
            }
#if !targetEnvironment(macCatalyst)
            .background(Color.secondary)
            .background(.thinMaterial)
#endif
            .padding(.leading,userPreferences.isSidebarExpanded ? .sidebarWidthExpanded : .sidebarWidth )

        })
#if !targetEnvironment(macCatalyst)
        .sheet(isPresented: watchVideoBinding, content: {
            WatchVideoView(videoId: nil)
                .presentationDragIndicator(.hidden)
        })
#endif
        .overlay(alignment: .center, content: {
            ZStack {
                let imageData = PM.shownPopup?.data as? Data
                switch PM.shownPopup?.type {
                    case .addedToFavorites:
                        AddedFavoritesAlertView(imageData: imageData)
                    case .addedToPlaylist:
                        AddedToPlaylistAlertView(imageData: imageData)
                    case .cancelledDownload:
                        CancelledDownloadAlertView(imageData: imageData)
                    case .deletedDownload:
                        DeletedDownloadAlertView(imageData: imageData)
                    case .pausedDownload:
                        PausedDownloadAlertView(imageData: imageData)
                    case .playLater:
                        PlayLaterAlertView(imageData: imageData)
                    case .playNext:
                        PlayNextAlertView(imageData: imageData)
                    case .resumedDownload:
                        ResumedDownloadAlertView(imageData: imageData)
                    case .none:
                        Color.clear.frame(width: 0, height: 0)
                            .hidden()
                }
            }
        })
//        .withSheetDestinations(sheetDestinations: $appRouterPath.presentedSheet)
        .environment(appRouterPath)
    }
#endif
    
    private func badgeFor(tab: Tab) -> Int {
        return 0
    }
    
    
    var notificationsSecondaryColumn: some View {
        
        
//        NotificationsTab(selectedTab: .constant(.notifications),
//                         popToRootTab: $popToRootTab)
//        .environment(\.isSecondaryColumn, true)
//        .frame(maxWidth: .secondaryColumnWidth)
//        .id(authenticationManager.currentAccount?.uid)
//        
        
      
        WatchVideoView(videoId: nil)
            .environment(\.isSecondaryColumn, true)
            .environment(Theme.shared)
            .id(authenticationManager.currentAccount?.uid)
            .frame(maxWidth: .secondaryColumnWidth)
            .onChange(of: VPM.loadingVideo) { _, newVideo in
                // Automatically update the video when VPM.loadingVideo changes
                if let newVideo = newVideo {
                    VPM.loadVideo(video: newVideo)
                }
            }
    }
    
    private func handleVideoLoading(_ newVideo: YTVideo?) {
        print("new \(newVideo?.videoId ?? "nan")" )
        // Avoid unnecessary reloading if the new video is the same as the current one
        guard let newVideo = newVideo, newVideo.videoId != VideoPlayerModel.shared.loadingVideo?.videoId else {
            return
        }
        
        // Perform video loading
        VPM.loadVideo(video: newVideo)
    }
}

