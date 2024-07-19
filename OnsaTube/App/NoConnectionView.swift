//
//  NoConnectionView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 19.07.2024.
//

import SwiftUI
import DesignSystem
//import

@MainActor
struct NoConnectionView: View {
    
    @Environment(Theme.self) private var theme
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding()
                .foregroundColor(theme.tintColor)
            Text(Localization.title)
                .font(.scaledTitle)
            Text(Localization.subtitle)
                .font(.scaledBody)
                .foregroundStyle(.gray)
                .padding(.bottom)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        .background(theme.primaryBackgroundColor)
    }
}

extension NoConnectionView {
    enum Localization {
        static let title =  NSLocalizedString("You are disconnected.", comment: "")
        static let subtitle =  NSLocalizedString("Disable the plane mode or connect to a WiFi.", comment: "")

    }
}
