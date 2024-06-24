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

@MainActor
@Observable class SearchViewModel {
    var scrollToIndex: Int?
    
    private(set) var timelineTask: Task<Void, Never>?
        
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
    }
    

  
    
    
}

// MARK: - Cache

// MARK: - StatusesFetcher

