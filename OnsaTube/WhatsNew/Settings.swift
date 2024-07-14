//
//  Settings.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.07.2024.
//


import UIKit

class Settings: NSObject {
    

    // MARK: - App Info
    
    @objc class func appVersion() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary, let shortVersion = infoDictionary["CFBundleShortVersionString"] as? String else {
            return "6.0" // this should never fail, but it's a nicer API to not return nil
        }
        
        return shortVersion
    }
//    
//    class func displayableVersion() -> String {
//#if STAGING
//        return L10n.appVersion(Settings.appVersion(), Settings.buildNumber()) + " - STAGING"
//#else
//        return L10n.appVersion(Settings.appVersion(), Settings.buildNumber())
//#endif
//    }
    
    class func buildNumber() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary, let buildNumber = infoDictionary[kCFBundleVersionKey as String] as? String else {
            return "1" // this should never fail, but it's a nicer API to not return nil
        }
        
        return buildNumber
    }
    
    
    // MARK: What's new
    
    private static let whatsNewLastAcknowledgedKey = "SJWhatsNewLastAcknowledged"
    
    class func setWhatsNewLastAcknowledged(_ value: Int) {
        UserDefaults.standard.set(value, forKey: whatsNewLastAcknowledgedKey)
    }
    
    class func whatsNewLastAcknowledged() -> Int {
        UserDefaults.standard.integer(forKey: whatsNewLastAcknowledgedKey)
    }
    
    
    private static let lastWhatsNewShownKey = "LastWhatsNewShown"
    class var lastWhatsNewShown: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: lastWhatsNewShownKey)
            UserDefaults.standard.synchronize()
        }
        
        get {
            UserDefaults.standard.string(forKey: lastWhatsNewShownKey)
        }
    }
}
