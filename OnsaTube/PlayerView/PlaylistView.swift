//
//  PlaylistView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 10.06.2024.
//

import SwiftUI
import YouTubeKit
import DesignSystem
import Env

struct PlaylistView: View {
//    @Environment(\.colorScheme) private var colorScheme
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath

    let playlist: YTPlaylist
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    ImageOfPlaylistView(playlist: playlist)
                        .frame(width: geometry.size.width * 0.52, height: geometry.size.width * 0.52 * 9/16)
                        .shadow(radius: 3)
                    VStack {
                        if let videoCount = playlist.videoCount {
                            Text(videoCount)
                                .foregroundColor(theme.labelColor)
                                .font((playlist.timePosted != nil) ? .system(size: 10) : .footnote)
                                .bold((playlist.timePosted != nil))
                                .opacity(0.5)
                            if playlist.timePosted != nil {
                                Divider()
                                    .frame(height: 16)
                                    .padding(.top, -10)
                            }
                            if let timePosted = playlist.timePosted {
                                Text(timePosted)
                                    .foregroundColor(theme.labelColor)
                                    .font(.system(size: 10))
                                    .bold()
                                    .opacity(0.5)
                                    .padding(.top, -12)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.52, height: geometry.size.height)
                VStack {
                    VStack {
                        Text(playlist.title ?? "")
                    }
                    .foregroundColor(theme.labelColor)
                    .truncationMode(.tail)
                    .frame(height: geometry.size.height * 0.7)
                    if let channelName = playlist.channel?.name {
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
            .withAppRouter()
            .onTapGesture {
                routerPath.navigate(to: .playlistDetails(playlist: playlist))
            }
            .contextMenu {
                if let channel = playlist.channel {
                    Text("chanel")
//                    GoToChannelContextMenuButtonView(channel: channel)
                }
                Button(action: {
//                    self.playlist.showShareSheet()
                    print("ss")
                }, label: {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                })
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
//            .routeTo(.playlistDetails(playlist: playlist))

        }
       
    }
    
    struct ImageOfPlaylistView: View {
        //        @Environment(\.colorScheme) private var colorScheme
//        @Environment(Theme.self) private var theme
        
        let playlist: YTPlaylist
        var body: some View {
            ZStack {
                if !playlist.thumbnails.isEmpty, let url = playlist.thumbnails.last?.url {
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
                        }
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(EllipticalGradient(colors: [
//                                theme.labelColor,
//                                .gray,
//                                theme.labelColor,
                            ]))
                            .aspectRatio(16/9, contentMode: .fit)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

