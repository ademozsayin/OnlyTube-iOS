import Combine
import Foundation
import Network
import Observation
import SwiftUI
import YouTubeKit

public enum RouterDestination: Hashable {
   
    case mutedAccounts
    case channelDetails(channel: YTLittleChannelInfos)
    case playlistDetails(playlist: YTPlaylist)

}

public enum WindowDestinationEditor: Hashable, Codable {
    case quoteLinkStatusEditor(link: URL)
}

public enum WindowDestinationMedia: Hashable, Codable {
    case mediaViewer
}

public enum SheetDestination: Identifiable, Hashable {
    public static func == (lhs: SheetDestination, rhs: SheetDestination) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
 
    case settings
    case about
    case miniPlayer(videoId:String?)
    case disclaimer
    
    public var id: String {
        switch self {
            case .settings, .about:
                "settings"
            case .miniPlayer:
                "miniPlayer"
            case .disclaimer:
                "disclaimer"
        }
    }
}

public enum SettingsStartingPoint {
    case display
    case haptic
    case remoteTimelines
    case tagGroups
    case recentTags
    case content
    case swipeActions
    case tabAndSidebarEntries
    case translation
}

@MainActor
@Observable public class RouterPath {

    public var urlHandler: ((URL) -> OpenURLAction.Result)?
    
    public var path: [RouterDestination] = []
    public var presentedSheet: SheetDestination?
    
    public static var settingsStartingPoint: SettingsStartingPoint? = nil
    
    public init() {}
    
    public func navigate(to: RouterDestination) {
        path.append(to)
    }
    
    private func handlerOrDefault(url: URL) {
        if let urlHandler {
            _ = urlHandler(url)
        } else {
            UIApplication.shared.open(url)
        }
    }
    
    public func handle(url: URL) -> OpenURLAction.Result {

        return urlHandler?(url) ?? .systemAction
    }
    
//    public func handleDeepLink(url: URL) -> OpenURLAction.Result {
//        let component = url.lastPathComponent
//        switch url.host {
//            case "watch":
//               
//                if case .success(let sanitizedVideoId) = ParameterValidator.videoIdValidator.handler(component),
//                   let sanitizedVideoId = sanitizedVideoId {
//                    presentedSheet = .miniPlayer(videoId: sanitizedVideoId)
//                    break
//                }
//            case "channel":
//                handlerOrDefault(url: url)
//                break
//            default:
//                handlerOrDefault(url: url)
//                break
//        }
//   
//        Task {
//            handlerOrDefault(url: url)
//            return
//        }
//        return .handled
//    }
    
    public func handleDeepLink(url: URL) -> OpenURLAction.Result {
        let component = url.lastPathComponent
        
        switch url.host {
            case "watch":
                if case .success(let sanitizedVideoId) = ParameterValidator.videoIdValidator.handler(component),
                   let sanitizedVideoId = sanitizedVideoId {
                    presentedSheet = .miniPlayer(videoId: sanitizedVideoId)
                    return .handled
                } else {
                    Task {
                        handlerOrDefault(url: url)
                    }
                    return .handled
                }
            case "channel":
                Task {
                    handlerOrDefault(url: url)
                }
                return .handled
            default:
                Task {
                    handlerOrDefault(url: url)
                }
                return .handled
        }
    }
}
