//
//  PlaylistDetailsView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

import SwiftUI
//#if !os(macOS)
//import InfiniteScrollViews
//#endif
import YouTubeKit
import DesignSystem
import Env

struct PlaylistDetailsView: View {
    @Environment(Theme.self) private var theme
    @Environment(\.dismiss) private var dismiss
    let playlist: YTPlaylist
    @State private var navigationTitle: String = ""
    @State private var shouldReloadScrollView: Bool = false
    @StateObject private var model = Model()
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var network = NetworkReachabilityModel.shared
    private let changeIndex: Int = 0
    var body: some View {
        GeometryReader { geometry in
            //    ScrollView {
            let topPaddingForInformations: CGFloat = (playlist.channel?.name != nil ? 30 : 0) + ((model.playlistInfos?.viewCount != nil || playlist.timePosted != nil || model.playlistInfos?.videoCount != nil) ? 30 : 0)
            VStack(spacing: 0) {
                if model.isFetchingInfos {
//                    LoadingView()
                    ScrollView {
                        loadingView
                    }
                    .allowsHitTesting(false)
                    
                } else {
                    VStack {
                        if model.playlistInfos?.results != nil {
                            let videosBinding: Binding<[YTElementWithData]> = Binding(get: {
                                var toReturn: [YTElementWithData] = []
                                for (video, token) in zip(model.playlistInfos?.results ?? [], model.playlistInfos?.videoIdsInPlaylist ?? Array(repeating: nil, count: model.playlistInfos?.results.count ?? 0)) {
                                    var videoData = YTElementDataSet()
                                    if let removalToken = token {
                                        videoData.removeFromPlaylistAvailable = {
                                            RemoveVideoFromPlaylistResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.movingVideoId: removalToken, .playlistEditToken: "CAFAAQ%3D%3D", .browseId: self.playlist.playlistId], result: { result in
                                                switch result {
                                                    case .success(_):
                                                        if let removalIndex = self.model.playlistInfos?.videoIdsInPlaylist?.firstIndex(where: {$0 == token}) {
                                                            DispatchQueue.main.async {
                                                                _ = self.model.playlistInfos?.results.remove(at: removalIndex)
                                                            }
                                                        }
                                                    case .failure(_):
                                                        break
                                                }
                                            })
                                        }
                                    }
                                    toReturn.append(
                                        YTElementWithData(element: video, data: videoData)
                                    )
                                }
                                return toReturn
                            }, set: { newValue in
                                model.playlistInfos?.results = newValue.compactMap({$0.element as? YTVideo})
                            })
                            ElementsInfiniteScrollView(
                                items: videosBinding,
                                shouldReloadScrollView: $shouldReloadScrollView,
                                fetchMoreResultsAction: {
                                    model.fetchPlaylistContinuation()
                                }
                            )
                        }
                    }
                    .customHeaderView({
                        VStack {
                            if let channelName = playlist.channel?.name {
                                Text(channelName)
                                    .font(.scaledHeadline)
                                    .lineLimit(3)
                                    .frame(height: 30)
                            }
                            if model.playlistInfos?.viewCount != nil || playlist.timePosted != nil || model.playlistInfos?.videoCount != nil {
                                HStack {
                                    Text(model.playlistInfos?.videoCount ?? "")
                                        .foregroundColor(theme.labelColor)
                                        .font(.scaledFootnote)
                                        .opacity(0.5)
                                    if (model.playlistInfos?.viewCount != nil || playlist.timePosted != nil) && model.playlistInfos?.videoCount != nil {
                                        Divider()
                                    }
                                    Text(model.playlistInfos?.viewCount ?? "")
                                        .foregroundColor(theme.labelColor)
                                        .font(.scaledFootnote)                                       
                                        .opacity(0.5)
                                    if model.playlistInfos?.viewCount != nil, playlist.timePosted != nil {
                                        Divider()
                                    }
                                    Text(playlist.timePosted ?? "")
                                        .foregroundColor(theme.labelColor)
                                        .font(.scaledFootnote)
                                        .opacity(0.5)
                                }
                                .frame(height: 20)
                            }
                        }
                        .padding(.horizontal)
                        //}
                        //.frame(width: geometry.size.width, height: topPaddingForInformations)
                    }, height: topPaddingForInformations)
                    //.padding(.top, topPaddingForInformations)
                }
                if VPM.currentItem != nil {
                    Color.clear.frame(width: 0, height: 70)
                }
            }
            .onAppear {
                if model.playlistInfos == nil {
                    model.fetchPlaylistInfos(playlist: playlist)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
#if !targetEnvironment(macCatalyst)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .navigationTitle(playlist.title ?? "")
        .toolbar(content: {
            toolbarContent
        })
        .navigationBarBackButtonHidden(true)
        .customNavigationTitleWithRightIcon {
            ShowSettingsButtonView()
        }
    }
    
    @MainActor
    private var loadingView: some View {
        VStack(alignment: .center) {
            //            LoadingView(customText: drafts.isEmpty ? "Waiting for your selection" : "Preparing")
            //                .frame(maxWidth: .infinity, alignment: .center)
            //
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
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
        
        //TODO: - Share deeplink integration
//        if self.playlist.playlistId.hasPrefix("PL") || self.playlist.playlistId.hasPrefix("VLPL") {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {
//                    self.playlist.showShareSheet()
//                }) {
//                    Image(systemName: "square.and.arrow.up")
//                }
//            }
//        }
    }
    
    private class Model: ObservableObject {
        @Published var playlistInfos: PlaylistInfosResponse?
        @Published var isFetchingInfos: Bool = false
        @Published var isFetchingContinuation: Bool = false
        
        public func fetchPlaylistInfos(playlist: YTPlaylist) {
            if !self.isFetchingInfos {
                DispatchQueue.main.async {
                    self.isFetchingInfos = true
                }
                PlaylistInfosResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.browseId: playlist.playlistId], useCookies: true, result: { result in
                    switch result {
                        case .success(let response):
                            DispatchQueue.main.async {
                                self.playlistInfos = response
                                if response.playlistId == nil {
                                    self.playlistInfos?.playlistId = playlist.playlistId
                                }
                            }
                        case .failure(let error):
                            print("Error while fetching playlist infos: \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        self.isFetchingInfos = false
                    }
                })
            }
        }
        
        public func fetchPlaylistContinuation() {
            if !self.isFetchingContinuation, let continuationToken = playlistInfos?.continuationToken {
                DispatchQueue.main.async {
                    self.isFetchingContinuation = true
                }
                PlaylistInfosResponse.Continuation.sendNonThrowingRequest(youtubeModel: YTM, data: [.continuation: continuationToken], useCookies: true, result: { result in
                    switch result {
                        case .success(let response):
                            DispatchQueue.main.async {
                                self.playlistInfos?.mergeWithContinuation(response)
                            }
                        case .failure(let error):
                            print("Error while fetching playlist infos: \(error)")
                    }
                    DispatchQueue.main.async {
                        self.isFetchingContinuation = false
                    }
                })
            }
        }
        
        public func removeFromPlaylist(videoIdInPlaylist: String) {
            if let playlistInfos = playlistInfos, let playlistId = playlistInfos.playlistId, playlistInfos.userInteractions.isEditable ?? false {
                RemoveVideoFromPlaylistResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.movingVideoId: videoIdInPlaylist, .playlistEditToken: "CAFAAQ%3D%3D", .browseId: playlistId], result: { result in
                    switch result {
                        case .success(let response):
                            if response.success, let removedVideoIndex =
                                playlistInfos.videoIdsInPlaylist?.firstIndex(where: { $0 == videoIdInPlaylist }) {
                                DispatchQueue.main.async {
                                    _ = self.playlistInfos?.videoIdsInPlaylist?.remove(at: removedVideoIndex)
                                    self.playlistInfos?.results.remove(at: removedVideoIndex)
                                }
                            }
                        case .failure(let error):
                            print("Couldn't remove video from playlist: \(error)")
                    }
                })
            }
        }
        
