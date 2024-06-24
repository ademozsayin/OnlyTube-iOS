//
//  CustomAVPlayer.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 10.06.2024.
//

import AVKit

class CustomAVPlayer: AVQueuePlayer {
    func updateEndAction() {
        self.actionAtItemEnd = self.items().count < 2 ? .pause : .advance
    }
}
