//
//  YTVideo+.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import YouTubeKit
import SwiftUI

extension YTVideo {
    func withData(_ data: YTElementDataSet? = nil) -> YTVideoWithData {
        return YTVideoWithData(video: self, data: data ?? .init())
    }
}

extension YTVideo: ViewRepresentable {
    func getView() -> some View {
        Color.clear.frame(width: 0)
    }
}


public extension YTVideo {
    func showShareSheet(thumbnailData: Data? = nil) {
        let vc = UIActivityViewController(
            activityItems: [YTVideoShareSource(video: self, thumbnailData: thumbnailData)],
            applicationActivities: nil
        )
        SheetsModel.shared.showSuperSheet(withViewController: vc)
    }
}

