import Env
import Models
import Network
import Observation
import SwiftUI
import FirebaseAuth

@MainActor
@Observable class AccountDetailViewModel {
    let accountId: String
    var isCurrentUser: Bool = false
    
    enum AccountState {
        case loading, data(account: User), error(error: Error)
    }
    
    enum Tab: Int {
        case statuses, favorites, bookmarks, replies, boosts, media
        
        static var currentAccountTabs: [Tab] {
            [.favorites, .bookmarks]
        }
        
        static var accountTabs: [Tab] {
            [.statuses, .replies, .boosts, .media]
        }
        
        var iconName: String {
            switch self {
                case .statuses: "bubble.right"
                case .favorites: "star"
                case .bookmarks: "bookmark"
                case .replies: "bubble.left.and.bubble.right"
                case .boosts: ""
                case .media: "photo.on.rectangle.angled"
            }
        }
        
        var accessibilityLabel: LocalizedStringKey {
            switch self {
                case .statuses: "accessibility.tabs.profile.picker.statuses"
                case .favorites: "accessibility.tabs.profile.picker.favorites"
                case .bookmarks: "accessibility.tabs.profile.picker.bookmarks"
                case .replies: "accessibility.tabs.profile.picker.posts-and-replies"
                case .boosts: "accessibility.tabs.profile.picker.boosts"
                case .media: "accessibility.tabs.profile.picker.media"
            }
        }
    }
    
    var accountState: AccountState = .loading
    

    var selectedTab = Tab.statuses {
        didSet {
            switch selectedTab {
                case .statuses, .replies, .boosts, .media:
                    tabTask?.cancel()
//                    tabTask = Task {
//                    }
                default:
                    reloadTabState()
            }
        }
    }
    
    var scrollToTopVisible: Bool = false
    
    var isLoadingTranslation = false
    
    private(set) var account: User?
    private(set) var mockUser: MockUser?
    private var tabTask: Task<Void, Never>?
    private var authenticationManager: AuthenticationManager
    
    
    /// When coming from a URL like a mention tap in a status.
    init(accountId: String) {
        self.accountId = accountId
        isCurrentUser = false
        self.authenticationManager = AuthenticationManager.shared
    }
    
    /// When the account is already fetched by the parent caller.
    init(account: User?) {
        
        accountId = account?.uid ?? ""
        self.account = account
        self.authenticationManager = AuthenticationManager.shared
        guard let account else { return }
        accountState = .data(account: account)

    }
    
    init(mockUser: MockUser?) {
        
        accountId = mockUser?.uid ?? ""
        self.mockUser = mockUser
        self.authenticationManager = AuthenticationManager.shared
        guard let account else { return }
        accountState = .data(account: account)
        
    }
    
    struct AccountData {
        let account: User
    }
    
    func fetchAccount() async {
       
        do {
            guard let data =  await authenticationManager.fetchAccount() else { return }
            accountState = .data(account: data)
            
            account = data
           
        } catch let error {
            if let account {
                accountState = .data(account: account)
            } else {
                accountState = .error(error: error)
            }
        }
    }
    
    private func reloadTabState() {
       
    }
    
}

extension AccountDetailView {
    static let user = MockUser.sample
}

protocol Authable {
    var uid: String? { get set }
    var email: String? { get set }
    var displayName: String? { get set }
}

struct MockUser: Authable {
    var uid: String?
    var email: String?
    var displayName: String?
}

extension MockUser {
    static var sample: MockUser {
        return MockUser(uid: "123456", email: "test@example.com", displayName: "Test User")
    }
}
