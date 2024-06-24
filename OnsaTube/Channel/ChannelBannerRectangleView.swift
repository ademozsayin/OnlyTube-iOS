//
//  ChannelBannerRectangleView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

import SwiftUI
import DesignSystem

struct ChannelBannerRectangleView: View {
    @Environment(Theme.self) private var theme
    let channelBannerURL: URL?
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if channelBannerURL != nil {
                    CachedAsyncImage(url: channelBannerURL, content: { image in
                        image
                            .resizable()
                            .opacity(0.8)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width)
                    }, placeholder: {
                        ProgressView()
                    })
                } else {
                    Rectangle()
                        .foregroundColor(theme.labelColor)
                }
            }
        }
    }
}
