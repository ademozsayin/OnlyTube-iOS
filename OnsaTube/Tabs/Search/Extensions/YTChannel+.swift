//
//  YTChannel+.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import SwiftUI
import YouTubeKit

extension YTChannel: ViewRepresentable {
    func getView() -> some View {
        ChannelView(channel: self)
    }
}
