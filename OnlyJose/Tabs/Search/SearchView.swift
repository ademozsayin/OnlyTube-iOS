//
//  SearchView.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 10.06.2024.
//

//
//  SearchView.swift
//  Atwy
//
//  Created by Antoine Bollengier on 24.11.22.
//
import Env
import SwiftUI
import InfiniteScrollViews
import YouTubeKit
import SwipeActions
import DesignSystem

let YTM = YouTubeModel()

struct SearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismissSearch) private var dismissSearch
    @State private var autoCompletion: [String] = []
    @State private var search: String = "jose mourinho" {
        
        didSet {
            refreshAutoCompletionEntries()
        }
    }
    
    @State private var searchDemoData: String = "Erkin Arslan - The Special One (Official Audio)"
        
    @State private var autoCompletionHeaders: HeadersList?
    @State private var needToReload = true
    @State private var isShowingSettingsSheet: Bool = false
    
    @State private var firstDisplayedResult: Int = 0
    @State private var shouldReloadScrollView: Bool = false
    @State private var hasToReloadPadding: Bool = true
    @State private var isShowingPaddedFirstVideo: Bool = false
    
    @ObservedObject private var model = Model.shared
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
    
    public init(scrollToTopSignal: Binding<Int>) {
        _scrollToTopSignal = scrollToTopSignal
    }
    
    
    var body: some View {
        
        ZStack{
            GeometryReader { geometry in
                Image("bg")
                    .resizable()
//                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    VStack {
                        if model.isFetching {
                            LoadingView()
                        } else if let error = model.error {
                            VStack (alignment: .center) {
                                Spacer()
                                Image(systemName: "multiply.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.red)
                                Text(error)
                                    .foregroundColor(.red)
                                Button {
                                    search = ""
                                    dismissSearch()
                                    model.getVideos(demo: false)
                                } label: {
                                    Text("Go home")
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                            }
                        } else if model.items.isEmpty && model.error == nil {
                            GeometryReader { geometry in
                                ScrollView {
                                    VStack {
                                        Text("No videos found...")
                                            .foregroundColor(theme.labelColor)
                                        Text("Search videos or pull up to refresh for the algorithm to fill this menu.")
                                            .foregroundStyle(.gray)
                                            .font(.caption)
                                    }
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                }
                                .scrollIndicators(.hidden)
                                .refreshable(action: {
                                    if search.isEmpty {
                                        model.getVideos(demo: false)
                                    } else {
                                        model.getVideos(search, demo: false)
                                    }
                                })
                            }
                        } else {
                            let itemsBinding = Binding(get: {
                                return model.items.map({YTElementWithData(element: $0, data: .init())})
                            }, set: { newValue in
                                model.items = newValue.map({$0.element})
                            })
                            ElementsInfiniteScrollView(
                                items: itemsBinding,
                                shouldReloadScrollView: $shouldReloadScrollView,
                                refreshAction: { endAction in
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        endAction()
                                        if search.isEmpty {
                                            model.getVideos(demo: false)
                                        } else {
                                            model.getVideos(search, demo: false)
                                        }
                                    }
                                },
                                fetchMoreResultsAction: {
                                    if !model.isFetchingContination {
                                        model.getVideosContinuation({
                                            self.shouldReloadScrollView = true
                                        })
                                    }
                                }
                            )
                        }
                    }
                
                .task {
//                    if self.playlists.isEmpty, !self.isFetching {
//                        getUsersPlaylists()
//                    }
                    
                    if needToReload {
                        if search.isEmpty {
                            model.getVideos(demo: false)
                        } else {
                            model.getVideos(search,demo: false)
                            
                            
                          
                            let ytVideo = YTVideo(
                                videoId: "gO70C5Q_f6Y", 
                                title: "The special One",
                                thumbnails: [YTThumbnail(url: URL(string: "https://i.ytimg.com/vi/VLFy-a-_wFI/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDhGZLAAHzUFdfBbe2Yx-wS6h3_Dg")!)]
                            )
                            VideoPlayerModel.shared.loadVideo(video: ytVideo, thumbnailData: nil, channelAvatarImageData: nil)
                            
                            
                            model.getVideos(searchDemoData, demo: true)
                            //
                        }
                        needToReload = false
                        
                        
                    }
                }
                .onAppear {
               
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.automatic)
        .environment(routerPath)
    }
    
        
        class Model: ObservableObject {
            static public let shared = Model()
            
            @Published var items: [any YTSearchResult] = []
            @Published var isFetching: Bool = false
            @Published var isFetchingContination: Bool = false
            @Published var error: String?
            
            private var homeResponse: HomeScreenResponse?
            private var searchResponse: SearchResponse?
            private var demoSearchResponse: SearchResponse? {
                didSet {
                    VideoPlayerModel.shared.sampleVideo = demoSearchResponse?.results.first as! YTVideo
                }
            }
            
            public func getVideos(_ search: String? = nil, _ end: (() -> Void)? = nil, demo: Bool) {
                if !isFetching, !isFetchingContination {
                    if let search = search {
                        getVideosForSearch(search, end, demo: demo)
                    } else {
                        getHomeVideos(end)
                    }
                }
            }
            
            public func getVideosContinuation(_ end: (() -> Void)? = nil) {
                if !isFetching, !isFetchingContination {
                    if homeResponse != nil {
                        getHomeVideosContinuation(end)
                    } else {
                        getSearchVideosContinuation(end)
                    }
                }
            }
            
            private func getHomeVideos(_ end: (() -> Void)?) {
                self.homeResponse = nil
                self.searchResponse = nil
                DispatchQueue.main.async {
                    self.isFetching = true
                    self.error = nil
                }
                
                
                HomeScreenResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [:], result: { result in
                    switch result {
                        case .success(let response):
                            self.homeResponse = response
                            DispatchQueue.main.async {
                                self.items = response.results
                                self.isFetching = false
                                end?()
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.error = error.localizedDescription
                                self.isFetching = false
                                self.items = []
                                end?()
                            }
                    }
                })
            }
            
            func fetchVideoList(item: YTPlaylist) async -> PlaylistInfosResponse? {
                let params: [HeadersList.AddQueryInfo.ContentTypes : String] = [
                    .browseId: item.playlistId
                ]
                
                do {
                    let response = try await PlaylistInfosResponse.sendThrowingRequest(youtubeModel: YTM, data: params)
                    return response
                } catch {
                    print(error)
                    return nil
                }
            }
            
            private func getHomeVideosContinuation(_ end: (() -> Void)?) {
                if let homeResponse = homeResponse, let continuationToken = homeResponse.continuationToken, let visitorData = homeResponse.visitorData {
                    DispatchQueue.main.async {
                        self.isFetchingContination = true
                    }
                    
                    HomeScreenResponse.Continuation.sendNonThrowingRequest(youtubeModel: YTM, data: [.continuation: continuationToken, .visitorData: visitorData], result: { result in
                        switch result {
                            case .success(let response):
                                self.homeResponse?.mergeContinuation(response)
                                DispatchQueue.main.async {
                                    if let results = self.homeResponse?.results {
                                        self.items = results
                                        self.isFetchingContination = false
                                    }
                                    end?()
                                }
                            case .failure(let error):
                                print("Couldn't fetch home screen continuation: \(String(describing: error))")
                                DispatchQueue.main.async {
                                    end?()
                                }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        end?()
                    }
                }
            }
            
            private func getVideosForSearch(_ search: String, _ end: (() -> Void)? ,demo: Bool = false) {
                self.homeResponse = nil
                self.searchResponse = nil
                DispatchQueue.main.async {
                    self.isFetching = true
                    self.error = nil
                }
                SearchResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.query: search], result: { result in
                    switch result {
                        case .success(let response):
                            self.searchResponse = response
                            DispatchQueue.main.async {
                                self.items = response.results
                                self.isFetching = false
                               
                                if demo {
                                    self.demoSearchResponse = response
                                }
                                end?()
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.error = error.localizedDescription
                                self.isFetching = false
                                self.items = []
                                end?()
                            }
                    }
                })
            }
            
            private func getSearchVideosContinuation(_ end: (() -> Void)?) {
                if let searchResponse = searchResponse, let continuationToken = searchResponse.continuationToken, let visitorData = searchResponse.visitorData {
                    DispatchQueue.main.async {
                        self.isFetchingContination = true
                    }
                    
                    SearchResponse.Continuation.sendNonThrowingRequest(youtubeModel: YTM, data: [.continuation: continuationToken, .visitorData: visitorData], result: { result in
                        switch result {
                            case .success(let response):
                                self.searchResponse?.mergeContinuation(response)
                                DispatchQueue.main.async {
                                    if let results = self.searchResponse?.results {
                                        self.items = results
                                        self.isFetchingContination = false
                                    }
                                    end?()
                                }
                            case .failure(let error):
                                print("Couldn't fetch search screen continuation: \(String(describing: error))")
                                DispatchQueue.main.async {
                                    end?()
                                }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        end?()
                    }
                }
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
    }
    
    
    
    struct LoadingView: View {
        var customText: String? = nil
        var body: some View {
            VStack {
                ProgressView()
                    .foregroundColor(.gray)
                    .padding(.bottom, 0.3)
                Text("LOADING" + ((customText == nil) ? "" : " ") + (customText?.uppercased() ?? ""))
                    .foregroundColor(.gray)
                    .font(.caption2)
            }
            .frame(width: 160, height: 50)
        }
    }
    
    
    struct ElementsInfiniteScrollView: View {
        @Binding var items: [YTElementWithData]
        @Binding var shouldReloadScrollView: Bool
        
        var fetchNewResultsAtKLast: Int = 5
        var shouldAddBottomSpacing = false
        @ObservedObject private var PSM = PreferencesStorageModel.shared
        @ObservedObject private var NRM = NetworkReachabilityModel.shared
        
        var refreshAction: ((@escaping () -> Void) -> Void)?
        var fetchMoreResultsAction: (() -> Void)?
        var body: some View {
            let performanceMode = PSM.propetriesState[.performanceMode] as? PreferencesStorageModel.Properties.PerformanceModes
            if performanceMode == .limited {
                CustomElementsInfiniteScrollView(
                    items: $items,
                    shouldReloadScrollView: $shouldReloadScrollView,
                    fetchNewResultsAtKLast: fetchNewResultsAtKLast,
                    refreshAction: refreshAction,
                    fetchMoreResultsAction: fetchMoreResultsAction
                )
            } else {
                DefaultElementsInfiniteScrollView(
                    items: $items,
                    shouldReloadScrollView: $shouldReloadScrollView,
                    fetchNewResultsAtKLast: fetchNewResultsAtKLast,
                    shouldAddBottomSpacing: shouldAddBottomSpacing,
                    refreshAction: refreshAction,
                    fetchMoreResultsAction: fetchMoreResultsAction
                )
            }
        }
    }
    
    
    struct YTElementWithData {
        var id: Int? { self.element.id }
        
        var element: any YTSearchResult
        
        var data: YTElementDataSet
    }
    
    struct YTElementDataSet: Hashable {
        static func == (lhs: YTElementDataSet, rhs: YTElementDataSet) -> Bool {
            return lhs.allowChannelLinking == rhs.allowChannelLinking && (lhs.removeFromPlaylistAvailable == nil) == (rhs.removeFromPlaylistAvailable == nil) && lhs.channelAvatarData == rhs.channelAvatarData && lhs.thumbnailData == rhs.thumbnailData
        }
        
        var allowChannelLinking: Bool = true
        
        var removeFromPlaylistAvailable: (() -> Void)? = nil
        
        var channelAvatarData: Data? = nil
        
        var thumbnailData: Data? = nil
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.allowChannelLinking)
            hasher.combine(self.removeFromPlaylistAvailable == nil)
            hasher.combine(self.channelAvatarData)
            hasher.combine(self.thumbnailData)
        }
    }
    
    
    struct YTVideoWithData: Hashable {
        
        var video: YTVideo
        
        var data: YTElementDataSet
    }
    
    extension YTVideo {
        func withData(_ data: YTElementDataSet? = nil) -> YTVideoWithData {
            return YTVideoWithData(video: self, data: data ?? .init())
        }
    }
    
    struct YTPlaylistWithData {
        var playlist: YTPlaylist
        
        var data: YTElementDataSet
    }
    
    extension YTPlaylist {
        func withData(_ data: YTElementDataSet? = nil) -> YTPlaylistWithData {
            return YTPlaylistWithData(playlist: self, data: data ?? .init())
        }
    }
    
    
    struct DefaultElementsInfiniteScrollView: View {
        @Binding var items: [YTElementWithData]
        @Binding var shouldReloadScrollView: Bool
        
        var fetchNewResultsAtKLast: Int = 5
        var shouldAddBottomSpacing: Bool = false // add the height of the navigationbar to the bottom
        @ObservedObject private var PSM = PreferencesStorageModel.shared
        @ObservedObject private var NRM = NetworkReachabilityModel.shared
        
        var refreshAction: ((@escaping () -> Void) -> Void)?
        var fetchMoreResultsAction: (() -> Void)?
        var body: some View {
            GeometryReader { geometry in
                // We could switch to List very easily but a performance check is needed as we already use a lazyvstack
                // List {
                ScrollView {
                    LazyVStack {
                        let itemsCount = items.count
                        if itemsCount < fetchNewResultsAtKLast {
                            Color.clear.frame(width: 0, height: 0)
                                .onAppear {
                                    fetchMoreResultsAction?()
                                }
                        }
                        ForEach(Array(items.enumerated()), id: \.offset) { itemOffset, item in
                            HStack(spacing: 0) {
                                if itemsCount >= fetchNewResultsAtKLast && itemsCount - itemOffset == fetchNewResultsAtKLast + 1 {
                                    Color.clear.frame(width: 0, height: 0)
                                        .onAppear {
                                            fetchMoreResultsAction?()
                                        }
                                }
                                switch item.element {
                                    case let item as YTChannel:
                                        item.getView()
                                            .frame(width: geometry.size.width, height: 180, alignment: .center)
                                    case let item as YTPlaylist:
                                        SwipeView {
                                            item.getView()
                                                .padding(.horizontal, 5)
                                        } trailingActions: { context in
                                            if NRM.connected {
                                                if let channel = item.channel {
                                                    SwipeAction(
                                                        action: {},
                                                        label: { _ in
                                                            Image(systemName: "person.crop.rectangle")
                                                                .foregroundStyle(.white)
                                                        },
                                                        background: { _ in
                                                            Rectangle()
                                                                .fill(.cyan)
                                                            //                                                            .routeTo(.channelDetails(channel: channel))
                                                                .onDisappear {
                                                                    context.state.wrappedValue = .closed
                                                                }
                                                        }
                                                    )
                                                }
                                            }
                                        }
                                        .swipeMinimumDistance(50)
                                        .frame(width: geometry.size.width, height: 180, alignment: .center)
                                    case let rawVideo as YTVideo:
                                        if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                                            VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                                .frame(width: geometry.size.width, height: 180, alignment: .center)
                                        } else {
                                            // Big thumbnail view by default
                                            VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                                .frame(width: geometry.size.width, height: geometry.size.width * 9/16 + 90, alignment: .center)
                                            //                                            .padding(.bottom, resultIndex == 0 ? geometry.size.height * 0.2 : 0)
                                        }
                                    default:
                                        Color.clear.frame(width: 0, height: 0)
                                }
                            }
                        }
                        
                        Color.clear.frame(height: shouldAddBottomSpacing ? 49 : 0)
                    }
                }
                // .listStyle(.plain)
                .refreshable {
                    refreshAction?{}
                }
            }
            .id(PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes == .halfThumbnail)
        }
    }
    
    
    
    struct CustomElementsInfiniteScrollView: View {
        @Binding var items: [YTElementWithData]
        @Binding var shouldReloadScrollView: Bool
        var fetchNewResultsAtKLast: Int = 5
        @ObservedObject private var PSM = PreferencesStorageModel.shared
        @ObservedObject private var NRM = NetworkReachabilityModel.shared
        
        var refreshAction: ((@escaping () -> Void) -> Void)?
        var fetchMoreResultsAction: (() -> Void)?
        var body: some View {
            GeometryReader { geometry in
                InfiniteScrollView(
                    frame: .init(x: 0, y: 0, width: geometry.size.width, height: (PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes == .halfThumbnail) ? 205 : geometry.size.height),
                    changeIndex: 0 as Int,
                    content: { resultIndex in
                        HStack(spacing: 0) {
                            if self.items.count > resultIndex {
                                let item = self.items[resultIndex]
                                switch item.element {
                                    case let item as YTChannel:
                                        item.getView()
                                            .frame(width: geometry.size.width, height: 180, alignment: .center)
                                    case let item as YTPlaylist:
                                        SwipeView {
                                            item.getView()
                                                .padding(.horizontal, 5)
                                        } trailingActions: { context in
                                            if NRM.connected {
                                                if let channel = item.channel {
                                                    SwipeAction(
                                                        action: {},
                                                        label: { _ in
                                                            Image(systemName: "person.crop.rectangle")
                                                                .foregroundStyle(.white)
                                                        },
                                                        background: { _ in
                                                            Rectangle()
                                                                .fill(.cyan)
                                                            //                                                            .routeTo(.channelDetails(channel: channel))
                                                                .onDisappear {
                                                                    context.state.wrappedValue = .closed
                                                                }
                                                        }
                                                    )
                                                }
                                            }
                                        }
                                        .swipeMinimumDistance(50)
                                        .frame(width: geometry.size.width, height: 180, alignment: .center)
                                    case let rawVideo as YTVideo:
                                        let video = rawVideo.withData(item.data)
                                        if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                                            VideoFromSearchView(videoWithData: video)
                                                .frame(width: geometry.size.width, height: 180, alignment: .center)
                                        } else {
                                            // Big thumbnail view by default
                                            VideoFromSearchView(videoWithData: video)
                                                .frame(width: geometry.size.width, height: geometry.size.width * 9/16 + 90, alignment: .center)
                                            //                                            .padding(.bottom, resultIndex == 0 ? geometry.size.height * 0.2 : 0)
                                        }
                                    default:
                                        Color.clear.frame(width: 0, height: 0)
                                }
                            } else {
                                Color.clear.frame(width: 0, height: 0)
                            }
                        }
                        //                    .border(.white)
                    },
                    contentFrame: { resultIndex in
                        if self.items.count > resultIndex {
                            let item = self.items[resultIndex]
                            switch item.element {
                                case is YTVideo:
                                    if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                                        return .init(x: 0, y: 0, width: geometry.size.width, height: 205)
                                    } else {
                                        // Big thumbnail view by default
                                        return .init(x: 0, y: 0, width: geometry.size.width, height: geometry.size.width * 9/16 + 90)
                                    }
                                case is YTPlaylist:
                                    return .init(x: 0, y: 0, width: geometry.size.width, height: 180)
                                case is YTChannel:
                                    return .init(x: 0, y: 0, width: geometry.size.width, height: 180)
                                default:
                                    return .init(x: 0, y: 0, width: 0, height: 0)
                            }
                        } else {
                            return .init(x: 0, y: 0, width: 0, height: 0)
                        }
                    },
                    increaseIndexAction: { resultIndex in
                        if resultIndex < items.count - 1 {
                            let takenItemsCount = items.count > fetchNewResultsAtKLast ? fetchNewResultsAtKLast : items.count - 1
                            if resultIndex + takenItemsCount == items.count - 1 {
                                fetchMoreResultsAction?()
                            }
                            return resultIndex + 1
                        } else {
                            return nil
                        }
                    },
                    decreaseIndexAction: { resultIndex in
                        if resultIndex > 0 {
                            return resultIndex - 1
                        } else {
                            return nil
                        }
                    },
                    orientation: .vertical,
                    refreshAction: refreshAction,
                    contentMultiplier: (PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes == .halfThumbnail) ? 15 : 6,
                    updateBinding: $shouldReloadScrollView
                )
                .id(PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes == .halfThumbnail)
            }
        }
    }
    
    
    class PreferencesStorageModel: ObservableObject {
        static let shared = PreferencesStorageModel()
        
        let UD = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        
        @Published private(set) var propetriesState: [Properties : any Codable] = [:]
        
        init() {
            reloadData()
        }
        
        public func setNewValueForKey(_ key: Properties, value: Codable?) {
            if let value = value {
                guard type(of: value) == key.getExpectedType() else { print("Attempt to save property failed: received \(String(describing: value)) of type \(type(of: value)) but expected value of type \(key.getExpectedType())."); return }
                if let encoded = try? jsonEncoder.encode(value) {
                    UD.setValue(encoded, forKey: key.rawValue)
                } else {
                    print("Couldn't encode! Storing temporaily the new value.")
                }
                propetriesState[key] = value
            } else {
                UD.setValue(nil, forKey: key.rawValue)
                propetriesState[key] = nil
            }
        }
        
        private func reloadData() {
            for property in Properties.allCases where UD.object(forKey: property.rawValue) != nil {
                if let data = UD.object(forKey: property.rawValue) as? Data {
                    if let value = try? jsonDecoder.decode(property.getExpectedType(), from: data) {
                        propetriesState.updateValue(value, forKey: property)
                    }
                }
            }
        }
        
        public enum Properties: String, CaseIterable {
            case favoritesSortingMode
            case downloadsSortingMode
            public enum SortingModes: Codable {
                case newest, oldest
                case title
                case channelName
            }
            
            case videoViewMode
            public enum VideoViewModes: Codable {
                case fullThumbnail
                case halfThumbnail
            }
            
            case performanceMode
            public enum PerformanceModes: Codable {
                case full
                case limited
            }
            case liveActivitiesEnabled
            case automaticPiP
            case backgroundPlayback
            
            case isLoggerActivated
            case loggerCacheLimit
            case showCredentials
            
            case customAVButtonsEnabled
            
            func getExpectedType() -> any Codable.Type {
                switch self {
                    case .favoritesSortingMode, .downloadsSortingMode:
                        return SortingModes.self
                    case .videoViewMode:
                        return VideoViewModes.self
                    case .performanceMode:
                        return PerformanceModes.self
                    case .liveActivitiesEnabled, .automaticPiP, .backgroundPlayback, .isLoggerActivated, .showCredentials, .customAVButtonsEnabled:
                        return Bool.self
                    case .loggerCacheLimit:
                        return Int.self
                }
            }
            
            func getDefaultValue() -> any Codable {
                switch self {
                    case .favoritesSortingMode, .downloadsSortingMode:
                        return SortingModes.newest
                    case .videoViewMode:
                        return VideoViewModes.fullThumbnail
                    case .performanceMode:
                        return PerformanceModes.full
                    case .liveActivitiesEnabled, .automaticPiP, .backgroundPlayback, .customAVButtonsEnabled:
                        return true
                    case .isLoggerActivated, .showCredentials:
                        return false
                    case .loggerCacheLimit:
                        return 5
                }
            }
        }
    }
    
    extension PreferencesStorageModel {
        var customAVButtonsEnabled: Bool {
            (PreferencesStorageModel.shared.propetriesState[.customAVButtonsEnabled] as? Bool) ?? false
        }
    }
    
    
    import CoreData
    import SwipeActions
    import YouTubeKit
    
    struct VideoFromSearchView: View {
        @Environment(\.colorScheme) private var colorScheme
        let videoWithData: YTVideoWithData
        @ObservedObject private var PSM = PreferencesStorageModel.shared
        @Environment(RouterPath.self) private var routerPath

        var body: some View {
            Button {
                if VideoPlayerModel.shared.currentItem?.videoId != videoWithData.video.videoId {
                    VideoPlayerModel.shared.loadVideo(video: videoWithData.video, thumbnailData: self.videoWithData.data.thumbnailData, channelAvatarImageData: self.videoWithData.data.channelAvatarData)
                }
//                SheetsModel.shared.showSheet(.watchVideo)
                routerPath.presentedSheet = .miniPlayer

            } label: {
                if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                    VideoView(videoWithData: videoWithData)
                } else {
                    // Big thumbnail view by default
                    VideoView2(videoWithData: videoWithData)
                }
            }
            .padding(.horizontal, 5)
        }
    }
    
    
    struct VideoView: View {
        @Environment(\.colorScheme) private var colorScheme
        let videoWithData: YTVideoWithData
        @ObservedObject private var APIM = APIKeyModel.shared
        @ObservedObject private var NRM = NetworkReachabilityModel.shared
        @Environment(Theme.self) private var theme
        
        //    @ObservedObject private var PM = PersistenceModel.shared
        var body: some View {
            let video = videoWithData.video
            //        let isFavorite: Bool = {
            //            return PM.currentData.favoriteVideoIds.contains(where: {$0 == video.videoId})
            //        }()
            //
            //        let downloadLocation: URL? = {
            //            return PM.currentData.downloadedVideoIds.first(where: {$0.videoId == video.videoId})?.storageLocation
            //        }()
            
            GeometryReader { geometry in
                HStack(spacing: 3) {
                    VStack {
                        ImageOfVideoView(videoWithData: self.videoWithData)
                            .overlay(alignment: .bottomTrailing, content: {
                                if let timeLenght = video.timeLength {
                                    if timeLenght == "live" {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(.red)
                                            HStack {
                                                Image(systemName: "antenna.radiowaves.left.and.right")
                                                Text("En Direct")
                                            }
                                            .bold()
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                        }
                                        .frame(width: 100, height: 20)
                                        .padding(3)
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .opacity(0.9)
                                                .foregroundColor(.black)
                                            Text(timeLenght)
                                                .bold()
                                                .foregroundColor(.white)
                                                .font(.system(size: 14))
                                        }
                                        .frame(width: CGFloat(timeLenght.count) * 10, height: 20)
                                        .padding(3)
                                    }
                                }
                            })
                            .frame(width: geometry.size.width * 0.52, height: geometry.size.height * 0.7)
                            .shadow(radius: 3)
                        HStack {
                            VStack {
                                if let viewCount = video.viewCount {
                                    Text(viewCount)
                                        .foregroundColor(theme.labelColor)
                                        .font(.footnote)
                                        .opacity(0.5)
                                        .padding(.top, (video.timePosted != nil) ? -2 : -15)
                                    if video.timePosted != nil {
                                        Divider()
                                            .padding(.leading)
                                            .padding(.top, -6)
                                    }
                                }
                                if let timePosted = video.timePosted {
                                    Text(timePosted)
                                        .foregroundColor(theme.labelColor)
                                        .font(.footnote)
                                        .opacity(0.5)
                                        .padding(.top, -12)
                                }
                            }
                            if video.timeLength != "live" {
                                if video.timePosted != nil || video.viewCount != nil {
                                    Divider()
                                }
                                Text("DBView")
                                //                            DownloadButtonView(video: video, videoThumbnailData: self.videoWithData.data.thumbnailData, downloadURL: downloadLocation)
                                //                                .foregroundStyle(colorScheme.textColor)
                            }
                        }
                        .frame(height: geometry.size.height * 0.15)
                        .padding(.top, 1)
                    }
                    .frame(width: geometry.size.width * 0.52, height: geometry.size.height)
                    VStack {
                        Text(video.title ?? "")
                            .foregroundColor(theme.labelColor)
                            .truncationMode(.tail)
                            .frame(height: geometry.size.height * 0.7)
                        if let channelName = video.channel?.name {
                            Divider()
                            Text(channelName)
                                .foregroundColor(theme.labelColor)
                                .bold()
                                .font(.footnote)
                                .opacity(0.5)
                        }
                    }
                    .frame(width: geometry.size.width * 0.475, height: geometry.size.height)
                }
                .contextMenu {
                    //                VideoContextMenuView(videoWithData: self.videoWithData, isFavorite: isFavorite, isDownloaded: downloadLocation != nil)
                }
                //            .videoSwipeActions(video: video, thumbnailData: self.videoWithData.data.thumbnailData, isConnectedToNetwork: self.NRM.connected, disableChannelNavigation: !self.videoWithData.data.allowChannelLinking, isConnectedToGoogle: APIKeyModel.shared.userAccount != nil && APIM.googleCookies != "")
            }
        }
        
        struct ImageOfVideoView: View {
            @Environment(\.colorScheme) private var colorScheme
            let videoWithData: YTVideoWithData
            var hqImage: Bool = false
            var body: some View {
                ZStack {
                    if let thumbnailData = self.videoWithData.data.thumbnailData {
#if os(macOS)
                        if let image = NSImage(data: thumbnailData) {
                            Image(nsImage: image)
                                .scaledToFit()
                                .resizable()
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                        }
#else
                        if let image = UIImage(data: thumbnailData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                        }
#endif
                    } else if hqImage, let thumbnail = self.videoWithData.video.thumbnails.last, (thumbnail.width ?? 0) >= 480 {
                        CachedAsyncImage(url: thumbnail.url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ZStack {
                                ProgressView()
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.clear)
                                    .aspectRatio(16/9, contentMode: .fit)
                                //                                .border(colorScheme.textColor)
                            }
                        }
                    } else if hqImage, let thumbnailURL = URL(string: "https://i.ytimg.com/vi/\(self.videoWithData.video.videoId)/hqdefault.jpg") {
                        CachedAsyncImage(url: thumbnailURL) { image in
                            if let croppedImage = cropImage(image) {
                                croppedImage
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(16/9, contentMode: .fit)
                            } else {
                                ZStack {
                                    ProgressView()
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.clear)
                                        .aspectRatio(16/9, contentMode: .fit)
                                    //                                .border(colorScheme.textColor)
                                }
                            }
                        } placeholder: {
                            ZStack {
                                ProgressView()
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.clear)
                                    .aspectRatio(16/9, contentMode: .fit)
                                //                                .border(colorScheme.textColor)
                            }
                        }
                    } else if let url = self.videoWithData.video.thumbnails.last?.url {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ZStack {
                                ProgressView()
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.clear)
                                    .aspectRatio(16/9, contentMode: .fit)
                                //                                .border(colorScheme.textColor)
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Inspired from https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
            @MainActor private func cropImage(_ inputImage: Image) -> Image? {
                // Extract UIImage from Image
                guard let uiImage = ImageRenderer(content: inputImage).uiImage else { return nil }
                let portionToCut = (uiImage.size.height - uiImage.size.width * 9/16) / 2
                
                // Scale cropRect to handle images larger than shown-on-screen size
                let cropZone = CGRect(x: 0,
                                      y: portionToCut,
                                      width: uiImage.size.width,
                                      height: uiImage.size.height - portionToCut * 2)
                
                // Perform cropping in Core Graphics
                guard let cutImageRef: CGImage = uiImage.cgImage?.cropping(to: cropZone)
                else {
                    return nil
                }
                
                // Return image to UIImage
                let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
                return Image(uiImage: croppedImage)
            }
        }
    }
    
    struct VideoView2: View {
        @Environment(\.colorScheme) private var colorScheme
        let videoWithData: YTVideoWithData
        @ObservedObject private var APIM = APIKeyModel.shared
        @ObservedObject private var NRM = NetworkReachabilityModel.shared
        //    @ObservedObject private var PM = PersistenceModel.shared
        
        @Environment(Theme.self) private var theme
        
        
        var body: some View {
            let video = videoWithData.video
            
            //        let isFavorite: Bool = {
            //            return PM.currentData.favoriteVideoIds.contains(where: {$0 == video.videoId})
            //        }()
            //
            //        let downloadLocation: URL? = {
            //            return PM.currentData.downloadedVideoIds.first(where: {$0.videoId == video.videoId})?.storageLocation
            //        }()
            //
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                    VideoView.ImageOfVideoView(videoWithData: self.videoWithData, hqImage: true)
                        .overlay(alignment: .bottomTrailing, content: {
                            if let timeLenght = video.timeLength {
                                if timeLenght == "live" {
                                    ZStack {
                                        Rectangle()
                                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomTrailingRadius: 10))
                                            .foregroundStyle(.red)
                                        HStack {
                                            Image(systemName: "antenna.radiowaves.left.and.right")
                                            Text("En Direct")
                                        }
                                        .bold()
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                        .frame(alignment: .center)
                                    }
                                    .frame(width: 105, height: 25)
                                } else {
                                    ZStack {
                                        Rectangle()
                                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomTrailingRadius: 10))
                                            .foregroundStyle(.black)
                                        Text(timeLenght)
                                            .bold()
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                            .frame(alignment: .center)
                                    }
                                    .frame(width: CGFloat(timeLenght.count) * 10 + 5, height: 25)
                                }
                            }
                        })
                        .padding(.horizontal, 5)
                        .frame(width: geometry.size.width)
                    //                    .background(Color(uiColor: .init(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)))
                    HStack(spacing: 0) {
                        if let channel = video.channel {
                            Group {
                                if let ownerThumbnailData = videoWithData.data.channelAvatarData, let image = UIImage(data: ownerThumbnailData) {
                                    VStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width * 0.11)
                                            .clipShape(Circle())
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width * 0.12, alignment: .leading)
                                    .padding(.top, 3)
                                } else if let ownerThumbnailURL = video.channel?.thumbnails.last?.url {
                                    VStack {
                                        CachedAsyncImage(url: ownerThumbnailURL, content: { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: geometry.size.width * 0.11)
                                        }, placeholder: {
                                            HStack {
                                                Spacer()
                                                ProgressView()
                                                Spacer()
                                            }
                                        })
                                        .clipShape(Circle())
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width * 0.12, alignment: .leading)
                                    .padding(.top, 3)
                                }
                            }
                            //                        .routeTo(NRM.connected && self.videoWithData.data.allowChannelLinking ? .channelDetails(channel: channel) : nil)
                        }
                        VStack(alignment: .leading) {
                            Text(video.title ?? "")
                                .foregroundStyle(theme.labelColor)
                                .lineLimit(2)
                                .foregroundStyle(.white) // Modify
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .truncationMode(.tail)
                            Text("\(video.channel?.name ?? "")\(video.channel?.name != nil && (video.viewCount != nil || video.timePosted != nil) ? " • " : "")\(video.viewCount != nil ? "\(video.viewCount!)" : "")\(video.timePosted != nil && video.viewCount != nil ? " • " : "")\(video.timePosted != nil ? "\(video.timePosted!)" : "")")
                                .lineLimit(2)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                                .truncationMode(.tail)
                                .font(.caption)
                            Spacer()
                        }
                        .padding(.leading, 10)
                        .frame(width: geometry.size.width * 0.75, alignment: .leading)
                        Spacer()
                        VStack {
                            if video.timeLength != "live" {
                                //                            DownloadButtonView(video: video, videoThumbnailData: self.videoWithData.data.thumbnailData, downloadURL: downloadLocation)
                                Text("DL")
                                    .foregroundStyle(theme.labelColor)
                            }
                            /* to be reinstated later
                             Menu {
                             VideoContextMenuView(video: video, videoThumbnailData: thumbnailData, isFavorite: isFavorite, isDownloaded: (downloadLocation != nil))
                             } label: {
                             Image(systemName: "ellipsis")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 18, height: 18)
                             .foregroundStyle(colorScheme.textColor)
                             .contentShape(Rectangle())
                             .padding(.top, 10)
                             }
                             .frame(width: 20, height: 20)
                             */
                            //                        AddToFavoritesButtonView(video: video, imageData: self.videoWithData.data.thumbnailData)
                            //                            .foregroundStyle(colorScheme.textColor)
                            Spacer()
                        }
                        .frame(alignment: .top)
                        .padding(.trailing, 5)
                        if !(video.channel?.thumbnails.isEmpty ?? true) && self.videoWithData.data.channelAvatarData != nil {
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, 10)
                    .frame(width: geometry.size.width, height: 90)
                    Spacer()
                }
