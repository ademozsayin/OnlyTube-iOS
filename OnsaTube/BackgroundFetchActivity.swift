//
//  BackgroundFetchActivity.swift
//  Atwy
//
//  Created by Antoine Bollengier on 15.03.2024.
//  Copyright © 2024 Antoine Bollengier. All rights reserved.
//
#if !os(visionOS) && canImport(ActivityKit)
import ActivityKit

/// A protocol describing a Live Activity that regularly needs a background refresh.
@available(iOS 16.1, *)
protocol BackgroundFetchActivity: BackgroundFetchOperation {
    associatedtype ActivityAttributesType: ActivityAttributes
    
    /// A boolean indicating whether the activity can be launched or not.
    static var isEnabled: Bool { get }
    
    /// The type of activity, only one Live Activity per ActivityType can be scheduled in the ``LiveActivitesManager``.
    static var activityType: LiveActivitesManager.ActivityType { get }
    
    /// A handler that is called to know whether the background task should be rescheduled and if not, the activity will also be invalidated.
    static var shouldRescheduleCondition: () -> Bool { get }
    
    /// A handler that provides the new data for the Live Activity.
    static func getNewData() -> ActivityAttributesType.ContentState
    
    /// A function called to set up a new Live Activity.
    static func setupOnManager(attributes: ActivityAttributesType, state: ActivityAttributesType.ContentState)
    
    /// A function that will be called right after the activity has been activated and before the background task has been scheduled.
    static func setupSpecialStep(activity: Activity<ActivityAttributesType>)
    
    /// Stops the activity if it was activated.
    static func stop()
}
#endif
