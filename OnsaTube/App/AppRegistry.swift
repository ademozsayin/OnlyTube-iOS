//
//  AppRegistry.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 9.06.2024.
//

import DesignSystem
import Env
import LinkPresentation
import SwiftUI
import Models
import SwiftData

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {

                case .mutedAccounts:
                    Text("AccountsListView")
                case .channelDetails(channel: let channel):
                    ChannelDetailsView(channel: channel)
                case .playlistDetails(let playlist):
                    PlaylistDetailsView(playlist: playlist)
                    
                case .register:
                    RegisterView()
                case .accountSettingsWithAccount(account: let account, appAccount: let appAccount):
                    AccountSettingsView(account: account, appAccount: appAccount)
                case .accountDetailWithAccount(let account):
                    AccountSettingsView(account: account, appAccount: account)

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
                    NavigationSheet { AboutView() }
                        .withEnvironments()
                    
                case .miniPlayer(let videoId):
//                    NavigationSheet {
                    WatchVideoView(videoId: videoId)
                            .withEnvironments()
                            .presentationDragIndicator(.hidden)

//                    }
                   
                case .disclaimer:
                    DisclaimerView()
                    
                case .login:
                    LoginView(siteUrl: "asdasd")
                        .withEnvironments()
                    
                case .loggingIn(let url):
                    LogInWithEmailView(url: url)
                        .withEnvironments()
  
                case .support:
                    NavigationSheet { SupportAppView() }
                        .withEnvironments()
                    
                      
                
                case .accountEditInfo:
                    EditAccountView()
                        .withEnvironments()
                    
                case .accountPushNotficationsSettings:
                    if let subscription = PushNotificationsService.shared.subscriptions.first {
                        NavigationSheet { PushNotificationsView(subscription: subscription) }
                            .withEnvironments()
                    } else {
                        EmptyView()
                    }
                    
                case .categorySelection:
                    CategorySelectionView()
//
            }
        }
    }
    
    func withEnvironments() -> some View {
//        environment(CurrentAccount.shared)
            environment(UserPreferences.shared)
            .environment(Theme.shared)
            .environment(AuthenticationManager.shared)
        
    }
    
    func withModelContainer() -> some View {
        modelContainer(for: [
            TagGroup.self,
            Draft.self
        ])
    }
    
    func withCoreDataContext() -> some View {
        environment(\.managedObjectContext, PersistenceModel.shared.context)
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
