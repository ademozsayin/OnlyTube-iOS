//
//  NowPlayingBarView.swift
//
//  Created by Antoine Bollengier (github.com/b5i) on 05.05.23.
//  Copyright © 2023 Antoine Bollengier. All rights reserved.
//

import SwiftUI
import AVKit
import DesignSystem
import Env
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct NowPlayingBarView: View {
    var sheetAnimation: Namespace.ID
    @Binding var isSheetPresented: Bool
    var isSettingsSheetPresented: Bool = false
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @Environment(Theme.self) private var theme
//    var routerPath: RouterPath
    
    func checkAppState() {
        // For both iOS/iPadOS and Mac Catalyst
        if UIApplication.shared.applicationState == .background {
            withAnimation {
                isSheetPresented = true
            }
        }
    }
    
    var body: some View {

        ZStack {
            Rectangle()
                .fill(.ultraThickMaterial)
                .foregroundColor(.clear.opacity(0.2))
                .overlay {
                    HStack {
                        VStack {
                            if !isSettingsSheetPresented {
                                VideoPlayer(player: VPM.player)
                                    .frame(height: 70)
                                    .onAppear {
                                        checkAppState()
#if targetEnvironment(macCatalyst)
                                        VPM.controller?.player = VPM.player
                                        print("VideoPlayer onAppear called. Player set to AVPlayerViewController.")
#endif
                                    }
                                    .onTapGesture{
                                        print("tapped")
#if targetEnvironment(macCatalyst)
                                        if let player = VPM.controller?.player {
                                            if player.isPlaying {
                                                VPM.controller?.player?.pause()
                                            } else {
                                                VPM.controller?.player?.play()
                                            }
                                        }
#endif
                                    }
                          
                            } else if let thumbnail = VPM.currentItem?.video.thumbnails.first {
                                CachedAsyncImage(url: thumbnail.url, content: { image, _ in
                                    switch image {
                                        case .success(let image):
                                            image
                                                .resizable()
                                        default:
                                            Rectangle()
                                                .foregroundColor(Color.pink)
//                                                .foregroundColor(colorScheme.backgroundColor)
                                    }
                                })
                            }
                        }
                        .frame(width: 114, height: 64)
                        .frame(alignment: .leading)
                        .matchedGeometryEffect(id: "VIDEO", in: sheetAnimation)
                        Spacer()
                        VStack(alignment: .leading) {
                            if let currentVideoTitle = VPM.currentItem?.video.title {
                                Text(currentVideoTitle)
                                    .truncationMode(.tail)
                                    .foregroundColor(theme.labelColor)
                                    .font(.scaledSubheadline)
                                    .frame(alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            } else {
                                Text("No title")
                                    .truncationMode(.tail)
                                    .foregroundColor(theme.labelColor)
                            }
                        }
                        .padding(.leading, 4)
                        .padding(.trailing, 8)
                        Spacer()
                        //                            }
                        Button {
                            withAnimation {
                                VPM.deleteCurrentVideo()
                                
                            }
                        } label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .foregroundColor(theme.labelColor)
                                .scaledToFit()
                        }
                        .frame(width: 15, height: 15)
                        .padding(.trailing)
                        .contentShape(Rectangle())
                        .tappablePadding(.init(top: 10, leading: 10, bottom: 10, trailing: 10), onTap: {
                            withAnimation {
                                VPM.deleteCurrentVideo()
                            }
                        })
                    }
                }
                .matchedGeometryEffect(id: "BGVIEW", in: sheetAnimation)
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(.gray.opacity(0.1))
                .frame(height: 1)
        }
        .frame(height: 70)
        .contextMenu {
            if let video = VPM.currentItem?.video {
                VideoContextMenuView(videoWithData: video.withData(.init(allowChannelLinking: false, thumbnailData: VPM.currentItem?.videoThumbnailData)), isFavorite: false, isDownloaded: false)
            }
        } preview: {
            if let video = VPM.currentItem?.video {
                VideoView(videoWithData: video.withData(.init(allowChannelLinking: false)))
            }
        }
        .offset(y: -49)
        .onTapGesture {
            withAnimation {
                isSheetPresented = true
            }
        }
    }
}