        public func moveVideoInPlaylist(videoBeforeIdInPlaylist: String?, videoIdInPlaylist: String) {
            if let playlistInfos = playlistInfos, let playlistId = playlistInfos.playlistId, playlistInfos.userInteractions.canReorder ?? false {
                var data: [YouTubeKit.HeadersList.AddQueryInfo.ContentTypes: String] = [.movingVideoId: videoIdInPlaylist, .browseId: playlistId]
                if let videoBeforeIdInPlaylist = videoBeforeIdInPlaylist {
                    data[.videoBeforeId] = videoBeforeIdInPlaylist
                }
                MoveVideoInPlaylistResponse.sendNonThrowingRequest(youtubeModel: YTM, data: data, result: { result in
                    switch result {
                        case .success(let response):
                            if response.success {
                                if videoBeforeIdInPlaylist != nil, let videoBeforeIndex = playlistInfos.videoIdsInPlaylist?.firstIndex(where: {$0 == videoBeforeIdInPlaylist}), let movingVideoIndex = playlistInfos.videoIdsInPlaylist?.firstIndex(where: {$0 == videoIdInPlaylist}) {
                                    DispatchQueue.main.async {
                                        self.playlistInfos?.videoIdsInPlaylist?.swapAt(videoBeforeIndex, movingVideoIndex)
                                        self.playlistInfos?.results.swapAt(videoBeforeIndex, movingVideoIndex)
                                    }
                                } else if let movingVideoIndex = playlistInfos.videoIdsInPlaylist?.firstIndex(where: {$0 == videoIdInPlaylist}) {
                                    let element = self.playlistInfos?.results[movingVideoIndex]
                                    if let element = element {
                                        DispatchQueue.main.async {
                                            self.playlistInfos?.results.remove(at: movingVideoIndex)
                                            self.playlistInfos?.videoIdsInPlaylist?.remove(at: movingVideoIndex)
                                            self.playlistInfos?.results.insert(element, at: 0)
                                            self.playlistInfos?.videoIdsInPlaylist?.insert(videoBeforeIdInPlaylist, at: 0)
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Couldn't move video in playlist: \(error)")
                    }
                })
            }
        }
    }
}




struct ShowSettingsButtonView: View {
    @ObservedObject private var NRM = NetworkReachabilityModel.shared
    var body: some View {
        Button {
            SheetsModel.shared.showSheet(.settings)
        } label: {
            UserPreferenceCircleView()
                .frame(width: 40, height: 40)
        }
    }
}


struct UserPreferenceCircleView: View {
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var NM = NetworkReachabilityModel.shared
    var body: some View {
        if let account = APIM.userAccount, NM.connected {
            CachedAsyncImage(url: account.avatar.first?.url, content: { image, _ in
                switch image {
                    case .success(let imageDisplay):
                        imageDisplay
                            .resizable()
                            .clipShape(Circle())
                    default:
                        UnknownAvatarView()
                }
            })
        } else {
            UnknownAvatarView()
        }
    }
}
