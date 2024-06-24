//
//  ChannelView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 23.06.2024.
//

import SwiftUI
import YouTubeKit
import DesignSystem
import Env

struct ChannelView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath: RouterPath

    let channel: YTChannel
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack {
                    CachedAsyncImage(url: channel.thumbnails.last?.url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 125)
                            .shadow(radius: 3)
                            .padding(.trailing)
                    } placeholder: {
                        ZStack {
                            Circle()
                                .foregroundColor(.black)
                            ProgressView()
                        }
                        .frame(width: 125)
                    }
                    // Add badges
                }
                .frame(width: geometry.size.width * 0.5, height: 125, alignment: .center)
                VStack {
                    VStack {
                        Text(channel.name ?? "")
                    }
                    .foregroundColor(theme.labelColor)
                    .truncationMode(.tail)
                    .frame(height: 125)
                    Divider()
                    Text(channel.subscriberCount ?? "")
                        .foregroundColor(theme.labelColor)
                        .font(.footnote)
                        .opacity(0.5)
                        .bold()
                }
                .frame(width: geometry.size.width * 0.475, height: geometry.size.height)
                Spacer()
            }
            .onTapGesture {
                routerPath.navigate(to: .channelDetails(channel: .init(channelId: channel.channelId, name: channel.name, thumbnails: channel.thumbnails)))
            }
       
//            .routeTo(.channelDetails(channel: .init(channelId: channel.channelId, name: channel.name, thumbnails: channel.thumbnails)))
        }
        .contextMenu {
            Button(action: {
//                self.channel.showShareSheet()
            }, label: {
                Text("Share")
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
            })
        }
    }
}

//
//#Preview {
//    ChannelView()
//}
