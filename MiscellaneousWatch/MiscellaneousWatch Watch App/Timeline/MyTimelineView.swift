//
//  MyTimelineView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

import SwiftUI

struct MyTimelineView: View {
    var body: some View {
        TimelineView(PeriodicTimelineSchedule(from: Date(), by: 1.0/60.0)) { context in
            switch context.cadence {
            case .live:
                Text("\(Date.now)")
            case .seconds:
                Text("\(Date.now)")
            case .minutes:
                Text("\(Date.now)")
            @unknown default:
               fatalError("*** Received an unknown cadence: \(context.cadence) ***")
            }
        }
    }
}

#Preview {
    MyTimelineView()
}
