//
//  YTPlaylist.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import YouTubeKit
import SwiftUI

extension YTPlaylist {
    func withData(_ data: YTElementDataSet? = nil) -> YTPlaylistWithData {
        return YTPlaylistWithData(playlist: self, data: data ?? .init())
    }
}

extension YTPlaylist: ViewRepresentable {
    func getView() -> some View {
        PlaylistView(playlist: self)
    }
}


extension YTPlaylist {
    func matchQuery(_ query: String) -> Bool {
        query == "" || !query.lowercased().components(separatedBy: " ").filter({$0 != ""}).contains(where: {!(title?.lowercased().contains($0) ?? false || channel?.name?.lowercased().contains($0) ?? false)})
    }
}
