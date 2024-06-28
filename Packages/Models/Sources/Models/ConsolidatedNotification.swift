//
//  ConsolidatedNotification.swift
//
//
//  Created by Jérôme Danthinne on 31/01/2023.
//

import Foundation

public struct ConsolidatedNotification: Identifiable {
    public let notifications: [Notification]
    public let type: Notification.NotificationType

    
    public var id: String? { notifications.first?.id }
    
    public init(notifications: [Notification],
                type: Notification.NotificationType)
    {
        self.notifications = notifications
        self.type = type
    }
    
    public static func placeholder() -> ConsolidatedNotification {
        .init(notifications: [Notification.placeholder()],
              type: .favourite)
    }
    
    public static func placeholders() -> [ConsolidatedNotification] {
        [.placeholder(), .placeholder(), .placeholder(),
         .placeholder(), .placeholder(), .placeholder(),
         .placeholder(), .placeholder(), .placeholder(),
         .placeholder(), .placeholder(), .placeholder()]
    }
}

extension ConsolidatedNotification: Sendable {}
