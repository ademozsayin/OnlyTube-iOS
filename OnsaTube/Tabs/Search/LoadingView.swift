//
//  LoadingView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import SwiftUI


struct LoadingView: View {
    var customText: String? = nil
    var body: some View {
        VStack() {
            ProgressView()
                .foregroundColor(.gray)
                .padding(.bottom, 0.3)
            Text(((customText == nil) ? "" : " ") + (customText?.uppercased() ?? ""))
                .foregroundColor(.gray)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
//        .frame(width: 160, height: 50)
        .frame(maxWidth: .infinity)
    }
}
