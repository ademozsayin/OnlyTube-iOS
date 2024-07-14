//
//  SleepTimerView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 13.07.2024.
//

import SwiftUI
import DesignSystem
import Env

@MainActor
struct SleepTimerView: View {
    
    @Environment(\.dismiss) private var dismiss

    @Environment(Theme.self) private var theme
//    @Environment(RouterPath.self) private var routerPath
    @ObservedObject private var VPM = VideoPlayerModel.shared
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { reader in
                if VPM.sleepTimerOn {
                    activeSleepTimerView
                } else {
                    listSleepTimer
                }
            }
            .toolbar {
                CancelToolbarItem()
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(VPM.sleepTimerOn  ? "" : "Sleep Timer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(theme.secondaryBackgroundColor)
    }
    
    private var listSleepTimer:  some View {
        List {
            ForEach(SleepTimerValues.allCases, id: \.rawValue) { item in
                Button {
                    VPM.setSleepTimerInterval(item.value)
                    VPM.sleepTimerOn = true
                    VPM.updateSleepRemainingTime()
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.body)
                            .lineLimit(10)
                            .foregroundStyle(theme.labelColor)
                    }
                }
                .padding(.vertical, 16)
                .listRowBackground(theme.primaryBackgroundColor)
                
            }
        }
    }
    
    private var activeSleepTimerView: some View {
        VStack(spacing: 16) {
            let tintColor = theme.tintColor
            Spacer()
            
            SleepTimerButtonRepresentable(sleepTimerOn: $VPM.sleepTimerOn, tintColor: .constant(UIColor(tintColor)))
                .frame(width: 150, height: 150)
              
            Text(VPM.timeRemaining)
                .largeTitleStyle()
            
            Button {
                VPM.sleepTimerOn = false
                VPM.sleepTimeRemaining = -1
                VPM.resetSleepTimer()
                dismiss()
            } label: {
                Text("Cancel Timer")
            }
            .buttonStyle(PrimaryLoadingButtonStyle(isLoading: false))
            .padding(.top, 16)
            .buttonStyle(PrimaryButtonStyle())
            .padding()
            Spacer()
        }
    }

}


enum SleepTimerValues: String, CaseIterable {
    
//    case one
    case five
    case fifteen
    case thirty
    case oneHour
    
    var value: TimeInterval {
        switch self {
//            case .one :
//                1.minutes
            case .five:
                5.minutes
            case .fifteen:
                15.minutes
            case .thirty:
                30.minutes
            case .oneHour:
                1.hour
        }
    }
    
    var name: String {
        switch self {
//            case .one:
//                "1 minute"
            case .five:
                return NSLocalizedString("5 minutes", comment: "")
            case .fifteen:
                return NSLocalizedString("15 minutes", comment: "")
            case .thirty:
                return NSLocalizedString("30 minutes", comment: "")
            case .oneHour:
                return NSLocalizedString("1 Hour", comment: "")
        }
    }
}

public class TimeFormatter {
    public static let shared = TimeFormatter()
    
