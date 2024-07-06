//
//  AccountSettingsView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 6.07.2024.
//


import DesignSystem
import Env
import Models
import Network
import SwiftUI
import FirebaseAuth

@MainActor
struct AccountSettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    @Environment(PushNotificationsService.self) private var pushNotifications
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath
    
    @State private var cachedPostsCount: Int = 0
    
    let account: User
    let appAccount: User

    
    var body: some View {
        Form {
            Section {
                Button {
                    routerPath.presentedSheet = .accountEditInfo
                } label: {
                    Label("Edit Info", systemImage: "pencil")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                if let subscription = pushNotifications.subscriptions.first {
                    NavigationLink(destination: PushNotificationsView(subscription: subscription)) {
                        Label("settings.general.push-notifications", systemImage: "bell.and.waves.left.and.right")
                    }
                }
                
            }
            .listRowBackground(theme.primaryBackgroundColor)
                        
            Section {
                Button(role: .destructive) {
                        Task {
                            try await authenticationManager.signOut()
                            dismiss()
                        }
                    
                } label: {
                    Text("account.action.logout")
                        .frame(maxWidth: .infinity)
                }
            }
            .listRowBackground(theme.primaryBackgroundColor)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    AvatarView(account.photoURL, config: .embed)
                    Text(account.displayName ?? "No name")
                        .font(.headline)
                }
            }
        }

        .navigationTitle(account.displayName ?? "No name")
#if !os(visionOS)
        .scrollContentBackground(.hidden)
        .background(theme.secondaryBackgroundColor)
#endif
    }
}
