//
//  OnsaTubeApp+Scene.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 5.06.2024.
//

import SwiftUI

extension OnsaTubeApp {
    var appScene: some Scene {
        WindowGroup(id: "MainWindow") {
            AppView(selectedTab: $selectedTab, appRouterPath: $appRouterPath)
                .applyTheme(theme)
                .environment(userPreferences)
                .environment(theme)
                .onAppear {
                    setupRevenueCat()
                }
        }
    }
}