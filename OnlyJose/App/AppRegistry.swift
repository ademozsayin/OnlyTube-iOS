//
//  AppRegistry.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 9.06.2024.
//

import DesignSystem
import Env
import LinkPresentation
import SwiftUI

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
                case .usersPlaylists(let playlists):
                    UsersPlaylistsListView(playlists: playlists)
                case .mutedAccounts:
//                    AccountsListView(mode: .muted)
                    Text("AccountsListView")
                case .playlistDetails(playlist: let playlist):
                    Text("playlistDetails")
            }
        }
    }
    
    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            switch destination {
            
                case .settings:
                    SettingsTabs(popToRootTab: .constant(.settings), isModal: true)
                        .withEnvironments()
                        .preferredColorScheme(Theme.shared.selectedScheme == .dark ? .dark : .light)
                
                case .about:
                    NavigationSheet {
//                        AboutView()
                        Text("AboutView")
                    }
                        .withEnvironments()
                case .miniPlayer:
//                    NavigationSheet {
                        WatchVideoView()
                            .withEnvironments()
                            .presentationDragIndicator(.hidden)

//                    }
                   
                
            }
        }
    }
    
    func withEnvironments() -> some View {
//        environment(CurrentAccount.shared)
            environment(UserPreferences.shared)
            .environment(Theme.shared)
        
    }
    
    func withModelContainer() -> some View {
        modelContainer(for: [
//            Draft.self,
        ])
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let image: UIImage
//    let status: Status
    
    class LinkDelegate: NSObject, UIActivityItemSource {
        let image: UIImage
//        let status: Status
        
//        init(image: UIImage, status: Status) {
        init(image: UIImage) {
            self.image = image
//            self.status = status
        }
        
        func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
            let imageProvider = NSItemProvider(object: image)
            let metadata = LPLinkMetadata()
            metadata.imageProvider = imageProvider
//            metadata.title = status.reblog?.content.asRawText ?? status.content.asRawText
            return metadata
        }
        
        func activityViewControllerPlaceholderItem(_: UIActivityViewController) -> Any {
            image
        }
        
        func activityViewController(_: UIActivityViewController,
                                    itemForActivityType _: UIActivity.ActivityType?) -> Any?
        {
            nil
        }
    }
    
    func makeUIViewController(context _: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        UIActivityViewController(
//            activityItems: [image, LinkDelegate(image: image, status: status)],
            activityItems: [image, LinkDelegate(image: image)],
            applicationActivities: nil)
    }
    
    func updateUIViewController(_: UIActivityViewController, context _: UIViewControllerRepresentableContext<ActivityView>) {}
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}
