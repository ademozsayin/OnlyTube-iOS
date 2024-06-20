//
//  SearchTab.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 13.06.2024.
//

import DesignSystem
import Env
import Models
import Network
import SwiftUI

@MainActor
struct SearchTab: View {
   
    @Environment(Theme.self) private var theme
    @Environment(UserPreferences.self) private var preferences
    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    @Binding var popToRootTab: Tab
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            SearchView(scrollToTopSignal: $scrollToTopSignal)
                .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
                .toolbar {
                    ToolbarTab(routerPath: $routerPath)
                }
        }
        .withAppRouter()
        .withSafariRouter()
        .environment(routerPath)
        .onChange(of: $popToRootTab.wrappedValue) { oldValue, newValue in
            if newValue == .timeline {
                if routerPath.path.isEmpty {
                    scrollToTopSignal += 1
                } else {
                    routerPath.path = []
                }
            }
        }
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)

    }
}
