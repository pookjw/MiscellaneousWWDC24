//
//  TotalActivityReport.swift
//  DeviceActivityReportExtension
//
//  Created by Jinwoo Kim on 4/25/25.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalActivity = Self("Total Activity")
}

struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: ([DeviceActivityData]) -> AnyView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [DeviceActivityData] {
        var results: [DeviceActivityData] = []
        
        for await result in data {
            results.append(result)
        }
        
        return results
    }
}
