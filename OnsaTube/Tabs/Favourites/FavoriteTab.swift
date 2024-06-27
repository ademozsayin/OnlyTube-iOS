//
//  FavoriteTab.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 27.06.2024.
//

import DesignSystem
import Env
import Foundation
import Models
import Network
import Nuke
import SwiftData
import SwiftUI


@MainActor
struct FavoriteTab: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme
    
    @State private var routerPath = RouterPath()
    @Binding var popToRootTab: Tab
    
        
    var body: some View {
        NavigationStack(path: $routerPath.path) {
         Text("FavoriteTab")
        }
    }
   
}
