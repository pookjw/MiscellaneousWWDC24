//
//  TotalActivityView.swift
//  DeviceActivityReportExtensionObjC
//
//  Created by Jinwoo Kim on 4/25/25.
//

import SwiftUI

struct TotalActivityView: View {
    let totalActivity: String
    
    var body: some View {
        VStack {
            Color.orange.frame(width: 100, height: 100)
            Text(totalActivity)
        }
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    TotalActivityView(totalActivity: "1h 23m")
}