//                .background(theme.primaryBackgroundColor)
                .background(Color.clear)

                .contextMenu {
                    //                VideoContextMenuView(videoWithData: self.videoWithData, isFavorite: isFavorite, isDownloaded: (downloadLocation != nil))
                }
                //            .contextMenuWrapper(menuItems: [
                //                UIDeferredMenuElement({ result in
                //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                //                        result([UIAction(title: "+", handler: {_ in})])
                //                    })
                //                })
                //            ], previewProvider: {
                //                VideoView2(video: video, thumbnailData: thumbnailData, ownerThumbnailData: ownerThumbnailData)
                //                    .frame(width: geometry.size.width, height: geometry.size.height)
                //            })
                //            .videoSwipeActions(video: video, thumbnailData: self.videoWithData.data.thumbnailData, isConnectedToNetwork: self.NRM.connected, disableChannelNavigation: !self.videoWithData.data.allowChannelLinking, isConnectedToGoogle: APIKeyModel.shared.userAccount != nil && APIM.googleCookies != "")
            }
        }
    }
    
    
    protocol ViewRepresentable {
        associatedtype Content: View
        @ViewBuilder func getView() -> Content
    }
    
    extension YTVideo: ViewRepresentable {
        func getView() -> some View {
            Color.clear.frame(width: 0)
        }
    }
    
    extension YTChannel: ViewRepresentable {
        func getView() -> some View {
            //        ChannelView(channel: self)
            Text("ChannelView")
            
        }
    }
    
    extension YTPlaylist: ViewRepresentable {
        func getView() -> some View {
            PlaylistView(playlist: self)
        }
    }
    
    
    extension SearchView {
        private func getUsersPlaylists() {
            
            let params: [HeadersList.AddQueryInfo.ContentTypes : String] = [
                //            .params: "UCQR4PT87GJWB9j07ApVPBGQ",
                .browseId: "UCQR4PT87GJWB9j07ApVPBGQ"
            ]
            
            
            DispatchQueue.main.async {
                self.isFetching = true
            }
            
            
            do {
                Task {
                    let myInstance: ChannelInfosResponse = try await ChannelInfosResponse.sendThrowingRequest(youtubeModel: YTM, data: params)
                    myInstance.getChannelContent(type: .playlists, youtubeModel: YTM) { newInstance, error in
                        if let newInstance = newInstance {
                            //                    myInstance.channelContentStore.merge(newInstance.channelContentStore, uniquingKeysWith: { (_, new) in new })
                            
                            if let playlistsContent = newInstance.channelContentStore.first(where: { $0.key == .playlists })?.value as? ChannelInfosResponse.Playlists {
                                
                                //
                                self.playlists = playlistsContent.items.compactMap { $0 as? YTPlaylist }
                                
                                //                            Task {
                                //                                try await self.fetchVideoList(item: self.playlist[0])
                                //
                                //                            }
                                
                           
                                
                            } else {
                                print("No playlists found.")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                                self.isFetching = false
                            }
                        }
                    }
                }
                
            } catch {
                print(error)
            }
        }
    }
