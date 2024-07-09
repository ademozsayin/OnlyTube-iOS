import DesignSystem
import Env
import Models
import NukeUI
import SwiftUI
import FirebaseAuth

@MainActor
struct AccountDetailHeaderView: View {
    enum Constants {
        static let headerHeight: CGFloat = 300
    }
    
    @Environment(\.openWindow) private var openWindow
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(\.redactionReasons) private var reasons
    @Environment(\.isSupporter) private var isSupporter: Bool
    
    var viewModel: AccountDetailViewModel
    let account: User
    let scrollViewProxy: ScrollViewProxy?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteVideo.timestamp, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteVideo>
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .frame(height: Constants.headerHeight)
                    .overlay {
                        headerImageView
                    }

            }
            accountInfoView
        }
    }
    
    private var headerImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if reasons.contains(.placeholder) {
                Rectangle()
                    .foregroundColor(theme.secondaryBackgroundColor)
                    .frame(height: Constants.headerHeight)
                    .accessibilityHidden(true)
            } else {
                LazyImage(url: URL(string: "https://www.folklorik.com/image/icerik/fener-balat-turu_5f690084c41e0.jpg")!) { state in
                //https://www.missafir.com/blog/wp-content/uploads/2023/08/balat-fener-rum-patrikhanesi-1024x767.jpg
               // https://idsb.tmgrup.com.tr/ly/uploads/images/2021/11/26/162584.jpg
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(account.photoURL?.lastPathComponent.count == 0 ? .black.opacity(0.50) : .clear)
                            .frame(height: Constants.headerHeight)
                            .clipped()
                    } else {
                        theme.secondaryBackgroundColor
                            .frame(height: Constants.headerHeight)
                    }
                }
                .frame(height: Constants.headerHeight)
            }
        }
#if !os(visionOS)
        .background(theme.secondaryBackgroundColor)
#endif
        .frame(height: Constants.headerHeight)
 
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits([.isImage, .isButton])
        .accessibilityLabel("accessibility.tabs.profile.header-image.label")
        .accessibilityHint("accessibility.tabs.profile.header-image.hint")
    }
    
    private var accountAvatarView: some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                AvatarView(account.photoURL, config: .account)
                    .accessibilityLabel("accessibility.tabs.profile.user-avatar.label")
                if viewModel.isCurrentUser, isSupporter {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(theme.tintColor)
                        .offset(x: theme.avatarShape == .circle ? 0 : 10,
                                y: theme.avatarShape == .circle ? 0 : -10)
                        .accessibilityRemoveTraits(.isSelected)
                        .accessibilityLabel("accessibility.tabs.profile.user-avatar.supporter.label")
                }
            }

            .accessibilityElement(children: .combine)
            .accessibilityAddTraits([.isImage, .isButton])
            .accessibilityHint("accessibility.tabs.profile.user-avatar.hint")
            
            Spacer()
            Group {
                Button {
                    withAnimation {
                        scrollViewProxy?.scrollTo("status", anchor: .top)
                    }
                } label: {
                    makeCustomInfoLabel(title: "Favorites", count:  favorites.count)
                }
                .accessibilityHint("accessibility.tabs.profile.post-count.hint")
                .buttonStyle(.borderless)
                
            
                .accessibilityHint("accessibility.tabs.profile.following-count.hint")
                .buttonStyle(.borderless)
          
                .accessibilityHint("accessibility.tabs.profile.follower-count.hint")
                .buttonStyle(.borderless)
                
            }.offset(y: 20)
        }
    }
    
    private var accountInfoView: some View {
        Group {
            accountAvatarView
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 2) {
                        Text(account.email ?? "no name")
                            .font(.scaledHeadline)
                            .foregroundColor(theme.labelColor)
                            .accessibilityAddTraits(.isHeader)
                        
                        
                    }
                    Text("@\(account.displayName ?? "")")
                        .font(.scaledCallout)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                        .accessibilityRespondsToUserInteraction(false)
//                    movedToView
//                    joinedAtView
                }
                .accessibilityElement(children: .contain)
                .accessibilitySortPriority(1)
                
                Spacer()
      
            }
//           fieldsView
        }
        .padding(.horizontal, .layoutPadding)
        .offset(y: -40)
    }
    
    private func getLocalizedStringLabel(langCode: String, provider: String) -> String {
        if let localizedLanguage = Locale.current.localizedString(forLanguageCode: langCode) {
            let format = NSLocalizedString("status.action.translated-label-from-%@-%@", comment: "")
            return String.localizedStringWithFormat(format, localizedLanguage, provider)
        } else {
            return "status.action.translated-label-\(provider)"
        }
    }
    
    private func makeCustomInfoLabel(title: LocalizedStringKey, count: Int, needsBadge: Bool = false) -> some View {
        VStack {
            Text(count, format: .number.notation(.compactName))
                .font(.scaledHeadline)
                .foregroundColor(theme.tintColor)
                .overlay(alignment: .trailing) {
                    if needsBadge {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 9, height: 9)
                            .offset(x: 12)
                    }
                }
            Text(title)
                .font(.scaledFootnote)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue("\(count)")
    }
    
   
    
  
   
}

/// A ``ViewModifier`` that creates a attaches an accessibility action if the field value is a valid link
//private struct ConditionalUserDefinedFieldAccessibilityActionModifier: ViewModifier {
//    let field: Account.Field
//    let routerPath: RouterPath
//    
//    func body(content: Content) -> some View {
//        if let url = URL(string: field.value.asRawText), UIApplication.shared.canOpenURL(url) {
//            content
//                .accessibilityAction {
//                    let _ = routerPath.handle(url: url)
//                }
//            // SwiftUI will automatically decorate this element with the link trait, so we remove the button trait manually.
//            // March 18th, 2023: The button trait is still re-applied…
//                .accessibilityRemoveTraits(.isButton)
//                .accessibilityInputLabels([field.name])
//        } else {
//            content
//            // This element is not interactive; setting this property removes its button trait
//                .accessibilityRespondsToUserInteraction(false)
//        }
//    }
//}

