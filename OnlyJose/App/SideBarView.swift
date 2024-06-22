//
//  SideBarView.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 21.06.2024.
//

import DesignSystem
import Env
import Models
import SwiftUI
import SwiftUIIntrospect

@MainActor
struct SideBarView<Content: View>: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(Theme.self) private var theme
//    @Environment(StreamWatcher.self) private var watcher
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(RouterPath.self) private var routerPath
    
    @Binding var selectedTab: Tab
    @Binding var popToRootTab: Tab
    var tabs: [Tab]
    @ViewBuilder var content: () -> Content
    
    @State private var sidebarTabs = SidebarTabs.shared
    
    @State private var isHovered: Bool = true

    
    private func badgeFor(tab: Tab) -> Int {
        return 0
    }
    
    private func makeIconForTab(tab: Tab) -> some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                SideBarIcon(systemIconName: tab.iconName,
                            isSelected: tab == selectedTab)
                let badge = badgeFor(tab: tab)
                if badge > 0 {
                    makeBadgeView(count: badge)
                }
            }
            if userPreferences.isSidebarExpanded {
                Text(tab.title)
                    .font(.headline)
                    .foregroundColor(tab == selectedTab ? theme.tintColor : theme.labelColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: (userPreferences.isSidebarExpanded ? .sidebarWidthExpanded : .sidebarWidth) - 24, height: 50)
        .background(tab == selectedTab ? theme.secondaryBackgroundColor : .clear,
                    in: RoundedRectangle(cornerRadius: 8))
    }
    
    private func makeBadgeView(count: Int) -> some View {
        ZStack {
            Circle()
                .fill(.red)
            Text(count > 99 ? "99+" : String(count))
                .foregroundColor(.white)
                .font(.caption2)
        }
        .frame(width: 24, height: 24)
        .offset(x: 14, y: -14)
    }
    
    private var postButton: some View {

        
        Button {
#if targetEnvironment(macCatalyst) || os(visionOS)
//            openWindow(value: WindowDestinationEditor.newStatusEditor(visibility: userPreferences.postVisibility))
#else
//            routerPath.presentedSheet = .newStatusEditor(visibility: userPreferences.postVisibility)
#endif
        } label: {
//            Image(systemName: "square.and.pencil")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 20, height: 30)
//                .offset(x: 2, y: -2)
            
            BouncyJose()
                
            
        }
//        .buttonStyle(.borderedProminent)
//        .help(Tab.post.title)
    }
    
//    private func makeAccountButton(account: AppAccount, showBadge: Bool) -> some View {
//        Button {
//            if account.id == appAccounts.currentAccount.id {
//                selectedTab = .profile
//                SoundEffectManager.shared.playSound(.tabSelection)
//            } else {
//                var transation = Transaction()
//                transation.disablesAnimations = true
//                withTransaction(transation) {
//                    appAccounts.currentAccount = account
//                }
//            }
//        } label: {
//            ZStack(alignment: .topTrailing) {
//                if userPreferences.isSidebarExpanded {
//                    AppAccountView(viewModel: .init(appAccount: account,
//                                                    isCompact: false,
//                                                    isInSettings: false),
//                                   isParentPresented: .constant(false))
//                } else {
//                    AppAccountView(viewModel: .init(appAccount: account,
//                                                    isCompact: true,
//                                                    isInSettings: false),
//                                   isParentPresented: .constant(false))
//                }
//                if !userPreferences.isSidebarExpanded,
//                   showBadge,
//                   let token = account.oauthToken,
//                   let notificationsCount = userPreferences.notificationsCount[token],
//                   notificationsCount > 0
//                {
//                    makeBadgeView(count: notificationsCount)
//                }
//            }
//            .padding(.leading, userPreferences.isSidebarExpanded ? 16 : 0)
//        }
//        .help(accountButtonTitle(accountName: account.accountName))
//        .frame(width: userPreferences.isSidebarExpanded ? .sidebarWidthExpanded : .sidebarWidth, height: 50)
//        .padding(.vertical, 8)
//        .background(selectedTab == .profile && account.id == appAccounts.currentAccount.id ?
//                    theme.secondaryBackgroundColor : .clear)
//    }
    
