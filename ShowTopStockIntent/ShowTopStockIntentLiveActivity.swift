import ActivityKit
import WidgetKit
import SwiftUI

struct ShowTopStockIntentAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ShowTopStockIntentLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShowTopStockIntentAttributes.self) { context in
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

extension ShowTopStockIntentAttributes {
    fileprivate static var preview: ShowTopStockIntentAttributes {
        ShowTopStockIntentAttributes(name: "World")
    }
}

extension ShowTopStockIntentAttributes.ContentState {
    fileprivate static var smiley: ShowTopStockIntentAttributes.ContentState {
        ShowTopStockIntentAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ShowTopStockIntentAttributes.ContentState {
         ShowTopStockIntentAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ShowTopStockIntentAttributes.preview) {
   ShowTopStockIntentLiveActivity()
} contentStates: {
    ShowTopStockIntentAttributes.ContentState.smiley
    ShowTopStockIntentAttributes.ContentState.starEyes
}
