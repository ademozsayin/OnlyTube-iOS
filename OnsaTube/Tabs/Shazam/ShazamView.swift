//
//  ShazamView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 1.07.2024.
//

import SwiftUI
import ShazamKit
import DesignSystem
import Env

@MainActor
struct ShazamView: View {
    
    @State private var shazamSession = SHManagedSession()
    @State private var lastResultDescription = ""
    @State private var lastMatch: SHMatch?
    @State private var isAnimating = false
    @State private var state: SHManagedSession.State = .idle
    @State private var recentlyShazamed: [SHMatch] = []
    
    @Environment(\.isSecondaryColumn) private var isSecondaryColumn: Bool
    @Environment(\.scenePhase) private var scenePhase
    
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(Theme.self) private var theme

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 1, pinnedViews: [.sectionHeaders], content: {
                Section {
                    VStack(spacing: 16) {
                        songList
                            .background(Color.red)
                    }
                } header: {
                    header
                        .zIndex(999)
                }
            })
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .clipped()
        .onDisappear {
            shazamSession.cancel()
        }
    }
    
    @MainActor private func handleShazamResult(_ result: SHSession.Result) {
        switch result {
            case .match(let match):
                print("match: ")
                print("- Title: \(match.mediaItems.first?.title ?? "-")")
                print("- Artist: \(match.mediaItems.first?.artist ?? "-")")
                lastResultDescription = "Match: \(match.mediaItems.first?.title ?? "-") by \(match.mediaItems.first?.artist ?? "-")"
                lastMatch = match
                recentlyShazamed.insert(match, at: 0) // Add to recently Shazamed list
                
            case .noMatch(_):
                print("no match")
                lastResultDescription = "No match"
            case .error(let error, _):
                print("error: \(error)")
                lastResultDescription = "Error: \(error.localizedDescription)"
        }
    }
    
    private func clearResults() {
        lastResultDescription = ""
        lastMatch = nil
    }
    
    private var shazamButton: some View {
        Button(action: {
            Task {
                if state == .matching {
                    shazamSession.cancel()
                    return
                }
                clearResults()
                print("start matching once")
                state = .matching
                let result = await shazamSession.result()
                handleShazamResult(result)
                state = .idle
            }
        }) {
            ZStack {
                if state == .matching {
                    RadialEffectView()
                        .frame(width: 200, height: 200)
                }
                Circle()
                    .fill(theme.tintColor)
                    .frame(width: 200, height: 200)
                    .shadow(radius: 10)
                
                Image(systemName: "shazam.logo")
                    .font(.system(size: 80))
                    .foregroundColor(theme.labelColor)
            }
            .frame(alignment: .center)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
        }
//        .disabled(state == .matching)
        .frame(alignment: .center)
    }
    
    private var header: some View {
        VStack {
            if state == .idle {
                Spacer()
            }
            
            shazamButton
            
            Text(state == .idle ? "Tap to Shazam" : "Tap to Cancel")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(theme.labelColor)
                .frame(alignment: .center)
            
            Text(lastResultDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
            
        }
        .padding(.leading, 8)
        .frame(maxWidth: .infinity)
    }
    
    private var songList: some View {
        ForEach(recentlyShazamed, id: \.self) { match in
            SpotifyNewReleaseCell(match: match)
                .background(Color.yellow)
                .cornerRadius(10)
        }
       
    }
}

#Preview {
    ShazamView()
        .withPreviewsEnv()
        .environment(Theme.shared)
}

struct SongRow: View {
    
    let match: SHMatch
    
    var body: some View {
        HStack {
            Image(systemName: "music.note")
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(match.mediaItems.first?.title ?? "Unknown Title")
                    .font(.headline)
                Text(match.mediaItems.first?.artist ?? "Unknown Artist")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                // Play action
            }) {
                Image(systemName: "play.circle")
                    .font(.title2)
            }
        }
        .padding(.vertical, 5)
    }
}

struct SongRowCell: View {
    
 
    var onCellPressed: (() -> Void)? = nil
    var onEllipsisPressed: (() -> Void)? = nil
    let match: SHMatch
    var body: some View {
        HStack(spacing: 0) {
            ChannelBannerRectangleView( channelBannerURL: match.mediaItems.first?.artworkURL)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(match.mediaItems.first?.title ?? "")
                    .font(.body)
                    .fontWeight(.medium)
                
               
                Text(match.mediaItems.first?.artist ?? "")
                        .font(.callout)
                
            }
           
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button(action: {
                // Play action
            }) {
                Image(systemName: "play.circle")
                    .font(.title2)
            }
        }
        .background(Color.black.opacity(0.001))
        .onTapGesture {
            onCellPressed?()
        }
    }
}



struct SpotifyNewReleaseCell: View {
    
    var headline: String? = "New release from"
    var subheadline: String? = "Some Artist"
    var title: String? = "Some Playlist"
    var subtitle: String? = "Single - title"
    var onAddToPlaylistPressed: (() -> Void)? = nil
    var onPlayPressed: (() -> Void)? = nil
    let match: SHMatch
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ChannelBannerRectangleView( channelBannerURL: match.mediaItems.first?.artworkURL)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    if let headline {
                        Text(headline)
                            .font(.callout)
                    }
                    
                    if let subheadline {
                        Text(subheadline)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ChannelBannerRectangleView( channelBannerURL: match.mediaItems.first?.artworkURL)
                    .frame(width: 140, height: 140)
                
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title {
                            Text(title)
                                .fontWeight(.semibold)
                        }
                        
                        if let subtitle {
                            Text(subtitle)
                        }
                    }
                    .font(.callout)
                    
                    HStack(spacing: 0) {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                            .padding(4)
                            .background(Color.black.opacity(0.001))
                            .onTapGesture {
                                onAddToPlaylistPressed?()
                            }
                            .offset(x: -4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                    }
                }
                .padding(.trailing, 16)
            }
            .cornerRadius(8)
            .onTapGesture {
                onPlayPressed?()
            }
        }
    }
}
