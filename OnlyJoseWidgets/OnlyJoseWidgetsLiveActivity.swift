//
//  OnlyJoseWidgetsLiveActivity.swift
//  OnlyJoseWidgets
//
//  Created by Adem Özsayın on 20.06.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OnlyJoseWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OnlyJoseWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OnlyJoseWidgetsAttributes.self) { context in
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

extension OnlyJoseWidgetsAttributes {
    fileprivate static var preview: OnlyJoseWidgetsAttributes {
        OnlyJoseWidgetsAttributes(name: "World")
    }
}

extension OnlyJoseWidgetsAttributes.ContentState {
    fileprivate static var smiley: OnlyJoseWidgetsAttributes.ContentState {
        OnlyJoseWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OnlyJoseWidgetsAttributes.ContentState {
         OnlyJoseWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OnlyJoseWidgetsAttributes.preview) {
   OnlyJoseWidgetsLiveActivity()
} contentStates: {
    OnlyJoseWidgetsAttributes.ContentState.smiley
    OnlyJoseWidgetsAttributes.ContentState.starEyes
}
