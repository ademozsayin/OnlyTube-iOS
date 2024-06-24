import Combine
import Foundation
import SwiftUI

@MainActor
@Observable public class UserPreferences: Sendable {
    final class Storage {
        @AppStorage("preferred_browser") public var preferredBrowser: PreferredBrowser = .inAppSafari
                
        @AppStorage("haptic_tab") public var hapticTabSelectionEnabled = true
        @AppStorage("haptic_timeline") public var hapticTimelineEnabled = true
        @AppStorage("haptic_button_press") public var hapticButtonPressEnabled = true
        @AppStorage("sound_effect_enabled") public var soundEffectEnabled = true
        
        @AppStorage("show_second_column_ipad") public var showiPadSecondaryColumn = true
        @AppStorage("show_tab_label_iphone") public var showiPhoneTabLabel = true

        @AppStorage("inAppBrowserReaderView") public var inAppBrowserReaderView = false
        @AppStorage("enableAutoPlayAtStart") public var enableAutoPlayAtStart = false

        @AppStorage("showBackgroundImage") public var showBackgroundImage = false
       
        @AppStorage("sidebar_expanded") public var isSidebarExpanded: Bool = false

        @AppStorage("appicon") public var appIcon: String = "AppIcon"

        @AppStorage("hasAcceptedDisclaimer") var hasAcceptedDisclaimer: Bool = false
        
        init() {
            prepareTranslationType()
        }
        
        private func prepareTranslationType() {
            let sharedDefault = UserDefaults.standard
        }
    }
    
    public static let sharedDefault = UserDefaults(suiteName: "group.agency.fiable.OnsaTube")
    public static let shared = UserPreferences()
    private let storage = Storage()
    
    public var preferredBrowser: PreferredBrowser {
        didSet {
            storage.preferredBrowser = preferredBrowser
        }
    }
    
    public var hapticTabSelectionEnabled: Bool {
        didSet {
            storage.hapticTabSelectionEnabled = hapticTabSelectionEnabled
        }
    }
    
    public var hapticTimelineEnabled: Bool {
        didSet {
            storage.hapticTimelineEnabled = hapticTimelineEnabled
        }
    }
    
    public var hapticButtonPressEnabled: Bool {
        didSet {
            storage.hapticButtonPressEnabled = hapticButtonPressEnabled
        }
    }
    
    public var soundEffectEnabled: Bool {
        didSet {
            storage.soundEffectEnabled = soundEffectEnabled
        }
    }
    
    public var showiPadSecondaryColumn: Bool {
        didSet {
            storage.showiPadSecondaryColumn = showiPadSecondaryColumn
        }
    }
    
    
    public var showiPhoneTabLabel: Bool {
        didSet {
            storage.showiPhoneTabLabel = showiPhoneTabLabel
        }
    }
    
    public var inAppBrowserReaderView: Bool {
        didSet {
            storage.inAppBrowserReaderView = inAppBrowserReaderView
        }
    }
    
    public var enableAutoPlayAtStart: Bool {
        didSet {
            storage.enableAutoPlayAtStart = enableAutoPlayAtStart
        }
    }
    
    public var showBackgroundImage: Bool {
        didSet {
            storage.showBackgroundImage = showBackgroundImage
        }
    }
    
    public var isSidebarExpanded: Bool {
        didSet {
            storage.isSidebarExpanded = isSidebarExpanded
        }
    }
    
    public var appIcon: String {
        didSet {
            storage.appIcon = appIcon
        }
    }
    
    public var hasAcceptedDisclaimer: Bool {
        didSet {
            storage.hasAcceptedDisclaimer = hasAcceptedDisclaimer
        }
    }
    
    private init() {
        preferredBrowser = storage.preferredBrowser
 
        hapticTabSelectionEnabled = storage.hapticTabSelectionEnabled
        hapticTimelineEnabled = storage.hapticTimelineEnabled
        hapticButtonPressEnabled = storage.hapticButtonPressEnabled
        
        soundEffectEnabled = storage.soundEffectEnabled
        showiPadSecondaryColumn = storage.showiPadSecondaryColumn
    
        showiPhoneTabLabel = storage.showiPhoneTabLabel
        
        inAppBrowserReaderView = storage.inAppBrowserReaderView
        enableAutoPlayAtStart = storage.enableAutoPlayAtStart
        
        showBackgroundImage = storage.showBackgroundImage
        
        isSidebarExpanded = storage.isSidebarExpanded

        appIcon = storage.appIcon
        
        hasAcceptedDisclaimer = storage.hasAcceptedDisclaimer
    }
}

extension UInt: RawRepresentable {
    public var rawValue: Int {
        Int(self)
    }
    
    public init?(rawValue: Int) {
        if rawValue >= 0 {
            self.init(rawValue)
        } else {
            return nil
        }
    }
}
