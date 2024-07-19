//
//  FavoritesView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 27.06.2024.
//
import SwiftUI
import CoreData
import Env
import YouTubeKit

struct FavoritesView: View {
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteVideo.timestamp, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteVideo>
    @State private var search: String = ""
    //    @ObservedObject private var NPM = NavigationPathModel.shared
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var NM = NetworkReachabilityModel.shared
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    
    @State private var routerPath = RouterPath()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack {
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
                    Color.clear
                        .frame(height: 30)
                }
                if VPM.currentItem != nil {
                    Color.clear
                        .frame(height: 50)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
#if os(macOS)
        .searchable(text: $search, placement: .toolbar)
#else
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
#endif

        .autocorrectionDisabled(true)
        .navigationTitle("Favorites")
        .sortingModeSelectorButton(forPropertyType: .favoritesSortingMode)
        
    }
    
    var sortedVideos: [FavoriteVideo] {
        return self.favorites
            .filter({$0.matchesQuery(search)})
            .conditionnalFilter(mainCondition: !NM.connected, { PersistenceModel.shared.isVideoDownloaded(videoId: $0.videoId ?? "") != nil })
            .sorted(by: {
                let timestamp1 = $0.timestamp ?? Date.distantPast // Default to a distant past date if nil
                let timestamp2 = $1.timestamp ?? Date.distantPast // Default to a distant past date if nil
                
                
                switch (self.PSM.propetriesState[.favoritesSortingMode] as? PreferencesStorageModel.Properties.SortingModes) ?? .oldest {
                    case .newest:
                        return timestamp1 > timestamp2
                    case .oldest:
                        return timestamp1 < timestamp2
                    case .title:
                        let title1 = $0.title ?? ""
                        let title2 = $1.title ?? ""
                        return title1 < title2
//                    case .channelName:
//                        return ($0.channel?.name ?? "") < ($1.channel?.name ?? "")
                }
            })
    }
}

struct IsPresentedSearchableModifier: ViewModifier {
    @Binding var search: String
    @Binding var isPresented: Bool
    var placement: SearchFieldPlacement = .automatic
    func body(content: Content) -> some View {
        Group {
            if isPresented {
                content
                    .searchable(text: $search, placement: placement)
            } else {
                content
            }
        }
    }
}

extension View {
    func isPresentedSearchable(search: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic) -> some View {
        modifier(IsPresentedSearchableModifier(search: search, isPresented: isPresented, placement: placement))
    }
}


extension Collection {
    func conditionnalFilter(mainCondition: Bool, _ isIncluded: (Self.Element) throws -> Bool) rethrows -> [Self.Element] {
        if mainCondition {
            return try self.filter(isIncluded)
        } else {
            return self.map({$0})
        }
    }
}


