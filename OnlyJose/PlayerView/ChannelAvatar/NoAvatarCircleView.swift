//
//  NoAvatarCircleView.swift
//  Atwy
//
//  Created by Antoine Bollengier on 18.04.2024.
//  Copyright © 2024 Antoine Bollengier (github.com/b5i). All rights reserved.
//  

import Foundation
import SwiftUI

struct NoAvatarCircleView: View {
    let makeGradient: (UIImage) -> Void
    var body: some View {
//        Text("UAV")
        UnknownAvatarView()
            .task {
                let renderer = ImageRenderer(content: UnknownAvatarView())
                if let uiImage = renderer.uiImage {
                    makeGradient(uiImage)
                }
            }
    }
}


struct UnknownAvatarView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .foregroundStyle(.gray)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                    .frame(width: geometry.size.width * 0.5)
            }
        }
        .clipShape(Circle())
    }
}
