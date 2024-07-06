import Combine
import UIKit
import FirebaseAuth

@MainActor 
@Observable final class LoginViewModel {
    private var siteURL: String = ""
    var titleString: String = ""
    var subtitleString: String = ""
    var emailAddress: String = ""
    var password: String = ""
    
    let termsAttributedString: NSAttributedString?
   
    var primaryButtonDisabled: Bool {
        return emailAddress.isEmpty || password.isEmpty || isLoggingIn
    }
    
    private(set) var isLoggingIn = false
    private(set) var errorMessage = ""
    var shouldShowErrorAlert = false
    
    private let accountService = AuthenticationManager.shared
    var onError: String?
    private var emailFieldSubscription: AnyCancellable?
    
    
    public init(siteUrl: String) {
        
        self.titleString = Localization.installJetpack
        self.subtitleString = Localization.loginToInstall
        self.siteURL = siteUrl
        self.emailAddress = ""
        
        self.termsAttributedString = LoginViewModel.createTermsAttributedString(siteURL: siteUrl)

    }
    
    private static func createTermsAttributedString(siteURL: String) -> NSAttributedString {
        let content = String.localizedStringWithFormat(Localization.termsContent, Localization.termsOfService, Localization.shareDetails)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let mutableAttributedText = NSMutableAttributedString(
            string: content,
            attributes: [.font: UIFont.footnote,
                         .foregroundColor: UIColor.secondaryLabel,
                         .paragraphStyle: paragraph]
        )
        
        mutableAttributedText.setAsLink(textToFind: Localization.termsOfService,
                                        linkURL: Constants.jetpackTermsURL + siteURL)
        mutableAttributedText.setAsLink(textToFind: Localization.shareDetails,
                                        linkURL: Constants.jetpackShareDetailsURL + siteURL)
        return mutableAttributedText
    }
    
    @MainActor
    func login() async  {
        do {
            isLoggingIn = true
            try await Auth.auth().signIn(withEmail: emailAddress, password: password)
        } catch let err {
            errorMessage = err.localizedDescription
            shouldShowErrorAlert = true
            isLoggingIn = false
        }
    }
}

extension LoginViewModel {
    private enum Constants {
        static let fieldDebounceDuration = 0.3
        static let jetpackTermsURL = "https://jetpack.com/redirect/?source=wpcom-tos&site="
        static let jetpackShareDetailsURL = "https://jetpack.com/redirect/?source=jetpack-support-what-data-does-jetpack-sync&site="
        static let wpcomErrorCodeKey = "WordPressComRestApiErrorCodeKey"
    }
    
    enum Localization {
        static let installJetpack = NSLocalizedString(
            "Login",
            comment: "Title for the WPCom email login screen when Jetpack is not installed yet"
        )
        static let loginToInstall = NSLocalizedString(
            "We will send instructions to your email address. Check your e-mail.",
            comment: ""
        )
        static let connectJetpack = NSLocalizedString(
            "Connect Jetpack",
            comment: ""
        )
        static let loginToConnect = NSLocalizedString(
            "Log in with your WordPress.com account to connect Jetpack",
            comment: "Subtitle for the WPCom email login screen when Jetpack is not connected yet"
        )
        static let termsContent = NSLocalizedString(
            "By tapping the Log in button, you agree to our %1$@ and to %2$@.",
            comment: "Content of the label at the end of the Wrong Account screen. " +
            "Reads like: By tapping the Connect Jetpack button, you agree to our Terms of Service and to share details with WordPress.com.")
        static let termsOfService = NSLocalizedString(
            "Terms of Service",
            comment: "The terms to be agreed upon when tapping the Connect Jetpack button on the Wrong Account screen."
        )
        static let shareDetails = NSLocalizedString(
            "share details",
            comment: "The action to be agreed upon when tapping the Connect Jetpack button on the Wrong Account screen."
        )
    }
}

///
extension UIFont {
    static var largeTitle: UIFont {
        return .preferredFont(forTextStyle: .largeTitle)
    }
    
    static var title1: UIFont {
        return .preferredFont(forTextStyle: .title1)
    }
    
    static var title2: UIFont {
        return .preferredFont(forTextStyle: .title2)
    }
    
    
    static var title3: UIFont {
        return .preferredFont(forTextStyle: .title3)
    }

    static var headline: UIFont {
        return .preferredFont(forTextStyle: .headline)
    }
    
    static var subheadline: UIFont {
        return .preferredFont(forTextStyle: .subheadline)
    }
    
    static var body: UIFont {
        return .preferredFont(forTextStyle: .body)
    }
    
    static var callout: UIFont {
        return .preferredFont(forTextStyle: .callout)
    }
    
    static var footnote: UIFont {
        return .preferredFont(forTextStyle: .footnote)
    }
    
    static var caption1: UIFont {
        return .preferredFont(forTextStyle: .caption1)
    }
    
    static var caption2: UIFont {
        return .preferredFont(forTextStyle: .caption2)
    }
}


/// NSMutableAttributedString: Helper Methods
///
extension NSMutableAttributedString {
    
    /// Replaces the first found occurrence of `target` with the `replacement`.
    ///
    /// Example usage:
    ///
    /// ```
    /// let attributedString = NSMutableAttributedString(string: "Hello, #{person}")
    /// let replacement = NSAttributedString(string: "Slim Shady",
    ///                                      attributes: [.font: UIFont.boldSystemFont(ofSize: 32)])
    /// attributedString.replaceFirstOccurrence(of: "#{person}", with: replacement)
    /// ```
    ///
    func replaceFirstOccurrence(of target: String, with replacement: NSAttributedString) {
        guard let range = string.range(of: target) else {
            return
        }
        let nsRange = NSRange(range, in: string)
        
        replaceCharacters(in: nsRange, with: replacement)
    }
    
    /// Sets a link to a substring in an attributed string.
    ///
    @discardableResult
    func setAsLink(textToFind: String, linkURL: String) -> Bool {
        let foundRange = mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
    
    /// Underlines the given substring (case insensitive). It does nothing if the given substring cannot be found in the original string.
    ///
    func underlineSubstring(underlinedText: String) {
        let range = (string as NSString).range(of: underlinedText, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(.underlineStyle,
                         value: NSUnderlineStyle.single.rawValue,
                         range: range)
        }
        
    }
    
    /// Highlight the given substring (case insensitive). It does nothing if the given substring cannot be found in the original string.
    ///
    func highlightSubstring(textToFind: String, with color: UIColor = .purple) {
        let range = mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(.foregroundColor,
                         value: color.cgColor,
                         range: range)
        }
    }
}