//    private func accountButtonTitle(accountName: String?) -> LocalizedStringKey {
//        if let accountName {
//            "tab.profile-account-\(accountName)"
//        } else {
//            Tab.profile.title
//        }
//    }
    
    private var tabsView: some View {
        ForEach(tabs) { tab in
//            if tab != .profile && sidebarTabs.isEnabled(tab) {
            if sidebarTabs.isEnabled(tab) {
                Button {
                    // ensure keyboard is always dismissed when selecting a tab
                    hideKeyboard()
                    
                    if tab == selectedTab {
                        popToRootTab = .other
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            popToRootTab = tab
                        }
                    }
                    selectedTab = tab
                    SoundEffectManager.shared.playSound(.tabSelection)
//                    if tab == .notifications {
//                        if let token = appAccounts.currentAccount.oauthToken {
//                            userPreferences.notificationsCount[token] = 0
//                        }
//                        watcher.unreadNotificationsCount = 0
//                    }
                } label: {
                    makeIconForTab(tab: tab)
                }
                .help(tab.title)
            }
        }
    }
    
    var body: some View {
        @Bindable var routerPath = routerPath
        HStack(spacing: 0) {
            if horizontalSizeClass == .regular {
                ScrollView {
                    VStack(alignment: .center) {
//                        if appAccounts.availableAccounts.isEmpty {
                            tabsView
//                        } else {
//                            ForEach(appAccounts.availableAccounts) { account in
//                                makeAccountButton(account: account,
//                                                  showBadge: account.id != appAccounts.currentAccount.id)
//                                if account.id == appAccounts.currentAccount.id {
//                                    tabsView
//                                }
//                            }
//                        }
                    }
                }
                .frame(width: userPreferences.isSidebarExpanded ? .sidebarWidthExpanded : .sidebarWidth)
                .scrollContentBackground(.hidden)
                .background(.thinMaterial)
                .safeAreaInset(edge: .bottom, content: {
                    HStack(spacing: 16) {
                        postButton
                            .padding(.vertical, 24)
                            .padding(.leading, userPreferences.isSidebarExpanded ? 18 : 0)
                        if userPreferences.isSidebarExpanded {
                            Text("menu.new-post")
                                .font(.subheadline)
                                .foregroundColor(theme.labelColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(width: userPreferences.isSidebarExpanded ? .sidebarWidthExpanded : .sidebarWidth)
                    .background(.thinMaterial)
                })
                Divider().edgesIgnoringSafeArea(.all)
            }
            content()
        }
        .background(.thinMaterial)
        .edgesIgnoringSafeArea(.bottom)
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
    }
}

private struct SideBarIcon: View {
    @Environment(Theme.self) private var theme
    
    let systemIconName: String
    let isSelected: Bool
    
    @State private var isHovered: Bool = false
    
    var body: some View {
        Image(systemName: systemIconName)
            .font(.title2)
            .fontWeight(.medium)
            .foregroundColor(isSelected ? theme.tintColor : theme.labelColor)
            .symbolVariant(isSelected ? .fill : .none)
            .scaleEffect(isHovered ? 0.8 : 1.0)
            .onHover { isHovered in
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                    self.isHovered = isHovered
                }
            }
            .frame(width: 50, height: 40)
    }
}

extension View {
    @MainActor func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}


struct BouncyJose: View {
    
    @State var bounceHeight: BounceHeight? = nil
    @Environment(UserPreferences.self) private var userPreferences

    func bounceAnimation() {
        withAnimation(Animation.easeOut(duration: 0.3).delay(0)) {
            bounceHeight = .up100
        }
        withAnimation(Animation.easeInOut(duration: 0.04).delay(0)) {
            bounceHeight = .up100
        }
        withAnimation(Animation.easeIn(duration: 0.3).delay(0.34)) {
            bounceHeight = .base
        }
        withAnimation(Animation.easeOut(duration: 0.2).delay(0.64)) {
            bounceHeight = .up40
        }
        withAnimation(Animation.easeIn(duration: 0.2).delay(0.84)) {
            bounceHeight = .base
        }
        withAnimation(Animation.easeOut(duration: 0.1).delay(1.04)) {
            bounceHeight = .up10
        }
        withAnimation(Animation.easeIn(duration: 0.1).delay(1.14)) {
            bounceHeight = .none
        }
    }
    
    var body: some View {
        VStack {
//            let icon = IconSelectorView.Icon(string: UIApplication.shared.alternateIconName ?? "AppIcon")
            let icon =  IconSelectorView.Icon(string: userPreferences.appIcon)
            Image(uiImage: .init(named: icon.appIconName)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.circle)
        }
        .frame(width: 72, height: 72)
        .offset(y: bounceHeight?.associatedOffset ?? 0)
        .onTapGesture {
            bounceAnimation()
        }
    }
}

enum BounceHeight {
    case up100, up40, up10, base
    var associatedOffset: Double {
        switch self {
            case .up100:
                return -100
            case .up40:
                return -40
            case .up10:
                return -10
            case .base:
                return 0
        }
    }
}
