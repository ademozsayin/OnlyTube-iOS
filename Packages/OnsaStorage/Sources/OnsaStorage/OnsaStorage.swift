// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftData
import YouTubeKit
import UIKit
import SwiftData


class PersistenceModel: ObservableObject {
    static let shared = PersistenceModel()
    
        
    private init() {
      
    }
    
    
    struct PersistenceData: Identifiable {
        typealias VideoIdAndLocation = (videoId: String, storageLocation: URL)
        
        var id = UUID()
        var downloadedVideoIds: [VideoIdAndLocation]
        var favoriteVideoIds: [String]
        
        mutating func addDownloadedVideo(videoId: String, storageLocation: URL) {
            self.downloadedVideoIds.append((videoId, storageLocation))
            self.id = UUID()
        }
        
        mutating func removeDownloadedVideo(videoId: String) {
            self.downloadedVideoIds.removeAll(where: { $0.videoId == videoId })
            self.id = UUID()
        }
        
        mutating func replaceDownloadedVideoURLAtIndex(_ index: Int, by newStorageLocation: URL) {
            if downloadedVideoIds.count > index {
                self.downloadedVideoIds[index].storageLocation = newStorageLocation
                self.id = UUID()
            }
        }
        
        mutating func addFavoriteVideo(videoId: String) {
            self.favoriteVideoIds.append(videoId)
            self.id = UUID()
        }
        
        mutating func removeFavoriteVideo(videoId: String) {
            self.favoriteVideoIds.removeAll(where: { $0 == videoId })
            self.id = UUID()
        }
    }
}
