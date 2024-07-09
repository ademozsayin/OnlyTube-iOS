import DesignSystem
import Env
import Network
import SwiftUI
import FirebaseAuth

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
    
//    @Binding var selectedTab: Tab
    let lockedType: PreferencesStorageModel.Properties.SortingModes?
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            if let account = authenticationManager.currentAccount {
                AccountDetailView(account: account, scrollToTopSignal: $scrollToTopSignal)
                    .withAppRouter()
                    .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                    .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
                    .id(account.uid)
            } else {
                LoadingView()
            }
        }
        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
            if newValue == .profile {
                if routerPath.path.isEmpty {
                    scrollToTopSignal += 1
                } else {
                    routerPath.path = []
                }
            }
        }
        .withSafariRouter()
        .environment(routerPath)
        .withCoreDataContext()
    }
    
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

#Preview {
    ProfileTab(popToRootTab: .constant(.profile), lockedType: nil)
        .withPreviewsEnv()
        .environment(Theme.shared)
        .environment(AuthenticationManager.shared)
}
