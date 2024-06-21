//
//  UsersPlaylistsListView.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 10.06.2024.
//



import SwiftUI
import YouTubeKit
import DesignSystem
import Env

struct UsersPlaylistsListView: View {
    let playlists: [YTPlaylist]
    @State private var search: String = ""
    @ObservedObject private var APIM = APIKeyModel.shared
    @ObservedObject private var network = NetworkReachabilityModel.shared
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var NRM = NetworkReachabilityModel.shared
    
    @State private var routerPath = RouterPath()
    
    var body: some View {
       
        GeometryReader { geometry in
          
            ScrollView(.vertical, content: {
                LazyVStack {
                    Color.clear.frame(width: 0, height: 20)
                    let playlistsToDisplay: [YTPlaylist] = search.isEmpty ? playlists : playlists.filter({$0.title?.contains(search) ?? false})
                    ForEach(Array(playlistsToDisplay.enumerated()), id: \.offset) { _, playlist in
                        PlaylistView(playlist: playlist)
                            .padding(.horizontal, 5)
                            .frame(width: geometry.size.width, height: 180)
                            .onTapGesture {
                                print("navigate to playlist details")
                              // routerPath.navigate(to: .playlistDetails(playlist: playlist))
                            }
                    }
                    Color.clear.frame(width: 0, height: (VPM.currentItem != nil) ? 50 : 0)
                }
            })
#if os(macOS)
            .searchable(text: $search, placement: .toolbar)
#else
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
#endif
        }
        .onAppear {
            print(playlists.count)
        }
        .navigationTitle("Playlists")
        .withAppRouter()
//        .customNavigationTitleWithRightIcon {
//            ShowSettingsButtonView()
//        }
    }
}
