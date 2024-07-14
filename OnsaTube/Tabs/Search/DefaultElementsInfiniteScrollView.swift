//
//  DefaultElementsInfiniteScrollView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import SwiftUI
import YouTubeKit
#if !os(visionOS)
import SwipeActions
#endif

import DesignSystem
import Env

struct DefaultElementsInfiniteScrollView: View {
    @Binding var items: [YTElementWithData]
    @Binding var shouldReloadScrollView: Bool
    
    var fetchNewResultsAtKLast: Int = 5
    var shouldAddBottomSpacing: Bool = false // add the height of the navigationbar to the bottom
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    @ObservedObject private var NRM = NetworkReachabilityModel.shared
    
    @Environment(RouterPath.self) var routerPath
    
    var refreshAction: ((@escaping () -> Void) -> Void)?
    var fetchMoreResultsAction: (() -> Void)?
    var body: some View {
        bodyView
    }

    let hItems = Array(1...3).map({"banner\($0)"})
    let Hlayout = [
        GridItem(.fixed(150)),
    ]
    
    let vItems = Array(1...18).map({"image\($0)"})
   
    @Environment(Theme.self) private var theme
    
    private var bodyView: some View {
        GeometryReader { geometry in
        #if os(visionOS)
           
            let Vlayout = [
                GridItem(.fixed(geometry.size.width / 3)),
                GridItem(.fixed(geometry.size.width / 3)),
                GridItem(.fixed(geometry.size.width / 3)),
            ]
            
            let itemsCount = items.count
            
            if itemsCount < 21 {
                Color.clear.frame(width: 0, height: 0)
                    .onAppear {
                        fetchMoreResultsAction?()
                    }
            }
            
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: Vlayout, content: {
                    ForEach(Array(items.enumerated()), id: \.offset) { itemOffset, item in
                       
                        VStack(spacing: 0) {
                            
                            if itemsCount >= 21 && itemsCount - itemOffset ==  22 {
                                Color.clear.frame(width: 0, height: 0)
                                    .onAppear {
                                        fetchMoreResultsAction?()
                                    }
                            }
                           
//                            Text( itemOffset.description)
                            switch item.element {
                                    
                                case let item as YTChannel:
                                    item.getView()
                                        .frame(width: geometry.size.width, height: 180, alignment: .center)
                                    
                                case let item as YTPlaylist:
                                  
                                        item.getView()
                                            .padding(.horizontal, 15)
                                            .frame(width: geometry.size.width, height: 180, alignment: .center)
                                    
                                case let rawVideo as YTVideo:
                                    if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                                        VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                            .frame(height: 180)
                                            .cornerRadius(20)
                                    } else {
                                        VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                            .frame(height: (geometry.size.width / 3 ) * 9/16 + 90)
                                            .cornerRadius(20)
                                    }
                                default:
                                    Color.clear.frame(width: 0, height: 0)
                            }
                            
                            
                        }
                        .background(theme.primaryBackgroundColor)
                        .cornerRadius(20)
                        .padding()
                    }
                })
            }
        
        #else
//            visionOsView(geometry)
//                .refreshable {
//                    refreshAction?{}
//                }
//            iOSView(geometry)
//                .refreshable {
//                    refreshAction?{}
//                }
        
            iOSView(geometry)
                .refreshable {
                    refreshAction?{}
                }
        #endif
        }
        .id(PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes == .halfThumbnail)

        
    }
    private func iOSView(_ geometry: GeometryProxy) -> some View {
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
#if !os(visionOS)
                                SwipeView {
                                    item.getView()
                                        .padding(.horizontal, 15)
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
#endif
                            case let rawVideo as YTVideo:
                                if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                                    VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                        .frame(width: geometry.size.width, height: 180, alignment: .center)
                                        .cornerRadius(20)
                                } else {
                                    // Big thumbnail view by default
                                    VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                        .frame(width: geometry.size.width, height: geometry.size.width * 9/16 + 90, alignment: .center)
                                        .cornerRadius(20)
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
    }
    
    private func visionOsView(_ geometry: GeometryProxy) -> some View {
        ScrollView {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            let itemsCount = items.count
            if itemsCount < fetchNewResultsAtKLast {
                Color.clear.frame(width: 0, height: 0)
                    .onAppear {
                        fetchMoreResultsAction?()
                    }
            }
            ForEach(Array(items.enumerated()), id: \.offset) { itemOffset, item in
                VStack(spacing: 0) {
                    if itemsCount >= fetchNewResultsAtKLast && itemsCount - itemOffset == fetchNewResultsAtKLast + 1 {
                        Color.clear.frame(width: 0, height: 0)
                            .onAppear {
                                fetchMoreResultsAction?()
                            }
                    }
                    switch item {
                        case let item as YTChannel:
                            item.getView()
                                .frame(height: 180)
                        case let item as YTPlaylist:
                            
                            item.getView()
                                .padding(.horizontal, 15)
                            
                        case let rawVideo as YTVideo:
                            if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                                VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                    .frame(height: 180)
                            } else {
                                VideoFromSearchView(videoWithData: rawVideo.withData(item.data))
                                    .frame(height: geometry.size.width * 9/16 + 90)
                            }
                        default:
                            Color.clear.frame(width: 0, height: 0)
                    }
                }
                .frame(width: geometry.size.width / 2 - 16)
            }
            
            Color.clear.frame(height: shouldAddBottomSpacing ? 49 : 0)
        }
        .padding()
    }
    }
}
