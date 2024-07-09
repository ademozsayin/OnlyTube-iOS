//
//  AccountDetailView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 8.07.2024.
//

import SwiftUI
import Env
import DesignSystem
import FirebaseAuth

@MainActor
struct AccountDetailView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(\.redactionReasons) private var reasons
    @Environment(\.openWindow) private var openWindow
    
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath
   
    @State private var viewModel: AccountDetailViewModel
    @State private var isCurrentUser: Bool = false
    @State private var showBlockConfirmation: Bool = false
    @State private var isEditingRelationshipNote: Bool = false
    @State private var showTranslateView: Bool = false
    
    @State private var displayTitle: Bool = false
    
    @Binding var scrollToTopSignal: Int
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteVideo.timestamp, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteVideo>
    
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var NM = NetworkReachabilityModel.shared
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    
    /// When coming from a URL like a mention tap in a status.
    public init(accountId: String, scrollToTopSignal: Binding<Int>) {
        _viewModel = .init(initialValue: .init(accountId: accountId))
        _scrollToTopSignal = scrollToTopSignal
    }
    
    /// When the account is already fetched by the parent caller.
    public init(account: User, scrollToTopSignal: Binding<Int>) {
        _viewModel = .init(initialValue: .init(account: account))
        _scrollToTopSignal = scrollToTopSignal
    }
    
    @State private var search: String = ""

    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                List {
                    ScrollToView()
                        .onAppear { displayTitle = false }
                        .onDisappear { displayTitle = true }
                    makeHeaderView(proxy: proxy)
                        .applyAccountDetailsRowStyle(theme: theme)
                        .padding(.bottom, -20)
                    
//                    Picker("", selection: $viewModel.selectedTab) {
//                        ForEach(isCurrentUser ? AccountDetailViewModel.Tab.currentAccountTabs : AccountDetailViewModel.Tab.accountTabs,
//                                id: \.self)
//                        { tab in
//                            if tab == .boosts {
//                                Image("Rocket")
//                                    .tag(tab)
//                                    .accessibilityLabel(tab.accessibilityLabel)
//                            } else {
//                                Image(systemName: tab.iconName)
//                                    .tag(tab)
//                                    .accessibilityLabel(tab.accessibilityLabel)
//                            }
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .padding(.layoutPadding)
//                    .applyAccountDetailsRowStyle(theme: theme)
//                    .id("status")
                    
//                    LazyVStack {
                        let propertyState = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes
                        let videoViewHeight = propertyState == .halfThumbnail ? 180 : geometry.size.width * 9/16 + 90
                        
                        ForEach(sortedVideos) { (video: FavoriteVideo) in
                            let convertedResult = video.toYTVideo()
                            
                            Button {
                                if VideoPlayerModel.shared.currentItem?.videoId != video.videoId {
                                    VideoPlayerModel.shared.loadVideo(video: convertedResult)
                                }
                                
                                SheetsModel.shared.showSheet(.watchVideo)
                            } label: {
                                VideoFromSearchView(videoWithData: convertedResult.withData(.init(channelAvatarData: video.channel?.thumbnail, thumbnailData: video.thumbnailData)))
                                    .frame(width: geometry.size.width, height: videoViewHeight, alignment: .center)
                            }
                            .listRowSeparator(.hidden)
                        }
//                        Color.clear
//                            .frame(height: 30)
//                    }
                    
                }
                .environment(\.defaultMinListRowHeight, 0)
                .listStyle(.plain)
//#if !os(visionOS)
                .scrollContentBackground(.hidden)
                .background(theme.primaryBackgroundColor)
