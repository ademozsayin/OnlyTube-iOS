//
//  YTElementDataSet.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import Foundation
import YouTubeKit

struct YTElementDataSet: Hashable {
    static func == (lhs: YTElementDataSet, rhs: YTElementDataSet) -> Bool {
        return lhs.allowChannelLinking == rhs.allowChannelLinking && (lhs.removeFromPlaylistAvailable == nil) == (rhs.removeFromPlaylistAvailable == nil) && lhs.channelAvatarData == rhs.channelAvatarData && lhs.thumbnailData == rhs.thumbnailData
    }
    
    var allowChannelLinking: Bool = true
    
    var removeFromPlaylistAvailable: (() -> Void)? = nil
    
    var channelAvatarData: Data? = nil
    
    var thumbnailData: Data? = nil
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.allowChannelLinking)
        hasher.combine(self.removeFromPlaylistAvailable == nil)
        hasher.combine(self.channelAvatarData)
        hasher.combine(self.thumbnailData)
    }
}
