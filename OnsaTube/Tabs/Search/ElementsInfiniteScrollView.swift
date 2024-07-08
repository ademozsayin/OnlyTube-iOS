//
//  ElementsInfiniteScrollView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import SwiftUI

struct ElementsInfiniteScrollView: View {
    @Binding var items: [YTElementWithData]
    @Binding var shouldReloadScrollView: Bool
    
    var fetchNewResultsAtKLast: Int = 5
    var shouldAddBottomSpacing = false
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    @ObservedObject private var NRM = NetworkReachabilityModel.shared
    
    var refreshAction: ((@escaping () -> Void) -> Void)?
    var fetchMoreResultsAction: (() -> Void)?
    var body: some View {
        let performanceMode = PSM.propetriesState[.performanceMode] as? PreferencesStorageModel.Properties.PerformanceModes
        if performanceMode == .limited {
            CustomElementsInfiniteScrollView(
                items: $items,
                shouldReloadScrollView: $shouldReloadScrollView,
                fetchNewResultsAtKLast: fetchNewResultsAtKLast,
                refreshAction: refreshAction,
                fetchMoreResultsAction: fetchMoreResultsAction
            )
        } else {
            DefaultElementsInfiniteScrollView(
                items: $items,
                shouldReloadScrollView: $shouldReloadScrollView,
                fetchNewResultsAtKLast: fetchNewResultsAtKLast,
                shouldAddBottomSpacing: shouldAddBottomSpacing,
                refreshAction: refreshAction,
                fetchMoreResultsAction: fetchMoreResultsAction
            )
        }
    }
}
