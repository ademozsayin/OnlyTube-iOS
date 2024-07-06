import Combine
import DesignSystem
import Models
import Network
import Observation
import SwiftUI
import FirebaseAuth

@MainActor
@Observable public class AppAccountViewModel {
    private static var avatarsCache: [String: UIImage] = [:]
    private static var accountsCache: [String: User] = [:]
    
    private var authenticationManager: AuthenticationManager

    var appAccount: User?
    let isCompact: Bool
    let isInSettings: Bool
    let showBadge: Bool
    
    var account: User? 
//    {
//        didSet {
//            if let account {
//                refreshAcct(account: account)
//            }
//        }
//    }
//    
    var acct: String {
        if let acct = appAccount?.email {
            acct
        } else {
            "@\(account?.displayName ?? "...")"
        }
    }
    
    public init(appAccount: User?,
                isCompact: Bool = false,
                isInSettings: Bool = true,
                showBadge: Bool = false,
                authenticationManager: AuthenticationManager
    ) {
        self.appAccount = appAccount
        self.isCompact = isCompact
        self.isInSettings = isInSettings
        self.showBadge = showBadge
        self.authenticationManager = authenticationManager

    }
    
    func fetchAccount() async {
        do {
            account = Self.accountsCache[appAccount?.uid ?? ""]
            
            account = authenticationManager.currentAccount
            Self.accountsCache[appAccount?.uid ?? ""] = account
        } catch {}
    }
    
    private func refreshAcct(account: User) {
//        do {
//            if appAccount.displayName == nil {
//                appAccount.accountName = "\(account.acct)@\(appAccount.server)"
//                try appAccount.save()
//            }
//        } catch {}
    }
}
