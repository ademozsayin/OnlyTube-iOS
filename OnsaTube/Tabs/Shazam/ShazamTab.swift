//
//  ShazamTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 30.06.2024.
//
//@State private var state: SHManagedSession.State = .idle

import SwiftUI
import DesignSystem
import Env

@MainActor
struct ShazamTab: View {
   
    
    @Environment(\.isSecondaryColumn) private var isSecondaryColumn: Bool
    @Environment(\.scenePhase) private var scenePhase

    @Environment(UserPreferences.self) private var userPreferences
    @Environment(Theme.self) private var theme

    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    
    @Binding var selectedTab: Tab
    @Binding var popToRootTab: Tab
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            GradientBackgroundAnimation {
                ShazamView()
                    .withAppRouter()
                    .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                    .toolbarBackground(theme.primaryBackgroundColor.opacity(0.30), for: .navigationBar)
            }
            
        }
        .onAppear {
        }
        .withSafariRouter()
        .environment(routerPath)
        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
            if newValue == .notifications {
                if routerPath.path.isEmpty {
                    scrollToTopSignal += 1
                } else {
                    routerPath.path = []
                }
            }
        }
    }
}


//#Preview {
//    ShazamTab()
//}
