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
}

