//
//  VideoPlayer.swift
//  Atwy
//
//  Created by Antoine Bollengier on 24.11.22.
//

import Foundation
import AVKit
import SwiftUI

//#if !os(macOS)
import MediaPlayer
//#endif

#if canImport(UIKit)
import UIKit

struct PlayerViewController: UIViewControllerRepresentable {
    var player: CustomAVPlayer
    var showControls: Bool = true
    var controller: AVPlayerViewController
    
#if !os(macOS)
    var nowPlayingController = MPNowPlayingInfoCenter.default()
#endif
    
    var audioSession = AVAudioSession.sharedInstance()
    @ObservedObject private var VPM = VideoPlayerModel.shared
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    
    class Model: NSObject, AVPlayerViewControllerDelegate {
        private var isFullScreen: Bool = false
        private var mainPlayer: AVPlayerViewController? = nil
        private var backgroundObserver: NSObjectProtocol? = nil
        
        override init() {
            super.init()
            self.backgroundObserver = NotificationCenter.default.addObserver(
                forName: UIApplication.didEnterBackgroundNotification,
                object: nil,
                queue: nil,
                using: { [weak self] _ in
                    if let isFullscreen = self?.mainPlayer?.value(forKey: "avkit_isEffectivelyFullScreen") as? Bool {
                        self?.isFullScreen = isFullscreen
                    }
                }
            )
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self.backgroundObserver as Any)
        }
        
        func playerViewController(_ playerViewController: AVPlayerViewController,
                                  restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
            self.mainPlayer = playerViewController
            SheetsModel.shared.showSheet(.watchVideo)
            if isFullScreen { // restore the fullscreen state
                let fullScreenEnteringCompletionBlock: (@convention(block) () -> ()) = {
                    completionHandler(true)
                }
                playerViewController.perform(NSSelectorFromString("enterFullScreenAnimated:completionHandler:"), with: true, with: fullScreenEnteringCompletionBlock)
            } else {
                let fullScreenExitingCompletionBlock: (@convention(block) () -> ()) = {
                    completionHandler(true)
                }
                playerViewController.perform(NSSelectorFromString("exitFullScreenAnimated:completionHandler:"), with: true, with: fullScreenExitingCompletionBlock)
            }
        }
        
        func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator) {
            self.mainPlayer = playerViewController
            self.isFullScreen = true
        }
        
        func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator) {
            self.mainPlayer = playerViewController
            self.isFullScreen = false
            let isPlaying = playerViewController.player?.isPlaying ?? false
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                if isPlaying {
                    playerViewController.player?.play()
                }
            })
        }
    }
    
    func makeCoordinator() -> Model {
        return Model()
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        NotificationCenter.default.addObserver(
            forName: .atwyStopPlayer,
            object: nil,
            queue: nil,
            using: { _ in
                stopPlayer()
            }
        )
#if !os(visionOS)
        player.allowsExternalPlayback = true
#endif
        player.audiovisualBackgroundPlaybackPolicy = ((PSM.propetriesState[.backgroundPlayback] as? Bool) ?? true) ? .continuesIfPossible : .pauses
#if !os(visionOS)
        player.preventsDisplaySleepDuringVideoPlayback = true
#endif

        player.automaticallyWaitsToMinimizeStalling = true
        
#if !targetEnvironment(macCatalyst) && !os(visionOS)
        controller.allowsVideoFrameAnalysis = true
#endif
        controller.allowsPictureInPicturePlayback = true
        controller.canStartPictureInPictureAutomaticallyFromInline = (PSM.propetriesState[.automaticPiP] as? Bool) ?? true
        controller.exitsFullScreenWhenPlaybackEnds = true
        controller.showsPlaybackControls = showControls
        controller.updatesNowPlayingInfoCenter = true
        controller.player = player
        controller.delegate = context.coordinator
        
        PrivateManager.shared.avButtonsManager?.controlsView.menuState = .automatic // initialize it
        
        return controller
    }
    
    private func stopPlayer() {
        controller.player?.replaceCurrentItem(with: nil)
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#else

struct PlayerViewController: View {
    var player: CustomAVPlayer?
    var infos: TrackInformations?
    
    init(player: CustomAVPlayer?, infos: TrackInformations? = nil) {
        self.player = player
        self.infos = infos
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
        }
    }
}

#endif


