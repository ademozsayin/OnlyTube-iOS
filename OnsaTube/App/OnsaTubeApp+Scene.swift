//
//  OnsaTubeApp+Scene.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 5.06.2024.
//

import SwiftUI
import DesignSystem
import Env
import TipKit

extension OnsaTubeApp {
    
    var appScene: some Scene {
        WindowGroup(id: "MainWindow") {
      
            AppView(selectedTab: $selectedTab, appRouterPath: $appRouterPath)
                .applyTheme(theme)
                .environment(authenticationManager)
                .environment(userPreferences)
                .environment(theme)
                .environment(pushNotificationsService)
                .environment(\.isSupporter, isSupporter)
                .environment(inAppPurchaseManager)
//                .environment(localeChangeObserver)
//                .environmentObject(purchaseManager)
                .onAppear {
                    setupRevenueCat()
                    refreshPushSubs()
                }
                .onChange(of: pushNotificationsService.handledNotification) { _, newValue in
                    if newValue != nil {
                        pushNotificationsService.handledNotification = nil
                    }
                }
                .withModelContainer()
        }
    }
    
    @SceneBuilder
    var otherScenes: some Scene {
        WindowGroup(for: WindowDestinationEditor.self) { destination in
            Group {
                switch destination.wrappedValue {
                    case .miniPlayer(let videoId):
                        WatchVideoView(videoId: videoId)
                    case .categorySelection:
                        CategorySelectionView()
                    case  .none:
                        EmptyView()
                }
            }
            .withEnvironments()
            .environment(RouterPath())
            .withModelContainer()
            .applyTheme(theme)
            .withCoreDataContext()
            .frame(minWidth: 300, minHeight: 400)
        }
        .defaultSize(width: 600, height: 800)
        .windowResizability(.contentMinSize)
        
//        WindowGroup(for: WindowDestinationMedia.self) { destination in
//            Group {
//                switch destination.wrappedValue {
//                    case let .mediaViewer(attachments, selectedAttachment):
//                        MediaUIView(selectedAttachment: selectedAttachment,
//                                    attachments: attachments)
//                    case .none:
//                        EmptyView()
//                }
//            }
//            .withEnvironments()
//            .withModelContainer()
//            .applyTheme(theme)
//            .frame(minWidth: 300, minHeight: 400)
//        }
//        .defaultSize(width: 1200, height: 1000)
//        .windowResizability(.contentMinSize)
    }
}

