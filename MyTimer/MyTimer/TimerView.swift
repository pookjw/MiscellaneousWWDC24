//
//  TimerView.swift
//  MyTimer
//
//  Created by Jinwoo Kim on 7/29/24.
//

import SwiftUI

@_expose(Cxx, "makeTimerHostingController")
public func makeTimerHostingController(startDate: NSDate, endDate: NSDate) -> UIViewController {
    MainActor.assumeIsolated {
        let hostingController = UIHostingController(rootView: TimerView(timerInterval: (startDate as Date)...(endDate as Date)))
        return hostingController
    }
}

@_expose(Cxx, "updateTimerHostingController")
public func updateTimerHostingController(startDate: NSDate, endDate: NSDate, hostingController: UIViewController) {
    MainActor.assumeIsolated {
        (hostingController as! UIHostingController<TimerView>).rootView = TimerView(timerInterval: (startDate as Date)...(endDate as Date))
    }
}

struct TimerView: View {
    private let timerInterval: ClosedRange<Date>
    
    init(timerInterval: ClosedRange<Date>) {
        self.timerInterval = timerInterval
    }
    
    var body: some View {
        Text(
            timerInterval: timerInterval,
            pauseTime: nil,
            countsDown: true,
            showsHours: false
        )
        .contentTransition(.numericText(countsDown: true))
        .monospacedDigit()
        .transaction { t in
            t.animation = .default
        }
    }
}
