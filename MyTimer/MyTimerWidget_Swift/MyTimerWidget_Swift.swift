//
//  MyTimerWidget_Swift.swift
//  MyTimerWidget_Swift
//
//  Created by Jinwoo Kim on 7/29/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TimerWidgetEntry {
        TimerWidgetEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TimerWidgetEntry {
        TimerWidgetEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TimerWidgetEntry> {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        return Timeline(entries: entries, policy: .atEnd)
        return .init(entries: [.init(date: .now, configuration: configuration)], policy: .never)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
    
    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
        .init([.init(configuration: .init(), context: .hardware(headphones: .connected))])
    }
}

struct TimerWidgetEntry: TimelineEntry {
    init(date: Date, configuration: ConfigurationAppIntent) {
        let timerStartDate: Date
        let timerEndDate: Date
        
        let userDefaults = UserDefaults.appGroup
        if let _timerStartDate = userDefaults.timerStartDate,
           let _timerEndDate = userDefaults.timerEndDate {
            timerStartDate = _timerStartDate
            timerEndDate = _timerEndDate
        } else {
            timerStartDate = .now
            timerEndDate = timerStartDate.addingTimeInterval(7200.0)
        }
        
        self.timeIntervals = timerStartDate...timerEndDate
        self.date = date
        self.configuration = configuration
    }
    
    let timeIntervals: ClosedRange<Date>
    
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MyTimerWidget_SwiftEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(
                timerInterval: entry.timeIntervals,
                pauseTime: nil,
                countsDown: true,
                showsHours: false
            )
            .contentTransition(.numericText(countsDown: true))
            .monospacedDigit()
            .transaction { t in
                t.animation = .default
            }

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct MyTimerWidget_Swift: Widget {
    let kind: String = "MyTimerWidget_Swift"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyTimerWidget_SwiftEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
//                .containerBackground(.fill.tertiary, for: .widget)
            
        }
//        ._containerBackgroundRemovable(true)
        .promptsForUserConfiguration()
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryRectangular, .accessoryInline, .accessoryCircular])
    }
}
