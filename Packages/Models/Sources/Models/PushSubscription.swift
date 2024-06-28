import Foundation

public struct PushSubscription: Identifiable, Decodable {
    public struct Alerts: Decodable {
        public let status: Bool
    }
    
    public let id: Int
    public let endpoint: URL
    public let serverKey: String
    public let alerts: Alerts
}

extension PushSubscription: Sendable {}
extension PushSubscription.Alerts: Sendable {}
