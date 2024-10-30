//
//  hjklLiveActivity.swift
//  hjkl
//
//  Created by Santi Ochoa on 10/21/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct hjklAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct hjklLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: hjklAttributes.self) { context in
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

extension hjklAttributes {
    fileprivate static var preview: hjklAttributes {
        hjklAttributes(name: "World")
    }
}

extension hjklAttributes.ContentState {
    fileprivate static var smiley: hjklAttributes.ContentState {
        hjklAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: hjklAttributes.ContentState {
         hjklAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: hjklAttributes.preview) {
   hjklLiveActivity()
} contentStates: {
    hjklAttributes.ContentState.smiley
    hjklAttributes.ContentState.starEyes
}
