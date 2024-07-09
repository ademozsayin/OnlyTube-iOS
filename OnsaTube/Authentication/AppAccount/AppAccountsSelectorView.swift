import DesignSystem
import Env
import SwiftUI
import SwiftData
import Models

@MainActor
public struct AppAccountsSelectorView: View {
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    
    var routerPath: RouterPath
    
    @State private var accountsViewModel: AppAccountViewModel
    
    @State private var isPresented: Bool = false
    
    private let accountCreationEnabled: Bool
    private let avatarConfig: AvatarView.FrameConfig
    
    @Environment(AuthenticationManager.self) private var authenticationManager

    @State private var showAlert = false
    
    private var preferredHeight: CGFloat {
        var baseHeight: CGFloat = 480
        baseHeight += CGFloat(60)
        return baseHeight
    }
    
    @Query(sort: \Draft.creationDate, order: .reverse) var drafts: [Draft]
    
    public init(routerPath: RouterPath,
                accountCreationEnabled: Bool = true,
                avatarConfig: AvatarView.FrameConfig? = nil)
    {
        self.routerPath = routerPath
        self.accountCreationEnabled = accountCreationEnabled
        self.avatarConfig = avatarConfig ?? .badge

        _accountsViewModel = State(initialValue: AppAccountViewModel(
            appAccount: AuthenticationManager.shared.currentAccount,
            isInSettings: false,
            showBadge: true
        ))
    }
    
    
    public var body: some View {
        Button {
            isPresented.toggle()
            HapticManager.shared.fireHaptic(.buttonPress)
        } label: {
            labelView
                .contentShape(Rectangle())
        }
        .sheet(isPresented: $isPresented, content: {
            accountsView.presentationDetents([.height(preferredHeight), .large])
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(16)
                .onAppear {
                    Task {
                        await refreshAccounts()
                    }
                }
        })
        .onChange(of: authenticationManager.currentAccount?.uid) {
            Task {
                await refreshAccounts()
            }
        }
        .onAppear {
            Task {
                await refreshAccounts()
            }
        }
        .accessibilityRepresentation {
            Menu("accessibility.app-account.selector.accounts") {}
                .accessibilityHint("accessibility.app-account.selector.accounts.hint")
                .accessibilityRemoveTraits(.isButton)
        }
    }
    
    @ViewBuilder
    private var labelView: some View {
        Group {
            if let account = authenticationManager.currentAccount {
                AvatarView(account.photoURL, config: avatarConfig)
            } else {
                AvatarView(config: avatarConfig)
                    .redacted(reason: .placeholder)
                    .allowsHitTesting(false)
            }
        }.overlay(alignment: .topTrailing) {
            if accountCreationEnabled {
                Circle()
                    .fill(Color.red)
                    .frame(width: 9, height: 9)
            }
        }
    }
    
    private var accountsView: some View {
        NavigationStack {
            List {
                Section {
                    if let currentAccount = accountsViewModel.appAccount {
                       
                        AppAccountView(viewModel: accountsViewModel , isParentPresented: $isPresented)
                    }
//                    addAccountButton
#if os(visionOS)
                        .foregroundStyle(theme.labelColor)
#endif
                }
#if !os(visionOS)
                .listRowBackground(theme.primaryBackgroundColor.opacity(0.4))
#endif
                
                Section {
                    contentSettingsButton
                    if !drafts.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack {
                                ForEach(drafts, id:\.self) { draft in
                                    Button {
                                        
                                    } label: {
                                        Text(draft.content)
                                    }
                                    .buttonStyle(SecondaryButtonStyle())
                                }
                            }
                        }
                    }
                }
#if os(visionOS)
                .foregroundStyle(theme.labelColor)
#else
                .listRowBackground(theme.primaryBackgroundColor.opacity(0.4))
#endif
                
                if accountCreationEnabled {
                    Section {
                        settingsButton
                        aboutButton
                        supportButton
                    }
#if os(visionOS)
                    .foregroundStyle(theme.labelColor)
#else
                    .listRowBackground(theme.primaryBackgroundColor.opacity(0.4))
#endif
                }
                
                Section {
                    Button {
                        print("dlete acc")
                        showAlert.toggle()
                    } label: {
                        Text("Delete Account")
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                    .clipShape(.rect(cornerRadius: 12))
                }
#if os(visionOS)
                .foregroundStyle(theme.labelColor)
#else
                .listRowBackground(theme.primaryBackgroundColor.opacity(0.4))
#endif
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(.clear)
            .navigationTitle("settings.section.accounts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("action.done").bold()
                    }
                }
            }
            .environment(routerPath)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Do you want to delete your account?"),
                message: Text("This action can not be undone."),
                primaryButton: .destructive(Text("Yes"), action: {
                    deleteAccount()
                }),
                secondaryButton: .default(Text("No"))
            )
        }
    }
    
    private func deleteAccount () {
        guard let account = authenticationManager.currentAccount else { return }
        Task {
            do {
                try await account.delete()
            } catch {
                print(error)
            }
        }
    }
    
    private var addAccountButton: some View {
        Button {
            isPresented = false
            HapticManager.shared.fireHaptic(.buttonPress)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                routerPath.presentedSheet = .login
            }
        } label: {
            Label("app-account.button.add", systemImage: "person.badge.plus")
        }
    }
    
    private var settingsButton: some View {
        Button {
            isPresented = false
            HapticManager.shared.fireHaptic(.buttonPress)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                routerPath.presentedSheet = .settings
            }
        } label: {
            Label("tab.settings", systemImage: "gear")
        }
    }
    
    private var supportButton: some View {
        Button {
            isPresented = false
            HapticManager.shared.fireHaptic(.buttonPress)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                routerPath.presentedSheet = .support
            }
        } label: {
            Label("settings.app.support", systemImage: "wand.and.stars")
        }
    }
    
    private var aboutButton: some View {
        Button {
            isPresented = false
            HapticManager.shared.fireHaptic(.buttonPress)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                routerPath.presentedSheet = .about
            }
        } label: {
            Label("settings.app.about", systemImage: "info.circle")
        }
    }
    
    private var contentSettingsButton: some View {
        Button {
            isPresented = false
            HapticManager.shared.fireHaptic(.buttonPress)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                routerPath.presentedSheet = .categorySelection
            }
        } label: {
            Label("Content Selection", systemImage: "filemenu.and.selection")
        }
    }
    
    private func refreshAccounts() async {
        
        await accountsViewModel.fetchAccount()
        
        let viewModel: AppAccountViewModel = .init(
            appAccount: authenticationManager.currentAccount,
            isInSettings: false,
            showBadge: true
        )
        self.accountsViewModel = viewModel
    }
}
