//
//  AlertView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 29.06.2024.
//

import Foundation
import DesignSystem
import SwiftUI

struct AlertView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Theme.self) private var theme
    
    let image: String
    let text: String
    let imageData: Data?
    @State private var displayIcon: Bool = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(theme.primaryBackgroundColor)
                .opacity(0.8)
            HStack {
                ZStack {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .animation(.easeIn, value: imageData != nil ? 0.3 : 0.0)
                        .foregroundColor(theme.tintColor)
                }
                Text(text)
                    .foregroundColor(theme.labelColor)
                    .font(.scaledHeadline)
            }
            .padding()
            .foregroundColor(theme.primaryBackgroundColor)
        }
        .frame(maxWidth: .infinity, maxHeight: 54)
        .onAppear {
            withAnimation {
                self.displayIcon = true
            }
        }
    }
}

struct PlayNextAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "text.line.first.and.arrowtriangle.forward", text: "Next", imageData: imageData)
    }
}

struct PlayLaterAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "text.line.last.and.arrowtriangle.forward", text: "Later", imageData: imageData)
    }
}

struct AddedToPlaylistAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "plus.circle", text: "Added", imageData: imageData)
    }
}

struct AddedFavoritesAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "star", text: "Added to favorites", imageData: imageData)
    }
}

struct DeletedDownloadAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "trash", text: "Deleted", imageData: imageData)
    }
}

struct ResumedDownloadAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "play", text: "Resumed", imageData: imageData)
    }
}

struct PausedDownloadAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "pause", text: "Paused", imageData: imageData)
    }
}

struct CancelledDownloadAlertView: View {
    let imageData: Data?
    var body: some View {
        AlertView(image: "multiply.circle", text: "Cancelled", imageData: imageData)
    }
}
