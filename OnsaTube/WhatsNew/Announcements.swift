//
//  Announcements.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.07.2024.
//

import Foundation
import SwiftUI

struct Announcements {
    
    // Order is important.
    // In the case a user migrates to, let's say, 7.10 to 7.15 and
    // there were two announcements, the last one will be picked.
    var announcements: [WhatsNew.Announcement] = [
        // Autoplay
        .init(
            version: "1.2",
            header: AnyView(AutoplayWhatsNewHeader()),
            title: "Sleep Timer",
            message: "Enjoy a more convenient viewing experience with our app's sleep timer feature.Simply set the duration, and the timer will count down while you relax. If you fall asleep or get distracted, don't worry—the video will stop playing once the timer runs out, so your device won't keep playing content all night.",
            buttonTitle: "Try Now",
            action: {
                AnnouncementFlow.shared.isShowingAutoplayOption = true
                
//                NavigationManager.sharedManager.navigateTo(NavigationManager.settingsProfileKey, data: nil)
            },
            isEnabled: true
        ),
        .init(
            version: "1.2",
            header: AnyView(AutoplayWhatsNewHeader()),
            title: "Sleep Timer",
            message: "Enjoy a more convenient viewing experience with our app's sleep timer feature.Simply set the duration, and the timer will count down while you relax. If you fall asleep or get distracted, don't worry—the video will stop playing once the timer runs out, so your device won't keep playing content all night.",
            buttonTitle: "Try Now",
            action: {
                AnnouncementFlow.shared.isShowingAutoplayOption = true
                
                //                NavigationManager.sharedManager.navigateTo(NavigationManager.settingsProfileKey, data: nil)
            },
            isEnabled: true
        ),
        .init(
            version: "1.2",
            header: AnyView(AutoplayWhatsNewHeader()),
            title: "Sleep Timer",
            message: "Enjoy a more convenient viewing experience with our app's sleep timer feature.Simply set the duration, and the timer will count down while you relax. If you fall asleep or get distracted, don't worry—the video will stop playing once the timer runs out, so your device won't keep playing content all night.",
            buttonTitle: "Try Now",
            action: {
                AnnouncementFlow.shared.isShowingAutoplayOption = true
                
                //                NavigationManager.sharedManager.navigateTo(NavigationManager.settingsProfileKey, data: nil)
            },
            isEnabled: true
        )
    ]
}

class AnnouncementFlow {
    static let shared = AnnouncementFlow()
    
    var isShowingAutoplayOption = false
    var isShowingBookmarksOption = false
}
