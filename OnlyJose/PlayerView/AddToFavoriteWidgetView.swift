//
//  AddToFavoriteWidgetView.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 20.06.2024.
//

import SwiftUI
import YouTubeKit

struct AddToFavoriteWidgetView: View {
    let video: YTVideo
    let imageData: Data?
    @ObservedObject private var PM = PersistenceModel.shared
    var body: some View {
        let isFavorite = PM.checkIfFavorite(video: video)
        
        Button {
            if isFavorite {
                PersistenceModel.shared.removeFromFavorites(video: video)
            } else {
                PersistenceModel.shared.addToFavorites(video: video, imageData: imageData)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .opacity(0.3)
                    .frame(height: 45)
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundStyle(.white)
            }
        }
    }
}
