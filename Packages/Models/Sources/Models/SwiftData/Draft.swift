import Foundation
import SwiftData
import SwiftUI

@Model
final public class Draft {
    public var content: String = ""
    public var creationDate: Date = Date()
    
    public init(content: String) {
        self.content = content
        creationDate = Date()
    }
}

extension Draft: Identifiable, Hashable {
    public static func == (lhs: Draft, rhs: Draft) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(content)
    }
}

@Model public class TagGroup: Equatable {
    public var title: String = ""
    public var symbolName: String = ""
    public var tags: [String] = []
    public var creationDate: Date = Date()
    
    public init(title: String, symbolName: String, tags: [String]) {
        self.title = title
        self.symbolName = symbolName
        self.tags = tags
        creationDate = Date()
    }
}