    private lazy var colonFormatterMinutes: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter
    }()
    
    private lazy var colonFormatterHours: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter
    }()
    
    private lazy var shortFormatMinutes: DateComponentsFormatter = {
        localizedFormatter(style: .abbreviated, allowedUnits: [.minute])
    }()
    
    private lazy var shortFormatHours: DateComponentsFormatter = {
        localizedFormatter(style: .abbreviated, allowedUnits: [.hour])
    }()
    
    private lazy var shortTimeFormatter: DateComponentsFormatter = {
        localizedFormatter(style: .abbreviated, allowedUnits: [.minute, .hour])
    }()
    
    private lazy var subMinuteFormatter: DateComponentsFormatter = {
        localizedFormatter(style: .abbreviated, allowedUnits: [.second])
    }()
    
    private lazy var appleFormatterSeconds: DateComponentsFormatter = {
        localizedFormatter(style: .full, allowedUnits: [.second])
    }()
    
    private lazy var appleFormatterMinutes: DateComponentsFormatter = {
        localizedFormatter(style: .full, allowedUnits: [.minute])
    }()
    
    private lazy var appleFormatterHours: DateComponentsFormatter = {
        localizedFormatter(style: .full, allowedUnits: [.hour])
    }()
    
    private lazy var appleFormatterDays: DateComponentsFormatter = {
        localizedFormatter(style: .full, allowedUnits: [.day])
    }()
    
    private lazy var appleFormatterYears: DateComponentsFormatter = {
        localizedFormatter(style: .full, allowedUnits: [.year])
    }()
    
    private lazy var minutesHoursFormatter: DateComponentsFormatter = {
        localizedFormatter(style: .full, allowedUnits: [.hour, .minute])
    }()
    
    private lazy var minutesHoursFormatterMedium: DateComponentsFormatter = {
        localizedFormatter(style: .short, allowedUnits: [.hour, .minute])
    }()
    
    public func playTimeFormat(time: TimeInterval, showSeconds: Bool = true) -> String {
        if time.isNaN || !time.isFinite { return "0:00" }
        
        if time < 1.hours {
            let formatter = showSeconds ? colonFormatterMinutes : shortFormatMinutes
            return formatter.string(from: time) ?? "0:00"
        }
        
        let formatter = showSeconds ? colonFormatterHours : shortTimeFormatter
        return formatter.string(from: time) ?? "0:00"
    }
    
    public func singleUnitFormattedShortestTime(time: TimeInterval) -> String {
        if time.isNaN || !time.isFinite { return "" }
        
        if time < 1.minutes {
            return subMinuteFormatter.string(from: time) ?? ""
        } else if time < 1.hours {
            return shortFormatMinutes.string(from: time) ?? ""
        } else {
            return shortFormatHours.string(from: time) ?? ""
        }
    }
    
    public func multipleUnitFormattedShortTime(time: TimeInterval) -> String {
        if time.isNaN || !time.isFinite { return "" }
        
        if time < 60.seconds {
            return subMinuteFormatter.string(from: time) ?? ""
        }
        
        return shortTimeFormatter.string(from: time) ?? ""
    }
    
    public func minutesHoursFormatted(time: TimeInterval) -> String {
        if time.isNaN || !time.isFinite { return "" }
        
        return minutesHoursFormatter.string(from: time) ?? ""
    }
    
    public func minutesFormatted(time: TimeInterval) -> String {
        if time.isNaN || !time.isFinite { return "" }
        
        return appleFormatterMinutes.string(from: time) ?? ""
    }
    
    private lazy var relativeFormatter = RelativeDateTimeFormatter()
    
    public func appleStyleElapsedString(date: Date) -> String {
        relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    public func appleStyleTillString(date: Date) -> String? {
        let time = date.timeIntervalSinceNow
        var timeStr: String?
        if time <= 1.minute {
            timeStr = appleFormatterSeconds.string(from: time)
        } else if time <= 1.hour {
            timeStr = appleFormatterMinutes.string(from: time)
        } else if time <= 1.days {
            timeStr = appleFormatterHours.string(from: time)
        } else if time <= 365.days {
            timeStr = appleFormatterDays.string(from: time)
        } else {
            timeStr = appleFormatterYears.string(from: time)
        }
        
        return timeStr
    }
    
    public class func currentUTCTimeInMillis() -> Int64 {
        Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    private func createUsFormatter(allowedUnits: NSCalendar.Unit) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = allowedUnits
        formatter.zeroFormattingBehavior = [.dropAll]
        
        return formatter
    }
    
    private func localizedFormatter(style: DateComponentsFormatter.UnitsStyle, allowedUnits: NSCalendar.Unit) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = style
        formatter.allowedUnits = allowedUnits
        formatter.zeroFormattingBehavior = [.dropAll]
        
        return formatter
    }
}
