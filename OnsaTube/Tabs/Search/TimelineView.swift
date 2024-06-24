//
//  TimelineView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

import Foundation

import Env
import SwiftUI
import InfiniteScrollViews
import YouTubeKit
#if !os(visionOS)
import SwipeActions
#endif
import DesignSystem


struct TimelineView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(UserPreferences.self) private var preferences
    
    @State private var autoCompletion: [String] = []
    @State private var search: String = "jose mourinho" {
        didSet {
            refreshAutoCompletionEntries()
        }
    }
    
    @State private var collectionView: UICollectionView?
    
    @State private var searchDemoData: String = "Erkin Arslan - The Special One (Official Audio)"
    
    @State private var autoCompletionHeaders: HeadersList?
    @State private var needToReload = true
    @State private var isShowingSettingsSheet: Bool = false
    
    @State private var firstDisplayedResult: Int = 0
    @State private var shouldReloadScrollView: Bool = false
    @State private var hasToReloadPadding: Bool = true
    @State private var isShowingPaddedFirstVideo: Bool = false
    
    @State private var model = Model.shared
    @ObservedObject private var IUTM = IsUserTypingModel.shared
    @ObservedObject private var VPM = VideoPlayerModel.shared
    //    @ObservedObject private var NPM = NavigationPathModel.shared
    @Environment(RouterPath.self) private var routerPath
    
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var NRM = NetworkReachabilityModel.shared
    //    @ObservedObject private var PSM = PreferencesStorageModel.shared
    @Environment(Theme.self) private var theme
    @State private var isFetching: Bool = false
    @State private var libraryContent: AccountLibraryResponse?
    
    @State private var playlists: [YTPlaylist] = []
    
    @Binding var scrollToTopSignal: Int
    
    @State private var viewModel = SearchViewModel()
    
    
    public init(scrollToTopSignal: Binding<Int>) {
        _scrollToTopSignal = scrollToTopSignal
    }
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .top) {
                List {
                    scrollToTopView
                    
                    }
                }
            .environment(\.defaultMinListRowHeight, 1)
            .listStyle(.plain)
            #if !os(visionOS)
            .scrollContentBackground(.hidden)
            .background(theme.primaryBackgroundColor)
            #endif
            .onChange(of: scrollToTopSignal) {
                withAnimation {
                    proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .environment(routerPath)
        }
        .toolbar {
            toolbarTitleView
//            toolbarTagGroupButton
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarTitleView: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(alignment: .center) {
                Menu("Menu") {}
                .font(.headline)
            }
            .accessibilityAddTraits(.isHeader)
            .accessibilityRemoveTraits(.isButton)
            .accessibilityRespondsToUserInteraction(true)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarTagGroupButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            EmptyView()
        }
    }
    
    func refreshAutoCompletionEntries() {
        Task {
            let result = try? await AutoCompletionResponse.sendThrowingRequest(youtubeModel: YTM, data: [.query: self.search])
            DispatchQueue.main.async {
                self.autoCompletion = result?.autoCompletionEntries ?? []
            }
        }
    }
    
    private var scrollToTopView: some View {
        ScrollToView()
        //      .frame(height: pinnedFilters.isEmpty ? .layoutPadding : 0)
            .frame(height: .layoutPadding )
            .onAppear {
                viewModel.scrollToTopVisible = true
            }
            .onDisappear {
                viewModel.scrollToTopVisible = false
            }
    }
}



