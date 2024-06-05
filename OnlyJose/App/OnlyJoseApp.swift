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

@main
struct OnlyJoseApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        appScene
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
