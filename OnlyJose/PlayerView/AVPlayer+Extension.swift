//
//  AVPlayer+Extension.swift
//  OnlyJose
//
//  Created by Adem Özsayın on 10.06.2024.
//

import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

