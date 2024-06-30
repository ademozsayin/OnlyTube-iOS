//
//  VideoFromSearchView.swift
//  Atwy
//
//  Created by Antoine Bollengier on 27.12.22.
//

import CoreData
import SwiftUI
#if !os(visionOS)
import SwipeActions
#endif
import YouTubeKit
import Env
import TipKit

struct VideoFromSearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    let videoWithData: YTVideoWithData
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    @Environment(RouterPath.self) private var routerPath
    private let tip = TapToSelectImageTip()
    var body: some View {
        Button {
            if VideoPlayerModel.shared.currentItem?.videoId != videoWithData.video.videoId {
                VideoPlayerModel.shared.loadVideo(video: videoWithData.video, thumbnailData: self.videoWithData.data.thumbnailData, channelAvatarImageData: self.videoWithData.data.channelAvatarData)
            }
            //                SheetsModel.shared.showSheet(.watchVideo)
            routerPath.presentedSheet = .miniPlayer(videoId: videoWithData.video.videoId)
            
        } label: {
            if let state = PSM.propetriesState[.videoViewMode] as? PreferencesStorageModel.Properties.VideoViewModes, state == .halfThumbnail {
                VideoView(videoWithData: videoWithData)
            } else {
                // Big thumbnail view by default
                VideoView2(videoWithData: videoWithData)
                   

            }
        }
        .padding(.horizontal, 5)
    }
}


#Preview {
    VideoFromSearchView(videoWithData: DummyData.videoWithData)
        .environment(\.colorScheme, .dark)
        .environmentObject(PreferencesStorageModel.shared)
        .environment(RouterPath())
}

struct DummyData {
    static let videoWithData = YTVideoWithData(
        video: Model.ytVideo,
        data: YTElementDataSet()
    )
}
