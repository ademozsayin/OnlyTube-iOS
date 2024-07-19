//
//  SearchView.swift
//  OnsaTube
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
#if !os(macOS)
import InfiniteScrollViews
#endif

import YouTubeKit
#if !os(visionOS)
import SwipeActions
#endif
import DesignSystem
import TipKit
import Models
import SwiftData

let YTM = YouTubeModel()

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}

// Shimmer effect helper
fileprivate struct ShimmerEffectHelper: ViewModifier {
    
    var config: ShimmerConfig
    
    //MARK: - Animation Properties
    @State private var moveTo: CGFloat = -0.5
    
    func body(content: Content) -> some View {
        content
        /// Adding shimmer effect using the mask modifier
        /// Hiding the normal one and adding the shimmer one instead
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        /// Shimmer
                        GeometryReader{ geometry in
                            let size = geometry.size
                            let extraOffset = size.height / 2.5
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    /// Gradient for glowing at the center
                                    Rectangle()
                                        .fill(.linearGradient(colors: [.white.opacity(0),
                                                                       config.highlight.opacity(config.highlightOpactity)
                                                                      ],
                                                              startPoint: .top,
                                                              endPoint: .bottom)
                                        )
                                    /// Blur
                                        .blur(radius: config.blur)
                                        .rotationEffect(.degrees(-70))
                                    /// Move to start
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                    
                                } //: MASK RECTANGLE
                        } //: GEOMETRY
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            } //: OVERLAY
    }
    
}

struct ShimmerConfig {
    
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpactity: CGFloat = 1
    var speed: CGFloat = 2
    
}

