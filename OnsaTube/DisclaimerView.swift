//
//  DisclaimerView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

import SwiftUI
import Env
import DesignSystem

@MainActor
struct DisclaimerView: View {
//    @AppStorage("hasAcceptedDisclaimer") var hasAcceptedDisclaimer: Bool = false
    @Environment(UserPreferences.self) private var userPreferences
    @Environment(Theme.self) private var theme

    var body: some View {
        VStack {
            Text("Disclaimer")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(theme.tintColor)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                  
                    Text("This app uses the YouTube API to display videos and other content. The content provided is available publicly on YouTube. We do not claim ownership of any of the content displayed in this app. All rights are reserved by their respective owners.")
                    
                    Text("By using this app, you agree to comply with YouTube's Terms of Service and acknowledge that you have read and understood YouTube's API Services Terms of Service.")
                    
                    Text("We are not responsible for any issues or risks associated with the use of this app. If you have any concerns or questions regarding the content, please contact YouTube or the content owner directly.")
                    
                    Text("For more information, please review the following:")
                        .fontWeight(.bold)
                    
                    Link(destination: URL(string: "https://www.youtube.com/t/terms")!) {
                        Label("• YouTube Terms of Service", systemImage: "info.circle")
                    }
                    
                    Link(destination: URL(string: "https://developers.google.com/youtube/terms/api-services-terms-of-service")!) {
                        Label("• YouTube API Services Terms of Service:", systemImage: "info.circle")
                    }
                    Link(destination: URL(string: "https://developer.apple.com/app-store/review/guidelines/")!) {
                        Label("• Apple App Store Review Guidelines:", systemImage: "info.circle")
                    }
                    
        }


            }
            .background(theme.primaryBackgroundColor)
            .padding(.horizontal, 16)
                        
            Button(action: {
                userPreferences.hasAcceptedDisclaimer.toggle()
            }) {
                Text("I Agree")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(theme.secondaryBackgroundColor)
                    .foregroundColor(theme.tintColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
            }
        }
        .background(theme.primaryBackgroundColor)
    }
}

#Preview {
    DisclaimerView()
        .withPreviewsEnv()
        .environment(Theme.shared)
}

