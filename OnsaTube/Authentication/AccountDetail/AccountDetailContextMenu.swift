import Env
import Network
import SwiftUI

public struct AccountDetailContextMenu: View {
    @Environment(RouterPath.self) private var routerPath
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(UserPreferences.self) private var preferences
    
    @Binding var showBlockConfirmation: Bool
    @Binding var showTranslateView: Bool
    
    var viewModel: AccountDetailViewModel
    
    public var body: some View {
        if let account = viewModel.account {
            Section(account.uid) {

                
#if canImport(_Translation_SwiftUI)
                if #available(iOS 17.4, *) {
                    Button {
                        showTranslateView = true
                    } label: {
                        Label("status.action.translate", systemImage: "captions.bubble")
                    }
                }
#endif
                
#if !targetEnvironment(macCatalyst)
                Divider()
#endif
            }
        }
    }
}
