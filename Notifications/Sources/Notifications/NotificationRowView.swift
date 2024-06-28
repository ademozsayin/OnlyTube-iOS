import DesignSystem
import Env
import Models
import Network
import SwiftUI

@MainActor
struct NotificationRowView: View {
    @Environment(Theme.self) private var theme
    @Environment(\.redactionReasons) private var reasons
    
    let notification: ConsolidatedNotification
    let routerPath: RouterPath
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("Notif")
        }
    }
}
