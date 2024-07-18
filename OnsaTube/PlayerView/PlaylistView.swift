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

//
//  PlaylistView.swift
//  Atwy
//
//  Created by Antoine Bollengier on 22.01.23.
//

import SwiftUI
import YouTubeKit

struct PlaylistView: View {
   
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath

    let playlist: YTPlaylist
    var body: some View {
        GeometryReader { geometry in
        #if !targetEnvironment(macCatalyst)
            HStack {
                VStack {
                    ImageOfPlaylistView(playlist: playlist)
                        .frame(width: geometry.size.width * 0.52, height: geometry.size.width * 0.52 * 9/16)
                        .shadow(radius: 3)
                    VStack {
                        if let videoCount = playlist.videoCount {
                            Text(videoCount)
                                .foregroundColor(theme.labelColor)
//                                .font((playlist.timePosted != nil) ? .system(size: 10) : .footnote)
//                                .bold((playlist.timePosted != nil))
                                .font((playlist.timePosted != nil) ? .scaledCallout : .scaledFootnote)
                                .opacity(0.5)
                            if playlist.timePosted != nil {
                                Divider()
                                    .frame(height: 16)
                                    .padding(.top, -10)
                            }
                            if let timePosted = playlist.timePosted {
                                Text(timePosted)
                                    .foregroundColor(theme.labelColor)
//                                    .font(.system(size: 10))
//                                    .bold()
                                    .font(.scaledFootnote)
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
                            .font(.scaledBody)
                    }
                    .foregroundColor(theme.labelColor)
                    .truncationMode(.tail)
                    .frame(height: geometry.size.height * 0.7)
                    if let channelName = playlist.channel?.name {
                        Divider()
                        Text(channelName)
                            .foregroundColor(theme.labelColor)
                            .bold()
                            .font(.scaledFootnote)
                            .opacity(0.5)
                    }
                }
            }
            .contextMenu {
                if let channel = playlist.channel {
                    GoToChannelContextMenuButtonView(channel: channel)
                }
                Button(action: {
                    //                    self.playlist.showShareSheet()
                }, label: {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                })
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onTapGesture {
                routerPath.navigate(to: .playlistDetails(playlist: playlist))
            }
            #else
            HStack {
                VStack {
                    ImageOfPlaylistView(playlist: playlist)
                        .frame(width: (geometry.size.height - 32) * 16 / 9 , height: geometry.size.height - 32 )
                        .shadow(radius: 3)
                        
                    VStack {
                        if let videoCount = playlist.videoCount {
                            Text(videoCount)
                                .foregroundColor(theme.labelColor)
                            //                                .font((playlist.timePosted != nil) ? .system(size: 10) : .footnote)
                            //                                .bold((playlist.timePosted != nil))
                                .font((playlist.timePosted != nil) ? .scaledCallout : .scaledFootnote)
                                .opacity(0.5)
                            if playlist.timePosted != nil {
                                Divider()
                                    .frame(height: 16)
                                    .padding(.top, -10)
                            }
                            if let timePosted = playlist.timePosted {
                                Text(timePosted)
                                    .foregroundColor(theme.labelColor)
                                //                                    .font(.system(size: 10))
                                //                                    .bold()
                                    .font(.scaledFootnote)
                                    .opacity(0.5)
                                    .padding(.top, -12)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.5, height: geometry.size.height, alignment: .leading)
                VStack {
                    VStack {
                        Text(playlist.title ?? "")
                            .font(.scaledBody)
                    }
                    .foregroundColor(theme.labelColor)
                    .truncationMode(.tail)
                    .frame(height: geometry.size.height * 0.7)
                    if let channelName = playlist.channel?.name {
                        Divider()
                        Text(channelName)
                            .foregroundColor(theme.labelColor)
                            .bold()
                            .font(.scaledFootnote)
                            .opacity(0.5)
                    }
                }
                .frame(width: geometry.size.width * 0.48, height: geometry.size.height)

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
//            .background(Color.primary)
            .contextMenu {
                if let channel = playlist.channel {
                    GoToChannelContextMenuButtonView(channel: channel)
                }
                Button(action: {
                    //                    self.playlist.showShareSheet()
                }, label: {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                })
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onTapGesture {
                routerPath.navigate(to: .playlistDetails(playlist: playlist))
            }
            #endif
       
        }
    }
    
    struct ImageOfPlaylistView: View {
        @Environment(Theme.self) private var theme
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
                            .foregroundStyle(EllipticalGradient(colors: [theme.labelColor, .gray, theme.labelColor]))
                            .aspectRatio(16/9, contentMode: .fit)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
