//
//  WhatsNewView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.07.2024.
//

import SwiftUI
import DesignSystem

struct WhatsNewHosting: View {
    @Environment(Theme.self) private var theme

    var body: some View {
        TabView {
            ForEach(WhatsNew().announcements, id: \.id) {  announce in
                WhatsNewView(announcement:announce)
            }
            .background(theme.primaryBackgroundColor)
        }
        //            .tabViewStyle(.page)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Theme.self) private var theme
    
    let announcement: WhatsNew.Announcement
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                announcement.header()
            }
            VStack(spacing: 10) {
                
                Text(announcement.title)
                    .font(.title)
                    .foregroundStyle(theme.labelColor)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(announcement.message)
//                    .font(style: .subheadline)
                    .foregroundStyle(theme.labelColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .fixedSize(horizontal: false, vertical: true)
                Button(announcement.buttonTitle) {
//                    track(.whatsnewConfirmButtonTapped)
                    
                    // Trigger the action after we've dismissed the What's New
                    dismiss(completion: {
                        announcement.action()
                    })
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Maybe Later") {
                    dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.bottom, 5)
                .padding(.top, -5)
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .frame(minWidth: 300, maxWidth: 340)
        .background(theme.primaryBackgroundColor)
        .cornerRadius(5)
        .padding()
        .onAppear {
            Settings.lastWhatsNewShown = announcement.version
        }
    }
    
    private func dismiss(completion: (() -> Void)? = nil) {
       
    }
}

