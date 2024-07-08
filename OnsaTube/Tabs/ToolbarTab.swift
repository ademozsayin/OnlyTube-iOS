//
//  ToolbarTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.06.2024.
//

//import AppAccount
import DesignSystem
import Env
import SwiftUI

@MainActor
struct ToolbarTab: ToolbarContent {
    @Environment(\.isSecondaryColumn) private var isSecondaryColumn: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(UserPreferences.self) private var userPreferences
    
    @Binding var routerPath: RouterPath
    
    var body: some ToolbarContent {
        if !isSecondaryColumn {
            ToolbarItem(placement: .topBarLeading) {
                if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
                    Button {
                        withAnimation {
                            userPreferences.isSidebarExpanded.toggle()
                        }
                    } label: {
                        if userPreferences.isSidebarExpanded {
                            Image(systemName: "sidebar.squares.left")
                        } else {
                            Image(systemName: "sidebar.left")
                        }
                    }
                }
            }
//            statusEditorToolbarItem(routerPath: routerPath,
//                                    visibility: userPreferences.postVisibility)
            if UIDevice.current.userInterfaceIdiom != .pad ||
                (UIDevice.current.userInterfaceIdiom == .pad && horizontalSizeClass == .compact)
            {
                ToolbarItem(placement: .navigationBarLeading) {
                    AppAccountsSelectorView(routerPath: routerPath)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    contentSettingsButton
                }
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad && horizontalSizeClass == .regular {
            if (!isSecondaryColumn && !userPreferences.showiPadSecondaryColumn) || isSecondaryColumn {
                SecondaryColumnToolbarItem()
            }
        }
    }
    
    private var contentSettingsButton: some View {
        Button {
            HapticManager.shared.fireHaptic(.buttonPress)
            routerPath.presentedSheet = .categorySelection
            
        } label: {
            Label("Content Selection", systemImage: "filemenu.and.selection")
        }
    }
}
