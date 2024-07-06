import DesignSystem
import Env
import Network
import SwiftUI

@MainActor
struct ProfileTab: View {
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(Theme.self) private var theme
    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    @Binding var popToRootTab: Tab
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(UserPreferences.self) private var preferences
    
    
    @Binding var selectedTab: Tab
    let lockedType: PreferencesStorageModel.Properties.SortingModes?
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            FavoritesView()
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                .withCoreDataContext()
                .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
                .background(theme.primaryBackgroundColor)
                .toolbar {
                    toolbarView
                }
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
//    var body: some View {
//        NavigationStack(path: $routerPath.path) {
//            Text(authenticationManager.currentAccount?.email ?? "")
//                .withAppRouter()
//                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
//                .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
//                .toolbar {
//                    toolbarView
//                }
              
//            if let account = authenticationManager.currentAccount {
//                AccountDetailView(account: account, scrollToTopSignal: $scrollToTopSignal)
//                    .withAppRouter()
//                    .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
//                    .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
//                    .id(account.id)
//            } else {
//                AccountDetailView(account: .placeholder(), scrollToTopSignal: $scrollToTopSignal)
//                    .redacted(reason: .placeholder)
//                    .allowsHitTesting(false)
//            }
//        }
//        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
//            if newValue == .profile {
//                if routerPath.path.isEmpty {
//                    scrollToTopSignal += 1
//                } else {
//                    routerPath.path = []
//                }
//            }
//        }
//        .withSafariRouter()
//        .environment(routerPath)
//    }
    
    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        
        if authenticationManager.isAuth {
            ToolbarTab(routerPath: $routerPath)
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                addAccountButton
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
}
