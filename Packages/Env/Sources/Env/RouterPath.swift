import Combine
import Foundation
import Network
import Observation
import SwiftUI
//import YouTubeKit

public enum RouterDestination: Hashable {
   
    case mutedAccounts
//    case usersPlaylists(playlists: [YTPlaylist])
//    case playlistDetails(playlist: YTPlaylist)
}

public enum WindowDestinationEditor: Hashable, Codable {
    case quoteLinkStatusEditor(link: URL)
}

public enum WindowDestinationMedia: Hashable, Codable {
//    case mediaViewer(attachments: [MediaAttachment], selectedAttachment: MediaAttachment)
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
    case miniPlayer
 
    
    public var id: String {
        switch self {
            case .settings, .about:
                "settings"
            case .miniPlayer:
                "miniPlayer"
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
//    public var client: Client?
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
    
    
}
