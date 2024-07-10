//
//  LargeContentView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/10/24.
//

import SwiftUI

struct LargeContentView: View {
    @Environment(\.accessibilityLargeContentViewerEnabled) private var accessibilityLargeContentViewerEnabled: Bool
    
    var body: some View {
        Text("Hello, World!")
            .accessibilityShowsLargeContentViewer { 
                Label("Hello", systemImage: "ladybug.fill")
            }
            .onChange(of: accessibilityLargeContentViewerEnabled, initial: false) { _, newValue in
                print(accessibilityLargeContentViewerEnabled)
            }
    }
}

#Preview {
    LargeContentView()
}
