//
//  Notification.swift
//
//
//  Created by Adem Özsayın on 28.06.2024.
//

import Foundation

public struct Notification: Decodable, Identifiable, Equatable {
    public enum NotificationType: String, CaseIterable {
        case follow, follow_request, mention, reblog, status, favourite, poll, update
    }
    
    public let id: String
    public let type: String
 
    
    public var supportedType: NotificationType? {
        .init(rawValue: type)
    }
    
    public static func placeholder() -> Notification {
        .init(id: UUID().uuidString,
              type: NotificationType.favourite.rawValue)
    }
}

extension Notification: Sendable {}
extension Notification.NotificationType: Sendable {}
