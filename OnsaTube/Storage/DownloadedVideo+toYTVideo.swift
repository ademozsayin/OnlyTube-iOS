//
//  DownloadedVideo+toYTVideo.swift
//  Atwy
//
//  Created by Antoine Bollengier on 01.12.2023.
//

import Foundation
import YouTubeKit

public extension DownloadedVideo {
    func toYTVideo() -> YTVideo {
        return YTVideo(
            id: Int(self.timestamp?.timeIntervalSince1970 ?? 0), // Provide default value for nil timestamp
            videoId: self.videoId ?? "", // Provide default value for nil videoId
            title: self.title ?? "", // Provide default value for nil title
            channel: self.channel != nil ? .init(
                channelId: self.channel?.channelId ?? "", // Ensure channel is not nil before accessing channelId
                name: self.channel?.name ?? "" // Provide default value for nil channel name
            ) : nil,
            timePosted: self.timePosted,
            timeLength: self.timeLength
        )
    }
}
