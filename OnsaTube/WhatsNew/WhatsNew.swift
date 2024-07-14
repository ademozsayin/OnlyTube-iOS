//
//  WhatsNew.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.07.2024.
//

import Foundation
import SwiftUI

class WhatsNew {
    struct Announcement: Identifiable {
        let id = UUID()
        let version: String
        let header: () -> AnyView
        let title: String
        let message: String
        let buttonTitle: String
        let action: () -> Void
        let isEnabled: () -> Bool
        
        init(version: String,
             header: @autoclosure @escaping () -> AnyView,
             title: String, message: String,
             buttonTitle: String,
             action: @escaping () -> Void,
             isEnabled: @autoclosure @escaping () -> Bool) {
            self.version = version
            self.header = header
            self.title = title
            self.message = message
            self.buttonTitle = buttonTitle
            self.action = action
            self.isEnabled = isEnabled
        }
    }
    
    let announcements: [Announcement]
    let currentVersion: String
    let previousOpenedVersion: String?
    let lastWhatsNewShown: String?
    
    init(announcements: [Announcement] = Announcements().announcements, 
         previousOpenedVersion: String? = UserDefaults.standard.string(forKey: Constants_.UserDefaults.lastRunVersion), currentVersion: String = Settings.appVersion(),
         lastWhatsNewShown: String? = Settings.lastWhatsNewShown
    ) {
        self.announcements = announcements
        self.previousOpenedVersion = previousOpenedVersion?.majorMinor
        self.currentVersion = currentVersion.majorMinor
        self.lastWhatsNewShown = lastWhatsNewShown
    }
    
    
    /// Returns the announcement to be displayed if one is available
    var visibleAnnouncement: Announcement? {
        // Don't show any announcements if this is the first run of the app,
        // or if we've already checked the what's new for this version
        guard let previousOpenedVersion, previousOpenedVersion != currentVersion else {
            return nil
        }
        
        // Find the last announcement that:
        // - is enabled
        // - has not been shown already
        // - the target version is not before the last opened version, and not for a future version
        return announcements
            .last(where: {
                $0.isEnabled() &&
                $0.version != lastWhatsNewShown &&
                $0.version.inRange(of: previousOpenedVersion, upper: currentVersion)
            })
    }
}

private extension String {
    /// Given a semver string, ie.: "7.42", "7.43.0.1", "7.43.1"
    /// returns it in the format of MAJOR.MINOR
    /// Eg.: "7.43", "7.43.0.1" or "7.43.1" will return "7.43"
    var majorMinor: String {
        let splitVersion = split(separator: ".")
        
        guard let major = splitVersion[safe: 0],
              let minor = splitVersion[safe: 1] else {
            return self
        }
        
        return "\(major).\(minor)"
    }
    
    /// Returns whether the version is above the `lower` and equal to or below the `upper` bounds
    func inRange(of lower: String, upper: String) -> Bool {
        self > lower && self <= upper
    }
}

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct Constants_ {
    enum UserDefaults {
        static let lastRunVersion = "lastRunVersion"
    }
}
