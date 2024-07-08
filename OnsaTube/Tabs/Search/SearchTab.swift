//
//  SearchTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.06.2024.
//

import DesignSystem
import Env
import Models
import Network
import SwiftUI
import SwiftData

@MainActor
struct SearchTab: View {
   
    @Environment(\.modelContext) private var context

    @Environment(Theme.self) private var theme
    @Environment(UserPreferences.self) private var preferences
    @Environment(AuthenticationManager.self) private var authenticationManager

    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    @Binding var popToRootTab: Tab
    
    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            SearchView(scrollToTopSignal: $scrollToTopSignal)
                .toolbar {
                    toolbarView
                }
                .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                .withAppRouter()
        }
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
    }
    
    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        if authenticationManager.isAuth {
            ToolbarTab(routerPath: $routerPath)
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                addAccountButton
            }
            ToolbarItem(placement: .navigationBarLeading) {
                contentSettingsButton
            }
        }
    }
    
    private var addAccountButton: some View {
        Button {
            routerPath.presentedSheet = .login
        } label: {
            Image(systemName: "person.badge.plus")
        }
        .accessibilityLabel("accessibility.tabs.timeline.add-account")
    }
    
    private var contentSettingsButton: some View {
        Button {
            HapticManager.shared.fireHaptic(.buttonPress)
            routerPath.presentedSheet = .categorySelection
            
        } label: {
            Label("Content Selection", systemImage: "filemenu.and.selection")
        }
    }
}
