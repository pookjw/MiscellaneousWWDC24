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
    init() {
        
    }
    
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { results in
            AnyView(TotalActivityView(results: results).onAppear(perform: {
                
            }))
        }
        // Add more reports here...
    }
}
