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
                showBadge: Bool = false
    ) {
        self.appAccount = appAccount
        self.isCompact = isCompact
        self.isInSettings = isInSettings
        self.showBadge = showBadge

    }
    
    func fetchAccount() async {
        do {
            account = Self.accountsCache[appAccount?.uid ?? ""]
            
            account = AuthenticationManager.shared.currentAccount
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
