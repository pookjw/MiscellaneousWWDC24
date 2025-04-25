//
//  DeviceActivityReportExtension.swift
//  DeviceActivityReportExtension
//
//  Created by Jinwoo Kim on 4/25/25.
//

import DeviceActivity
import SwiftUI

@main
struct DeviceActivityReportExtension: DeviceActivity.DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
