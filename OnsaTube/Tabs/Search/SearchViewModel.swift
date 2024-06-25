//
//  SearchViewModel.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 24.06.2024.
//

import Env
import Models
import Network
import Observation
import SwiftUI
import Firebase
import FirebaseDatabase

/// A view model class to manage search-related functionality.
/// It observes search data from a Firebase database and updates the UI accordingly.
/// This class is marked with `@MainActor` to ensure that all UI updates happen on the main thread.
@MainActor
@Observable class SearchViewModel {
    
    /// The index to scroll to in the UI.
    var scrollToIndex: Int?
    /// A reference to the Firebase database.
    private let database: DatabaseReference = Database.database().reference()
    
    /// The search text retrieved from the Firebase database.
    var search: String = "" 
    
    /// A flag to indicate whether scrolling to the top is visible.
    var scrollToTopVisible: Bool = false
    
    /// A flag to indicate whether scrolling to the index should be animated.
    var scrollToIndexAnimated: Bool = false
    
    /// Initializes a new instance of `SearchViewModel`.
    /// Sets the initial values for `scrollToIndex` and `scrollToIndexAnimated`.
    /// Starts observing the search data from Firebase.
    init() {
        self.scrollToIndexAnimated = true
        self.scrollToIndex = 100
        observeSearch()
    }
    
    /// Observes the search data from the Firebase database and updates the `search` property.
    /// This method listens for changes to the `search` node in the database.
    private func observeSearch() {
        database.observe(DataEventType.value, with: { [weak self] snapshot in
            guard let self = self,
                  let searchQuery = snapshot.value as? NSDictionary,
                  let searchText = searchQuery["search"] as? String,
                  !searchText.isEmpty else { return }
            self.search = searchText
        })
    }
}
