//
//  MyTimerWidget_SwiftControl.swift
//  MyTimerWidget_Swift
//
//  Created by Jinwoo Kim on 7/29/24.
//

import AppIntents
import SwiftUI
import WidgetKit

struct MyTimerWidget_SwiftControl: ControlWidget {
    static let kind: String = "com.pookjw.MyTimer.MyTimerWidget_Swift"

    var body: some ControlWidgetConfiguration {
//        AppIntentControlConfiguration(
//            kind: Self.kind,
//            provider: Provider()
//        ) { value in
//            ControlWidgetToggle(
//                "Start Timer",
//                isOn: value.isRunning,
//                action: StartTimerIntent(value.name),
//                valueLabel: { isRunning in
//                    Label(isRunning ? "On" : "Off", systemImage: "timer")
//                }
//            )
//        }
//        .displayName("Timer")
//        .description("A an example control that runs a timer.")
        
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetButton(action: StartTimerIntent(value.name)) { 
                Text(value.name)
            }
        }
        .displayName("Timer")
        .description("A an example control that runs a timer.")
        
//        AppIntentControlConfiguration(kind: Self.kind, intent: TimerConfiguration.self) { configuration in
//            ControlWidgetButton(action: configuration) { 
//                Text(configuration.timerName)
//            }
//        }
        
//        StaticControlConfiguration(kind: Self.kind) { 
//            ControlWidgetButton(action: StartTimerIntent("FFF")) { 
//                Text("Foo 2!")
//            }
//        }
    }
}

extension MyTimerWidget_SwiftControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            MyTimerWidget_SwiftControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return MyTimerWidget_SwiftControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static var title: LocalizedStringResource { "Timer Name Configuration" }

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static var openAppWhenRun: Bool {
        false
    }
    
    static var title: LocalizedStringResource { "Start a timer" }

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        try await Task.sleep(for: .seconds(2))
        return .result()
    }
}
