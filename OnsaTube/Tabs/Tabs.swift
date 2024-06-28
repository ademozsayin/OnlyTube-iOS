import DesignSystem
import Env
import Foundation
import SwiftUI

@MainActor
enum Tab: Int, Identifiable, Hashable, CaseIterable, Codable {
    case timeline, notifications, settings, other
    case favorite
    nonisolated var id: Int {
        rawValue
    }
    
    static func loggedOutTab() -> [Tab] {
        [.timeline, .favorite,.settings]
    }
    
    static func visionOSTab() -> [Tab] {
        [ .timeline, .notifications, .settings]
    }
    
    @ViewBuilder
    func makeContentView(selectedTab: Binding<Tab>, popToRootTab: Binding<Tab>) -> some View {
        EmptyView()
        switch self {
            case .timeline:
                SearchTab(popToRootTab: popToRootTab)
            case .notifications:
                NotificationsTab(selectedTab: selectedTab, popToRootTab: popToRootTab)
            case .settings:
                SettingsTabs(popToRootTab: popToRootTab, isModal: false)
                    .withEnvironments()
                    .preferredColorScheme(Theme.shared.selectedScheme == .dark ? .dark : .light)
            case .favorite:
                FavoriteTab(popToRootTab: popToRootTab, selectedTab: selectedTab, lockedType: nil)

            case .other:
                Text("other")
        }
    }
    
    @ViewBuilder
    var label: some View {
        if self != .other {
            Label(title, systemImage: iconName)
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
            case .timeline:
                "tab.timeline"
           
            case .notifications:
                "notifications"
          
            case .settings:
                "tab.settings"
                
            case .favorite:
                "tab.favorites"
           
            case .other:
                ""
        }
    }
    
    var iconName: String {
        switch self {
            case .timeline:
                "rectangle.stack"
                
            case .notifications:
                "bell"
            
            case .settings:
                "gear"
                
            case .favorite:
                "heart"
           
            case .other:
                ""
        }
    }
}

@MainActor
@Observable
class SidebarTabs {
    struct SidedebarTab: Hashable, Codable {
        let tab: Tab
        var enabled: Bool
    }
    
    class Storage {
        @AppStorage("sidebar_tabs") var tabs: [SidedebarTab] = [
            .init(tab: .timeline, enabled: true),
            .init(tab: .notifications, enabled: true),
            .init(tab: .favorite, enabled: true),
            .init(tab: .settings, enabled: true)
        ]
    }
    
    private let storage = Storage()
    public static let shared = SidebarTabs()
    
    var tabs: [SidedebarTab] {
        didSet {
            storage.tabs = tabs
        }
    }
    
    func isEnabled(_ tab: Tab) -> Bool {
        tabs.first(where: { $0.tab.id == tab.id })?.enabled == true
    }
    
    private init() {
        tabs = storage.tabs
    }
}

@MainActor
@Observable
class iOSTabs {
    enum TabEntries: String {
        case first, second, third, four
    }
    
    class Storage {
        @AppStorage(TabEntries.first.rawValue) var firstTab = Tab.timeline
        @AppStorage(TabEntries.second.rawValue) var secondTab = Tab.notifications
        @AppStorage(TabEntries.third.rawValue) var thirdTab = Tab.favorite
        @AppStorage(TabEntries.four.rawValue) var fourTab = Tab.settings

    }
    
    private let storage = Storage()
    public static let shared = iOSTabs()
    
    var tabs: [Tab] {
        [firstTab, secondTab, thirdTab, fourTab]
    }
    
    var firstTab: Tab {
        didSet {
            storage.firstTab = firstTab
        }
    }
    
    var secondTab: Tab {
        didSet {
            storage.secondTab = secondTab
        }
    }
    
    var thirdTab: Tab {
        didSet {
            storage.thirdTab = thirdTab
        }
    }
    
    var fourTab: Tab {
        didSet {
            storage.fourTab = fourTab
        }
    }
    
    private init() {
        firstTab = storage.firstTab
        secondTab = storage.secondTab
        thirdTab = storage.thirdTab
        fourTab = storage.fourTab

    }
}
