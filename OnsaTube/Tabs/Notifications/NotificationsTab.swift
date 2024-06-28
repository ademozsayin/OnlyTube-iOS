//
//  NotificationsTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 28.06.2024.
//
import DesignSystem
import Env
import Models
import Network
import Notifications
import SwiftUI
//import Timeline

@MainActor
struct NotificationsTab: View {
    @Environment(\.isSecondaryColumn) private var isSecondaryColumn: Bool
    @Environment(\.scenePhase) private var scenePhase
    
    @Environment(Theme.self) private var theme
//    @Environment(Client.self) private var client
//    @Environment(StreamWatcher.self) private var watcher
//    @Environment(AppAccountsManager.self) private var appAccount
//    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(PushNotificationsService.self) private var pushNotificationsService
    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    
    @Binding var selectedTab: Tab
    @Binding var popToRootTab: Tab
    
//    let lockedType: Models.Notification.NotificationType?
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            NotificationsListView(scrollToTopSignal: $scrollToTopSignal)
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
        }
        .onAppear {
            clearNotifications()
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
            clearNotifications()
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
                case .active:
                    clearNotifications()
                default:
                    break
            }
        }
    }
    
    private func clearNotifications() { }
}
