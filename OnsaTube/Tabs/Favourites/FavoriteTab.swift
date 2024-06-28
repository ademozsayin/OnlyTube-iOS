//
//  FavoriteTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 27.06.2024.
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
struct FavoriteTab: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    
    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    
    @Binding var popToRootTab: Tab
    @Binding var selectedTab: Tab
    let lockedType: PreferencesStorageModel.Properties.SortingModes?
  
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            FavoritesView()
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                .withCoreDataContext()
                .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
        }
        .onAppear {
        }
        .withSafariRouter()
        .environment(routerPath)
        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
            if newValue == .notifications {
                if routerPath.path.isEmpty {
                    scrollToTopSignal += 1
                } else {
                    routerPath.path = []
                }
            }
        }
        .onChange(of: selectedTab) { _, _ in
        }
    }
   
}
