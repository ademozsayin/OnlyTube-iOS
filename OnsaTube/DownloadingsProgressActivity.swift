//
//  DownloadingsProgressActivity.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

#if !os(visionOS) && canImport(ActivityKit)
import ActivityKit

@available(iOS 16.1, *)
struct DownloadingsProgressActivity: BackgroundFetchActivity {
    typealias ActivityAttributesType = DownloadingsProgressAttributes
    
    static var isEnabled: Bool {
        return (PreferencesStorageModel.shared.propetriesState[.liveActivitiesEnabled] as? Bool) ?? true
    }
    
    static let activityType: LiveActivitesManager.ActivityType = .downloadingsProgress
    
    static let identifier: String = "agency.fiable.OnsaTube.DownloadingsProgressUpdate"
    
    static let fetchInterval: Double = 5
    
    static func taskOperation() {
        DownloadingsModel.shared.refreshDownloadingsProgress()
    }
    
    static var shouldRescheduleCondition: () -> Bool = {
        return DownloadingsModel.shared.activeDownloadingsCount != 0
    }
    
    static func getNewData() -> DownloadingsProgressAttributes.DownloadingsState {
        return .modelState
    }
    
    static func setupSpecialStep(activity: Activity<ActivityAttributesType>) {
        let observer = DownloadingsModel.shared.downloadersChangePublisher.sink(receiveValue: { [weak DM = DownloadingsModel.shared, weak activity] newState in
            guard let DM = DM, let activity = activity, DM.activeDownloadingsCount != 0 else {
                Task {
                    await LiveActivitesManager.shared.stopActivity(type: Self.self)
                }
                return
            }
            
            LiveActivitesManager.shared.updateActivity(withNewState: newState, activity: activity)
        })
        
        LiveActivitesManager.shared.activitiesObservers.updateValue(observer, forKey: Self.activityType)
    }
}
#endif
