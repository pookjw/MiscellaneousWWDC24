//
//  MyTimerWidget_SwiftLiveActivity.swift
//  MyTimerWidget_Swift
//
//  Created by Jinwoo Kim on 7/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MyTimerWidget_SwiftAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MyTimerWidget_SwiftLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyTimerWidget_SwiftAttributes.self) { context in
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

extension MyTimerWidget_SwiftAttributes {
    fileprivate static var preview: MyTimerWidget_SwiftAttributes {
        MyTimerWidget_SwiftAttributes(name: "World")
    }
}

extension MyTimerWidget_SwiftAttributes.ContentState {
    fileprivate static var smiley: MyTimerWidget_SwiftAttributes.ContentState {
        MyTimerWidget_SwiftAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MyTimerWidget_SwiftAttributes.ContentState {
         MyTimerWidget_SwiftAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MyTimerWidget_SwiftAttributes.preview) {
   MyTimerWidget_SwiftLiveActivity()
} contentStates: {
    MyTimerWidget_SwiftAttributes.ContentState.smiley
    MyTimerWidget_SwiftAttributes.ContentState.starEyes
}
