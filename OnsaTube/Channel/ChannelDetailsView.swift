//
//  ChannelDetailsView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

#if !os(macOS)
import InfiniteScrollViews
#endif
import YouTubeKit
import DesignSystem
import SwiftUI
import InfiniteScrollViews
import YouTubeKit
import Env

struct ChannelDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    let channel: YTLittleChannelInfos
    @State private var navigationTitle: String = ""
    @State private var needToReload: Bool = true
    @State private var selectedMode: Int = 0
    @State private var selectedCategory: ChannelInfosResponse.RequestTypes? = .videos
    @State private var shouldReloadScrollView: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    @State private var isChangingSubscriptionStatus: Bool = false
    private let changeIndex: Int = 0
   
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var network = NetworkReachabilityModel.shared
    
    @StateObject private var model = Model()

    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var router
    
    var body: some View {
        GeometryReader { mainGeometry in
            ZStack {
                if model.isFetchingChannelInfos {
                    HStack(alignment: .center) {
                        Spacer()
                        LoadingView()
                        Spacer()
                    }
                }
                VStack {
                    if let channelInfos = model.channelInfos {
                       
                        bannerView(mainGeometry,channelInfos)
                  
                        channelInfoView(channelInfos)
                    
                        Divider()
                        
                        pickerView
                        
                        if let selectedCategory = selectedCategory {
                            if model.fetchingStates[selectedCategory] == true {
                                LoadingView()
                            } else {
                             
                                if model.channelInfos?.channelContentStore[selectedCategory] as? (any ListableChannelContent) != nil {
                                   
                                    let itemsBinding: Binding<[YTElementWithData]> = getItemsBindings()
                                    
                                    if itemsBinding.wrappedValue.isEmpty {
                                        noResultView
                                    } else {
                                        listItemsView(mainGeometry,itemsBinding: itemsBinding, channelInfos: channelInfos)
                                    }
                                } else {
                                    noResultView
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    onAppear()
                }
#if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .navigationTitle(navigationTitle)
                .toolbar(content: {
                    toolbarContent
                })

                .navigationBarBackButtonHidden(true)
//                .customNavigationTitleWithRightIcon {
//                    ShowSettingsButtonView()
//                }
                .observeScrollPosition(displayIndicator: false, scrollChanged: { scrollPosition in
                    self.scrollPosition = scrollPosition
                })
                .scrollDisabled(true)
            }
        }
    }
    
    private func getItemsBindings()  -> Binding<[YTElementWithData]> {
//        let itemsBinding: Binding<[YTElementWithData]> = Binding(get: {

        return Binding(get: {
            return ((model.channelInfos?.channelContentStore[selectedCategory ?? .videos] as? (any ListableChannelContent))?.items ?? [])
                .map({ item in
                    if var video = item as? YTVideo {
                        video.channel?.thumbnails = self.channel.thumbnails
                        
                        let videoWithData = YTElementWithData(element: video, data: .init(allowChannelLinking: false))
                        return videoWithData
                    } else if var playlist = item as? YTPlaylist {
                        playlist.channel?.thumbnails = self.channel.thumbnails
                        
                        let playlistWithData = YTElementWithData(element: playlist, data: .init(allowChannelLinking: false))
                        return playlistWithData
                    }
                    return YTElementWithData(element: item, data: .init())
                })
        }, set: { newValue in
            var itemsContents = model.channelInfos?.channelContentStore[selectedCategory ?? .videos] as? (any ListableChannelContent)
            itemsContents?.items = newValue.map({$0.element})
            model.channelInfos?.channelContentStore[selectedCategory ?? .videos] = itemsContents
        })
    }
    
    private func onAppear() {
        if needToReload {
            model.fetchInfos(channel: channel, {
                model.fetchCategoryContents(for: .videos)
            })
            needToReload = false
        }
    }
    
    private var noResultView: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("No items in this category.")
            Spacer()
        }
    }
    
    private func listItemsView(_ mainGeometry: GeometryProxy, itemsBinding: Binding<[YTElementWithData]>, channelInfos: ChannelInfosResponse) -> some View {
        ElementsInfiniteScrollView(
            items: itemsBinding,
            shouldReloadScrollView: $shouldReloadScrollView,
            shouldAddBottomSpacing: true,
            fetchMoreResultsAction: {
                if !(model.fetchingStates[selectedCategory ?? .videos] ?? false) {
                    model.fetchContentsContinuation(for: selectedCategory ?? .videos)
                }
            }
        )
        .frame(width: mainGeometry.size.width, height: mainGeometry.size.height * 0.7 - 49 + (channelInfos.isSubcribeButtonEnabled == true && channelInfos.subscribeStatus != nil ? 35 : 70)) // 49 for the navigation bar and 35 for the subscribe button
        .id(selectedCategory)
    }
    
    private func bannerView(_ mainGeometry: GeometryProxy, _ channelInfos: ChannelInfosResponse ) -> some View {
        LazyVStack {
            VStack {
                ZStack(alignment: .center) {
                    ChannelBannerRectangleView(channelBannerURL: channelInfos.bannerThumbnails.last?.url)
                    let thumbnailsCount = channelInfos.avatarThumbnails.count
                    Group {
                        if thumbnailsCount == 0 {
                            UnknownAvatarView()
                        } else if thumbnailsCount == 1 {
                            ChannelAvatarCircleView(avatarURL: channelInfos.avatarThumbnails.first?.url)
                        } else {
                            ChannelAvatarCircleView(avatarURL: channelInfos.avatarThumbnails[thumbnailsCount - 2].url) // take the one before the last one
                        }
                    }
                    .offset(x: (scrollPosition.y < 0) ? (scrollPosition.y < -150) ? mainGeometry.size.width * 0.3 : scrollPosition.y / 150 * mainGeometry.size.width * 0.3 : 0, y: (scrollPosition.y < 0) ? (scrollPosition.y < -150) ? -150 : -scrollPosition.y : 0)
                }
                Text(channelInfos.name ?? "")
                    .multilineTextAlignment(.center)
                    .font(.scaledTitle)
            }
            .frame(height: 150)
            
        }
    }
    private func channelInfoView(_ channelInfos: ChannelInfosResponse) ->  some View {
        HStack {
            Text(channelInfos.handle ?? "")
                .multilineTextAlignment(.center)
            if channelInfos.handle != nil, channelInfos.subscribersCount != nil {
                Text(" • ")
            }
            Text(channelInfos.subscribersCount ?? "")
            if channelInfos.subscribersCount != nil, channelInfos.videosCount != nil {
                Text(" • ")
            }
            Text(channelInfos.videosCount ?? "")
        }
        .subheadlineStyle()
        .padding(.top)
        .padding(.horizontal, 20)
        .opacity(0.5)
    }
                 
    private var pickerView: some View {
        Picker("", selection: $selectedMode, content: {
            if model.channelInfos?.requestParams[.videos] != nil {
                Text("Videos").tag(0)
            }
            if model.channelInfos?.requestParams[.shorts] != nil {
                Text("Shorts").tag(1)
            }
            if model.channelInfos?.requestParams[.directs] != nil {
                Text("Directs").tag(2)
            }
            if model.channelInfos?.requestParams[.playlists] != nil {
                Text("Playlists").tag(3)
            }
        })
        .pickerStyle(.segmented)
        .onChange(of: selectedMode, { _, _ in
            selectedCategory = getCategoryForTabIndex(selectedMode)
            guard let newValueCategory = selectedCategory else { selectedMode = 0; selectedCategory = .videos ; return }
            if (model.channelInfos?.channelContentStore[newValueCategory] as? (any ListableChannelContent)) == nil {
                model.fetchCategoryContents(for: newValueCategory)
            }
        })
    }
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
#if os(macOS)
        ToolbarItem(placement: .secondaryAction) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
        // TODO: add the share option here too
#else
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
        
//        ToolbarItem(placement: .topBarTrailing) {
//            Button {
//               self.channel.showShareSheet()
//            } label: {
//                Image(systemName: "square.and.arrow.up")
//            }
//        }
#endif
    }
    private func getCategoryForTabIndex(_ tabIndex: Int) -> ChannelInfosResponse.RequestTypes? {
        switch tabIndex {
            case 0:
                return .videos
            case 1:
                return .shorts
            case 2:
                return .directs
            case 3:
                return .playlists
            default:
                return nil
        }
    }
    
    private class Model: ObservableObject {
        @Published var channelInfos: ChannelInfosResponse?
        
        @Published var isFetchingChannelInfos: Bool = false
        
        @Published var fetchingStates: [ChannelInfosResponse.RequestTypes : Bool] = [:]
        
        @Published var continuationsFetchingStates: [ChannelInfosResponse.RequestTypes : Bool] = [:]
        
        private var channel: YTLittleChannelInfos?
        
        public func fetchInfos(channel: YTLittleChannelInfos, _ end: (() -> Void)? = nil) {
            self.channel = channel
            DispatchQueue.main.async {
                self.isFetchingChannelInfos = true
                self.channelInfos = nil
            }
            ChannelInfosResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.browseId: channel.channelId], result: { result in
                switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            self.channelInfos = response
                            self.isFetchingChannelInfos = false
                            end?()
                        }
                    case .failure(let error):
                        print("Couldn't fetch channel infos: \(error)")
                }
            })
        }
        
        public func fetchCategoryContents(for category: ChannelInfosResponse.RequestTypes) {
            if let channelId = self.channel?.channelId, let requestParams = self.channelInfos?.requestParams[category] {
                DispatchQueue.main.async {
                    self.channelInfos?.channelContentStore.removeValue(forKey: category)
                    self.fetchingStates[category] = true
                }
                ChannelInfosResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.browseId: channelId, .params: requestParams], result: { result in
                    switch result {
                        case .success(let response):
                            DispatchQueue.main.async {
                                self.channelInfos?.channelContentStore[category] = response.currentContent
                                self.channelInfos?.channelContentContinuationStore[category] = response.channelContentContinuationStore[category]
                            }
                        case .failure(let error):
                            print("Error while fetching \(String(describing: category)): \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        self.fetchingStates[category] = false
                    }
                })
            }
        }
        
        public func fetchContentsContinuation(for category: ChannelInfosResponse.RequestTypes) {
            func fetchContentsContinuationRequest<Category>(category: Category.Type) where Category: ListableChannelContent {
                DispatchQueue.main.async {
                    self.continuationsFetchingStates[category.type] = true
                }
                channelInfos?.getChannelContentContinuation(Category.self, youtubeModel: YTM, result: { (result: Result<ChannelInfosResponse.ContentContinuation<Category>, Error>) in
                    switch result {
                        case .success(let response):
                            DispatchQueue.main.async {
                                self.channelInfos?.mergeListableChannelContentContinuation(response)
                            }
                        case .failure(let error):
//                            Logger.atwyLogs.simpleLog("Error while fetching \(String(describing: category)): \(error.localizedDescription)")
                            print("Error while fetching \(String(describing: category)): \(error.localizedDescription)")
                            break;
                    }
                    DispatchQueue.main.async {
                        self.continuationsFetchingStates[category.type] = false
                    }
                })
            }
            
            if let channelInfos = self.channelInfos, (channelInfos.channelContentContinuationStore[category] ?? nil) != nil {
                guard let categoryCastedType: any ListableChannelContent.Type = getChannelContinuationContentTypeFor(category: category) else { return }
                
                fetchContentsContinuationRequest(category: categoryCastedType)
            }
            
            func getChannelContinuationContentTypeFor(category: ChannelInfosResponse.RequestTypes) -> (any ListableChannelContent.Type)? {
                switch category {
                    case .directs:
                        return ChannelInfosResponse.Directs.self
                    case .playlists:
                        return ChannelInfosResponse.Playlists.self
                    case .shorts:
                        return ChannelInfosResponse.Shorts.self
                    case .videos:
                        return ChannelInfosResponse.Videos.self
                    default:
                        return nil
                }
            }
        }
    }
}

