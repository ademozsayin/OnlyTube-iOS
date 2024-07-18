//
//  PlayingQueueView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import SwiftUI
import DesignSystem
import Env

@MainActor
struct PlayingQueueView: View {
#if !os(macOS)
    @Environment(\.editMode) private var editMode
#endif
    //    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var VTM = VideoThumbnailsManager.main
    @Environment(Theme.self) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private var nextView: some View {
        Text("Next up")
            .foregroundColor(theme.labelColor)
            .font(.scaledCallout)
            .bold()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
    
    var body: some View {
        ZStack {
            
            GeometryReader { geometry in
        
                VStack {
                    nextView
//                    listView(geometry)
                    let queueBinding: Binding<[YTAVPlayerItem]> = Binding(get: {
                        return VideoPlayerModel.shared.player.items().compactMap({$0 as? YTAVPlayerItem}).filter({$0 != VideoPlayerModel.shared.currentItem})
                    }, set: { newValue in
                        VideoPlayerModel.shared.player.items().forEach {
                            if $0 != VideoPlayerModel.shared.currentItem {
                                VideoPlayerModel.shared.player.remove($0)
                            }
                        }
                        for item in newValue.reversed() {
                            VideoPlayerModel.shared.player.insert(item, after: VideoPlayerModel.shared.currentItem)
                        }
                        VideoPlayerModel.shared.player.updateEndAction()
                    })
                    
                    List(queueBinding, id: \.self, editActions: [.move, .delete]) { $video in
                        Button {
                            for item in VideoPlayerModel.shared.player.items().compactMap({$0 as? YTAVPlayerItem}) {
                                if item == video {
                                    break
                                } else {
                                    VideoPlayerModel.shared.player.remove(item)
                                }
                            }
                            VideoPlayerModel.shared.player.advanceToNextItem()
                            VideoPlayerModel.shared.player.updateEndAction()
                        } label: {
                            HStack {
                                Image(systemName: "line.3.horizontal")
                                    .padding(.vertical)
            
                                imageView(video)
                                    .frame(width: 70, height: 40)
            
                                VStack {
                                    Text(video.videoTitle ?? "")
                                        .font(.system(size: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(video.channelName ?? "")
                                        .font(.system(size: 13))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .padding()
                            .contextMenu(menuItems: {
                                AddToQueueContextMenuButtonView(video: video.video, videoThumbnailData: VTM.images[video.videoId])
                            }, preview: {
                                VideoView(videoWithData: video.video.withData(.init(allowChannelLinking: false, thumbnailData: VTM.images[video.videoId])))
                                    .environment(Theme.shared)
                            })
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.inset)
                    .frame(width: geometry.size.width, height: geometry.size.height )
                    .background(Color.purple)
//                    .colorMultiply(Color.red).padding(.top)
                    .listRowBackground(Color.yellow)
                    .onAppear {
                        // Set the default to clear
                        UITableView.appearance().backgroundColor = .clear
                    }
                    
                }
                .background(Color.clear)
            }
        }
        .background(Color.clear)
        
    }

    private func imageView (_ video: YTAVPlayerItem) -> some View {
        VStack {
            if let thumbnailData = VTM.images[video.videoId], let image = UIImage(data: thumbnailData){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                CachedAsyncImage(url: video.video.thumbnails.first?.url, content: { content, _ in
                    switch content {
                        case .empty:
                            Rectangle()
                                .foregroundColor(theme.primaryBackgroundColor)
                        case .failure:
                            Rectangle()
                                .foregroundColor(theme.primaryBackgroundColor)
                        case .success(let image):
                            image
                                .resizable()
                        @unknown default:
                            Rectangle()
                                .foregroundColor(theme.primaryBackgroundColor)
                    }
                })
            }
        }

    }
}
