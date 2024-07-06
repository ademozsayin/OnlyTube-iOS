import DesignSystem
import Env
import SwiftUI
import FirebaseAuth

@MainActor
public struct AppAccountView: View {
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(UserPreferences.self) private var preferences
    
    @State var viewModel: AppAccountViewModel
    
    @Binding var isParentPresented: Bool
    
    public init(viewModel: AppAccountViewModel, isParentPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _isParentPresented = isParentPresented
    }
    
    public var body: some View {
        Group {
            if viewModel.isCompact {
                compactView
            } else {
                fullView
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAccount()
            }
        }
    }
    
    @ViewBuilder
    private var compactView: some View {
        HStack {
            AvatarView(viewModel.account?.photoURL)
        }
    }
    
    private var fullView: some View {
        Button {
            if let account = viewModel.account {
                if viewModel.isInSettings {
                    routerPath.navigate(to: .accountSettingsWithAccount(account: account, appAccount: account))
                    HapticManager.shared.fireHaptic(.buttonPress)
                } else {
                    isParentPresented = false
                    routerPath.navigate(to: .accountDetailWithAccount(account: account))
                    HapticManager.shared.fireHaptic(.buttonPress)
                }
            }


        } label: {
            HStack {
               
                ZStack(alignment: .topTrailing) {
                    AvatarView(viewModel.account?.photoURL)
                   
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white, .green)
                        .offset(x: 5, y: -5)
             
                }
               
                VStack(alignment: .leading) {
                    if let account = viewModel.account {
                       
                        Text((account.displayName ?? "@noname") )
                            .font(.scaledSubheadline)
                            .foregroundStyle(Color.secondary)
    
                        Text(account.email ?? "-")
                            .font(.scaledSubheadline)
                            .foregroundStyle(Color.secondary)
                        
                    }
                }
                
                if viewModel.isInSettings {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
