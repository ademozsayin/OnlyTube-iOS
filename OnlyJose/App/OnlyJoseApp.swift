//
//  OnlyJoseApp.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 5.06.2024.
//

import SwiftUI
import SwiftData
import AVFoundation
import DesignSystem
import Env
import RevenueCat

@main
struct OnlyJoseApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openWindow) var openWindow
    
 
    @State var userPreferences = UserPreferences.shared
    @State var theme = Theme.shared
    
    @State var selectedTab: Tab = .timeline
    @State var appRouterPath = RouterPath()
    
    @State var isSupporter: Bool = false
    
    var body: some Scene {
        appScene
    }
    
    func setupRevenueCat() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_UoVNogcNbQvbVhJdPtMSJJffSiF")
        Purchases.shared.getCustomerInfo { info, _ in
            if info?.entitlements["Supporter"]?.isActive == true {
                isSupporter = true
            }
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        return true
    }
    
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .document)
        builder.remove(menu: .toolbar)
        builder.remove(menu: .sidebar)
    }
}
