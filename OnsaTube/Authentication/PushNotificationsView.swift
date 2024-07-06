import DesignSystem
import Env
import Models
import Network
import NukeUI
import SwiftUI
import UserNotifications

@MainActor
struct PushNotificationsView: View {
    @Environment(Theme.self) private var theme
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(PushNotificationsService.self) private var pushNotifications
    
    @State public var subscription: PushNotificationSubscriptionSettings?
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: .init(get: {
                    subscription?.isEnabled ?? false
                }, set: { newValue in
                    subscription?.isEnabled = newValue
                    if newValue {
                        updateSubscription()
                    } else {
                        deleteSubscription()
                    }
                })) {
                    Text("settings.push.main-toggle")
                }
            } footer: {
                Text("settings.push.main-toggle.description")
            }
#if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
#endif
            
            Section {
                Button("settings.push.duplicate.button.fix") {
                    Task {
                        await subscription?.deleteSubscription()
                        await subscription?.updateSubscription()
                    }
                }
            } header: {
                Text("settings.push.duplicate.title")
            } footer: {
                Text("settings.push.duplicate.footer")
            }
#if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
#endif
        }
        .navigationTitle("settings.push.navigation-title")
#if !os(visionOS)
        .scrollContentBackground(.hidden)
        .background(theme.secondaryBackgroundColor)
#endif
        .task {
//            await subscription?.fetchSubscription()
        }
    }
    
    private func updateSubscription() {
        Task {
            await subscription?.updateSubscription()
        }
    }
    
    private func deleteSubscription() {
        Task {
            await subscription?.deleteSubscription()
        }
    }
}
