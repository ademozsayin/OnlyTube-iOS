//
//  Item.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 5.06.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
