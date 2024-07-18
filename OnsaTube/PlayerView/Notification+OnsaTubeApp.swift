//
//  Notification+Name.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 10.06.2024.
//

import Foundation

extension Notification.Name {
    static let atwyCoreDataChanged = Notification.Name("CoreDataChanged")
    
    static let atwyCookiesSetUp = Notification.Name("CookiesSetUp")
    
    static let atwyDownloadingsChanged = Notification.Name("DownloadingsChanged")
    
    static let atwyNoDownloadingsLeft = Notification.Name("NoDownloadingsLeft")
    
    static let atwyGetCookies = Notification.Name("GetCookies")
    
    static let atwyResetCookies = Notification.Name("ResetCookies")
    
    static let atwyStopPlayer = Notification.Name("StopPlayer")
    
    static let atwyAVPlayerEnded = Notification.Name("AVPlayerEnded")
    
    static let atwyPopup = Notification.Name("Popup")
    
    static let atwyDismissPlayerSheet = Notification.Name("DismissPlayerSheet")
    
    static func atwyDownloadingChanged(for videoId: String) -> Notification.Name { return .init("DownloadingChanged\(videoId)") }
    
    static let reloadVideo = Notification.Name("reloadVideo")

}
