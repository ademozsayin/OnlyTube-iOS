//
//  AddToFavoritesButtonView.swift
//  Atwy
//
//  Created by Antoine Bollengier on 14.03.2024.
//  Copyright © 2024 Antoine Bollengier. All rights reserved.
//

import SwiftUI
import YouTubeKit
import TipKit
import Env

struct AddToFavoritesButtonView: View {
    let video: YTVideo
    let imageData: Data?
    @ObservedObject private var PM = PersistenceModel.shared
    @Environment(AuthenticationManager.self) private var authenticationManager
    @Environment(RouterPath.self) private var routerPath

    private let tip = TapToSelectImageTip()
    var body: some View {
        
        let isFavorite = PM.checkIfFavorite(video: video)
        Button {
            if !authenticationManager.isAuth {
                routerPath.presentedSheet = .login
            } else {
                if isFavorite {
                    PersistenceModel.shared.removeFromFavorites(video: video)
                } else {
                    PersistenceModel.shared.addToFavorites(video: video, imageData: imageData)
                }
            }
       
        } label: {
            
            Image(systemName: isFavorite ? "star.fill" : "star")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .popoverTip(tip)
            
        }
    }
}