@MainActor
struct SearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(UserPreferences.self) private var preferences
    
    @State private var autoCompletion: [String] = []
    @State private var search: String = "" {
        didSet {
            callSearching()
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
    @State private var isFetching: Bool = false
    @State private var libraryContent: AccountLibraryResponse?
    @State private var playlists: [YTPlaylist] = []
    @State private var model = Model.shared
    @State private var viewModel = SearchViewModel()

    @ObservedObject private var IUTM = IsUserTypingModel.shared
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var NRM = NetworkReachabilityModel.shared
    //    @ObservedObject private var PSM = PreferencesStorageModel.shared
    //    @ObservedObject private var NPM = NavigationPathModel.shared
    @Environment(RouterPath.self) private var routerPath
    @Environment(Theme.self) private var theme
  
    @Binding var scrollToTopSignal: Int
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Draft.creationDate, order: .reverse) var drafts: [Draft]

    
    public init(scrollToTopSignal: Binding<Int>) {
        _scrollToTopSignal = scrollToTopSignal
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                   backgroundImageView
                    statesView
                }
                .onChange(of: viewModel.search) { oldValue, newValue in
                    search = newValue
                    needToReload = true
                    callSearching()
                }
                .navigationTitle("Dashboard")
                .environment(routerPath)
                .onChange(of: scrollToTopSignal) {
                    withAnimation {
                        proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
                    }
                }
                .onAppear {
                    if drafts.isEmpty && preferences.hasAcceptedDisclaimer {
                        routerPath.presentedSheet = .categorySelection
                        model.state = .loading
                    } else {
                        
                        search = drafts.map { $0.content }.joined(separator: ", ")
                        
                        if search != viewModel.search {
                            
                            viewModel.search = search
                            
                            // Set flag to indicate reload needed
                            needToReload = true
                            
                            // Call your search function
                            callSearching()
                            
                            // Print each draft's content
                            for draft in drafts {
                                print("Draft content: \(draft.content)")
                            }
                        }
                        
                    }
                    
                }.onChange(of: drafts) { oldValue, newValue in
                    search = newValue.map { $0.content }.joined(separator: ", ")
                    needToReload = true
                    viewModel.search = search
                    callSearching()
                }
                .onChange(of: preferences.hasAcceptedDisclaimer) { oldValue, newValue in
                    if drafts.isEmpty && preferences.hasAcceptedDisclaimer {
                        routerPath.presentedSheet = .categorySelection
                    }
                }
            }
        }
    }
    
    private var backgroundImageView: some View {
        Image("bg2")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .aspectRatio(contentMode: .fill)
            .opacity(preferences.showBackgroundImage ? 1 : 0)
    }
    
    private var statesView: some View {
        Group {
            
            switch model.state {
                case .loading:
                    
                    loadingView
                    
                    
                    
                case .empty:
                    emptyView
                    
                case .error:
                    errorView
                    
                case .result:
                    resultView
                    //
                    //                                    .onChange(of: viewModel.scrollToIndex) { _, newValue in
                    //                                        if let collectionView,
                    //                                           let newValue,
                    //                                           let rows = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0),
                    //                                           rows > newValue
                    //                                        {
                    //                                            collectionView.scrollToItem(at: .init(row: newValue, section: 0),
                    //                                                                        at: .top,
                    //                                                                        animated: viewModel.scrollToIndexAnimated)
                    //                                            viewModel.scrollToIndexAnimated = false
                    //                                            viewModel.scrollToIndex = nil
                    //                                        }
                    //                                    }
                    //                                    .onChange(of: scrollToTopSignal) {
                    //                                        withAnimation {
                    //                                            proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
                    //                                        }
                    //                                    }
                    
            }
            
        }
    }
    
    @MainActor
    private var loadingView: some View {
        VStack(alignment: .center) {
//            LoadingView(customText: drafts.isEmpty ? "Waiting for your selection" : "Preparing")
//                .frame(maxWidth: .infinity, alignment: .center)
//            
            if drafts.isEmpty {
                Button {
                    routerPath.presentedSheet = .categorySelection
                } label: {
                    Text("Select")
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding()
                
            }
            ScrollView {
                ForEach(0..<10) { _ in
                    VStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                        
                        HStack {
                            Circle()
                                .frame(height: 30)
                            
                            VStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 10)
                                    .padding(.trailing, 50)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 10)
                                    .padding(.trailing, 100)
                            }
                            
                            
                        }
                    }
                    .padding()
                    .padding(.horizontal)
                    .shimmer(.init(tint: theme.tintColor.opacity(0.8), highlight: .white, blur: 25))
                }
            }
            .allowsHitTesting(false)
        }
    }
    
    private var shimmerView: some View {
      
        HStack(alignment: .top) {
            Image("thumbnail")
                .resizable()
                .frame(width: 120, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Intro to Economics: Crash Course Econ #1")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text("CrashCourse • 7.7M views • 9 years ago")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("12:09")
                        .font(.system(size: 14))
                        .bold()
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "star")
                .foregroundColor(.white)
                .padding(.top, 5)
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(10)
    }
    
    private var emptyView: some View {
        
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text("No videos found...")
                        .foregroundColor(theme.labelColor)
                    Text("Search videos or pull up to refresh for the algorithm to fill this menu.")
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                    
                    
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
            .introspect(.list, on: .iOS(.v17)) { (collectionView: UICollectionView) in
                DispatchQueue.main.async {
                    self.collectionView = collectionView
                }
                //                                        prefetcher.viewModel = viewModel
                collectionView.isPrefetchingEnabled = true
                //                                        collectionView.prefetchDataSource = prefetcher
            }
        }
    }
    
    private var errorView: some View {
        
        VStack (alignment: .center) {
            Spacer()
            Image(systemName: "multiply.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
            Text("Something went wrong")
                .foregroundColor(.red)
            Button {
                search = ""
                dismissSearch()
                model.getVideos(demo: false)
            } label: {
                Text("Retry")
            }
            .buttonStyle(.bordered)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var resultView: some View {
        let itemsBinding = Binding(get: {
            return model.items.map({YTElementWithData(element: $0, data: .init())})
        }, set: { newValue in
            model.items = newValue.map({$0.element})
        })
        
        return ElementsInfiniteScrollView(
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
    
    func callSearching() {
        if needToReload {
            if search.isEmpty {
                model.getVideos(demo: false)
            } else {
                model.getVideos(search, demo: false)
//                let ytVideo = YTVideo(
//                    videoId: "gO70C5Q_f6Y",
//                    title: "The special One",
//                    thumbnails: [YTThumbnail(url: URL(string: "https://i.ytimg.com/vi/VLFy-a-_wFI/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDhGZLAAHzUFdfBbe2Yx-wS6h3_Dg")!)]
//                )
//                
//                if preferences.enableAutoPlayAtStart && preferences.hasAcceptedDisclaimer  {
//                    VideoPlayerModel.shared.loadVideo(video: ytVideo, thumbnailData: nil, channelAvatarImageData: nil)
//                }
                
//                model.getVideos(searchDemoData, demo: true)
            }
            needToReload = false
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
            .frame(width:30, height: 30)
//            .frame(height: .layoutPadding )
            .onAppear {
                viewModel.scrollToTopVisible = true
            }
            .onDisappear {
                viewModel.scrollToTopVisible = false
            }
    }
}


protocol ViewRepresentable {
    associatedtype Content: View
    @ViewBuilder func getView() -> Content
}


struct TapToSelectImageTip: Tip {
    var id = UUID()
    
    var title: Text {
        Text("Tap to Add")
    }
    var message: Text? {
        Text("You can add to favorites by tapping here")
    }
    var asset: Image? {
        Image(systemName: "star")
    }
}
