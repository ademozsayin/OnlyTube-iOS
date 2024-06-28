//
//  PushNotificationsService.swift
//  
//
//  Created by Adem Özsayın on 28.06.2024.
//

import Combine
import CryptoKit
import Foundation
import KeychainSwift
import Models
import Network
import Observation
import SwiftUI
import UserNotifications

extension UNNotificationResponse: @unchecked Sendable {}
extension UNUserNotificationCenter: @unchecked Sendable {}

public struct PushAccount: Equatable {
    public let server: String?
    public let token: String?//OauthToken
    public let accountName: String?
    
    public init(server: String?, token: String?, accountName: String?) {
        self.server = server
        self.token = token
        self.accountName = accountName
    }
}

public struct HandledNotification: Equatable {
    public let account: PushAccount
    public let notification: String?//Models.Notification
}

@MainActor
@Observable public class PushNotificationsService: NSObject {
    enum Constants {
        static let endpoint = "https://icecubesrelay.fly.dev"
        static let keychainAuthKey = "notifications_auth_key"
        static let keychainPrivateKey = "notifications_private_key"
    }
    
    public static let shared = PushNotificationsService()
    
    public private(set) var subscriptions: [PushNotificationSubscriptionSettings] = []
    
    public var pushToken: Data?
    
    public var handledNotification: HandledNotification?
    
    override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    private var keychain: KeychainSwift {
        let keychain = KeychainSwift()
#if !DEBUG && !targetEnvironment(simulator)
        keychain.accessGroup = AppInfo.keychainGroup
#endif
        return keychain
    }
    
    public func requestPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    public func setAccounts(accounts: [PushAccount]) {
        subscriptions = []
        for account in accounts {
            let sub = PushNotificationSubscriptionSettings(account: account,
                                                           key: notificationsPrivateKeyAsKey.publicKey.x963Representation,
                                                           authKey: notificationsAuthKeyAsKey,
                                                           pushToken: pushToken)
            subscriptions.append(sub)
        }
    }
    
    public func updateSubscriptions(forceCreate: Bool) async {
        for subscription in subscriptions {
            await withTaskGroup(of: Void.self, body: { group in
                group.addTask {
                    await subscription.fetchSubscription()
                    if await subscription.subscription != nil, !forceCreate {
                        await subscription.deleteSubscription()
                        await subscription.updateSubscription()
                    } else if forceCreate {
                        await subscription.updateSubscription()
                    }
                }
            })
        }
    }
    
    // MARK: - Key management
    
    public var notificationsPrivateKeyAsKey: P256.KeyAgreement.PrivateKey {
        if let key = keychain.get(Constants.keychainPrivateKey),
           let data = Data(base64Encoded: key)
        {
            do {
                return try P256.KeyAgreement.PrivateKey(rawRepresentation: data)
            } catch {
                let key = P256.KeyAgreement.PrivateKey()
                keychain.set(key.rawRepresentation.base64EncodedString(),
                             forKey: Constants.keychainPrivateKey,
                             withAccess: .accessibleAfterFirstUnlock)
                return key
            }
        } else {
            let key = P256.KeyAgreement.PrivateKey()
            keychain.set(key.rawRepresentation.base64EncodedString(),
                         forKey: Constants.keychainPrivateKey,
                         withAccess: .accessibleAfterFirstUnlock)
            return key
        }
    }
    
    public var notificationsAuthKeyAsKey: Data {
        if let key = keychain.get(Constants.keychainAuthKey),
           let data = Data(base64Encoded: key)
        {
            return data
        } else {
            let key = Self.makeRandomNotificationsAuthKey()
            keychain.set(key.base64EncodedString(),
                         forKey: Constants.keychainAuthKey,
                         withAccess: .accessibleAfterFirstUnlock)
            return key
        }
    }
    
    private static func makeRandomNotificationsAuthKey() -> Data {
        let byteCount = 16
        var bytes = Data(count: byteCount)
        _ = bytes.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, byteCount, $0.baseAddress!) }
        return bytes
    }
}

extension PushNotificationsService: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response.notification.request.content.userInfo)
    }
}

extension Data {
    var hexString: String {
        map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}

@MainActor
@Observable public class PushNotificationSubscriptionSettings {
    public var isEnabled: Bool = true
   
    public let account: PushAccount
    
    private let key: Data
    private let authKey: Data
    
    public var pushToken: Data?
    
    public private(set) var subscription: PushSubscription?
    
    public init(account: PushAccount, key: Data, authKey: Data, pushToken: Data?) {
        self.account = account
        self.key = key
        self.authKey = authKey
        self.pushToken = pushToken
    }
    
    private func refreshSubscriptionsUI() {
        if let subscription {
//            isNewPostsNotificationEnabled = subscription.alerts.status
        }
    }
    
    public func updateSubscription() async {
        guard let pushToken else { return }

        // TODO:
    }
    
    public func deleteSubscription() async {
        // TODO:
    }
    
    public func fetchSubscription() async {
        // TODO:
    }
}