//#endif
                .onChange(of: scrollToTopSignal) {
                    withAnimation {
                        proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
                    }
                }
            }
        }
        .onAppear {
            guard reasons != .placeholder else { return }
            isCurrentUser = authenticationManager.currentAccount?.uid == viewModel.accountId
            viewModel.isCurrentUser = isCurrentUser
            
            // Avoid capturing non-Sendable `self` just to access the view model.
            let viewModel = viewModel
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await viewModel.fetchAccount() }
                }
            }
        }
        .refreshable {
            Task {
                SoundEffectManager.shared.playSound(.pull)
                HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
                await viewModel.fetchAccount()
//                await viewModel.fetchNewestStatuses(pullToRefresh: true)
                HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
                SoundEffectManager.shared.playSound(.refresh)
            }
        }
        .onChange(of: routerPath.presentedSheet) { oldValue, newValue in
            if oldValue == .accountEditInfo || newValue == .accountEditInfo {
                Task {
                    await viewModel.fetchAccount()
//                    await preferences.refreshServerPreferences()
                }
            }
        }
        .sheet(isPresented: $isEditingRelationshipNote, content: {
//            EditRelationshipNoteView(accountDetailViewModel: viewModel)
        })
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContent
        }
        .withCoreDataContext()
    }
    
    @ViewBuilder
    private func makeHeaderView(proxy: ScrollViewProxy?) -> some View {
        switch viewModel.accountState {
            case .loading:
                LoadingView()
            case let .data(account):
                AccountDetailHeaderView(viewModel: viewModel,
                                        account: account,
                                        scrollViewProxy: proxy)
            case let .error(error):
                Text("Error: \(error.localizedDescription)")
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            if let account = viewModel.account, displayTitle {
                VStack {
                    Text(account.displayName ?? "Profile").font(.headline)
//                    Text("Favorites \(favorites.count)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        ToolbarItemGroup(placement: .navigationBarTrailing) {

            
            Menu {
                AccountDetailContextMenu(showBlockConfirmation: $showBlockConfirmation,
                                         showTranslateView: $showTranslateView,
                                         viewModel: viewModel)
                
                if !viewModel.isCurrentUser {
                    Button {
                        isEditingRelationshipNote = true
                    } label: {
                        Label("account.relation.note.edit", systemImage: "pencil")
                    }
                }
                
                if isCurrentUser {
                    Button {
                        routerPath.presentedSheet = .accountEditInfo
                    } label: {
                        Label("account.action.edit-info", systemImage: "pencil")
                    }
                   
                    Button {
                        routerPath.presentedSheet = .accountPushNotficationsSettings
                    } label: {
                        Label("settings.push.navigation-title", systemImage: "bell")
                    }
            
                    
                    Button {
                        routerPath.presentedSheet = .settings
                    } label: {
                        Label("settings.title", systemImage: "gear")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .accessibilityLabel("accessibility.tabs.profile.options.label")
                    .accessibilityInputLabels([
                        LocalizedStringKey("accessibility.tabs.profile.options.label"),
                        LocalizedStringKey("accessibility.tabs.profile.options.inputLabel1"),
                        LocalizedStringKey("accessibility.tabs.profile.options.inputLabel2"),
                    ])
            }
        }
    }
    
    var sortedVideos: [FavoriteVideo] {
        return self.favorites
            .filter({$0.matchesQuery(search)})
            .conditionnalFilter(mainCondition: !NM.connected, {PersistenceModel.shared.isVideoDownloaded(videoId: $0.videoId) != nil})
            .sorted(by: {
                switch (self.PSM.propetriesState[.favoritesSortingMode] as? PreferencesStorageModel.Properties.SortingModes) ?? .oldest {
                    case .newest:
                        return $0.timestamp > $1.timestamp
                    case .oldest:
                        return $0.timestamp < $1.timestamp
                    case .title:
                        return ($0.title ?? "") < ($1.title ?? "")
                        //                    case .channelName:
                        //                        return ($0.channel?.name ?? "") < ($1.channel?.name ?? "")
                }
            })
    }
}

extension View {
    @MainActor
    func applyAccountDetailsRowStyle(theme: Theme) -> some View {
        listRowInsets(.init())
            .listRowSeparator(.hidden)
#if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
}
