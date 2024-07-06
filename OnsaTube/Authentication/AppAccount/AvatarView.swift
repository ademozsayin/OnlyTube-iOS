import Models
import Nuke
import NukeUI
import SwiftUI
import DesignSystem

@MainActor
public struct AvatarView: View {
    @Environment(Theme.self) private var theme
    
    public let avatar: URL?
    public let config: FrameConfig
    
    public var body: some View {
        if let avatar {
            AvatarImage(avatar, config: adaptiveConfig)
                .frame(width: config.width, height: config.height)
        } else {
            AvatarPlaceHolder(config: adaptiveConfig)
        }
    }
    
    private var adaptiveConfig: FrameConfig {
        let cornerRadius: CGFloat = if config == .badge || theme.avatarShape == .circle {
            config.width / 2
        } else {
            config.cornerRadius
        }
        return FrameConfig(width: config.width, height: config.height, cornerRadius: cornerRadius)
    }
    
    public init(_ avatar: URL? = nil, config: FrameConfig = .status) {
        self.avatar = avatar
        self.config = config
    }
    
    @MainActor
    public struct FrameConfig: Equatable, Sendable {
        public let size: CGSize
        public var width: CGFloat { size.width }
        public var height: CGFloat { size.height }
        let cornerRadius: CGFloat
        
        init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 4) {
            size = CGSize(width: width, height: height)
            self.cornerRadius = cornerRadius
        }
        
        public static let account = FrameConfig(width: 80, height: 80)
#if targetEnvironment(macCatalyst)
        public static let status = FrameConfig(width: 48, height: 48)
#else
        public static let status = FrameConfig(width: 40, height: 40)
#endif
        public static let embed = FrameConfig(width: 34, height: 34)
        public static let badge = FrameConfig(width: 28, height: 28, cornerRadius: 14)
        public static let list = FrameConfig(width: 20, height: 20, cornerRadius: 10)
        public static let boost = FrameConfig(width: 12, height: 12, cornerRadius: 6)
    }
}


struct AvatarImage: View {
    @Environment(\.redactionReasons) private var reasons
    
    public let avatar: URL
    public let config: AvatarView.FrameConfig
    
    var body: some View {
        if reasons == .placeholder {
            AvatarPlaceHolder(config: config)
        } else {
            LazyImage(request: ImageRequest(url: avatar, processors: [.resize(size: config.size)])
            ) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: config.cornerRadius)
                                .stroke(.primary.opacity(0.25), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .stroke(.primary.opacity(0.25), lineWidth: 1)
                }
            }
        }
    }
    
    init(_ avatar: URL, config: AvatarView.FrameConfig) {
        self.avatar = avatar
        self.config = config
    }
}

struct AvatarPlaceHolder: View {
    let config: AvatarView.FrameConfig
    
    var body: some View {
        RoundedRectangle(cornerRadius: config.cornerRadius)
            .fill(.gray)
            .frame(width: config.width, height: config.height)

    }
}

