//
//  OnsaTubeWidgetsLiveActivity.swift
//  OnsaTubeWidgets
//
//  Created by Adem Özsayın on 20.06.2024.
//
#if !os(visionOS) && canImport(ActivityKit)

import ActivityKit
import WidgetKit
import SwiftUI

struct OnsaTubeWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OnsaTubeWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OnsaTubeWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension OnsaTubeWidgetsAttributes {
    fileprivate static var preview: OnsaTubeWidgetsAttributes {
        OnsaTubeWidgetsAttributes(name: "World")
    }
}

extension OnsaTubeWidgetsAttributes.ContentState {
    fileprivate static var smiley: OnsaTubeWidgetsAttributes.ContentState {
        OnsaTubeWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OnsaTubeWidgetsAttributes.ContentState {
         OnsaTubeWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OnsaTubeWidgetsAttributes.preview) {
   OnsaTubeWidgetsLiveActivity()
} contentStates: {
    OnsaTubeWidgetsAttributes.ContentState.smiley
    OnsaTubeWidgetsAttributes.ContentState.starEyes
}

#endif
