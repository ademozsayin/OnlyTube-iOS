//
//  OnsaTubeApp.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 5.06.2024.
//

import SwiftUI
import SwiftData
import AVFoundation
import DesignSystem
import Env
import RevenueCat
import FirebaseCore
import FirebaseMessaging

@main
struct OnsaTubeApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openWindow) var openWindow
   
    
    @State var userPreferences = UserPreferences.shared
    @State var theme = Theme.shared
    @State var selectedTab: Tab = .timeline
    @State var appRouterPath = RouterPath()
    @State var isSupporter: Bool = false
    @State var pushNotificationsService = PushNotificationsService.shared

    var body: some Scene {
        appScene
    }
    
    func handleScenePhase(scenePhase: ScenePhase) {
        switch scenePhase {
            case .background:
              print("")
            case .active:
              
                UNUserNotificationCenter.current().setBadgeCount(0)
                
                Task {
//                    await userPreferences.refreshServerPreferences()
                }
            default:
                break
        }
    }
    
    
    func refreshPushSubs() {
        PushNotificationsService.shared.requestPushNotifications()
    }

    
    func setupRevenueCat() {
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_UoVNogcNbQvbVhJdPtMSJJffSiF")
        Purchases.shared.getCustomerInfo { info, _ in
            if info?.entitlements["Supporter"]?.isActive == true {
                isSupporter = true
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
//        PushNotificationsService.shared.setAccounts(accounts: AppAccountsManager.shared.pushAccounts)
        return true
    }
    
    func application(_: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        PushNotificationsService.shared.pushToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        Task {
//            PushNotificationsService.shared.setAccounts(accounts: AppAccountsManager.shared.pushAccounts)
            await PushNotificationsService.shared.updateSubscriptions(forceCreate: false)
        }
    }
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {}
    
    func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
       
        return .noData
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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("fcm", fcm)
        }
    }
}
