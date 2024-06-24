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

@MainActor
@Observable class SearchViewModel {
    var scrollToIndex: Int?
    
    private(set) var timelineTask: Task<Void, Never>?
        
    private let database = Database.database().reference()
    var search: String = "" {
        didSet {
            print("search getted from firebase: \(search)")
        }
    }
    
    var scrollToTopVisible: Bool = false {
        didSet {
            if scrollToTopVisible {
//                pendingStatusesObserver.pendingStatuses = []
            }
        }
    }
  
    
    var isTimelineVisible: Bool = false
    var scrollToIndexAnimated: Bool = false
    
    init() {
//        pendingStatusesObserver.scrollToIndex = { [weak self] index in
            self.scrollToIndexAnimated = true
            self.scrollToIndex = 100
//        }
        observeData()

    }
    
    private func observeData() {
        database.observe(DataEventType.value, with: { [weak self] snapshot in
            guard let self = self else { return }
            print(snapshot)
            if let value = snapshot.value as? [String: Any],
               let searchValue = value["search"] as? String {
                print("The search value is: \(searchValue)")
                self.search = searchValue
            } else {
                print("The snapshot value is not a dictionary or 'search' key is missing.")
            }
        })
    }
}

// MARK: - Cache

// MARK: - StatusesFetcher