struct ChannelAvatarCircleView: View {
    let avatarURL: URL?
    var body: some View {
        CachedAsyncImage(url: avatarURL, content: { image in
            image
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
                .shadow(radius: 15)
        }, placeholder: {
            ProgressView()
                .clipShape(Circle())
        })
    }
}

import SwiftUI

//Inspired from https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b#:~:text=To%20detect%20the%20scroll%20position,to%20a%20given%20coordinate%20system.
struct ObservedScrollView: ViewModifier {
    
    @State private var scrollPosition: ((CGPoint) -> Void)
    @State private var displayIndicator: Bool
    
    init(displayIndicator: Bool = false, scrollPosition: @escaping ((CGPoint) -> Void)) {
        self.scrollPosition = scrollPosition
        self.displayIndicator = displayIndicator
    }
    
    func body(content: Content) -> some View {
        ScrollView {
            VStack {
                content
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollPosition(value)
            }
        }
        .coordinateSpace(name: "scroll")
        .scrollIndicators(displayIndicator ? .automatic : .hidden)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

extension View {
    func observeScrollPosition(displayIndicator: Bool = true, scrollChanged: @escaping (CGPoint) -> Void) -> some View {
        modifier(ObservedScrollView(displayIndicator: displayIndicator, scrollPosition: scrollChanged))
    }
}
