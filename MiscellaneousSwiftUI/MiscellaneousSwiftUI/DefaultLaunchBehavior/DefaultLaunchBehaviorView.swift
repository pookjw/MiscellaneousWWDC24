//
//  DefaultLaunchBehaviorView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

#if os(macOS)

import SwiftUI

struct DefaultLaunchBehaviorView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "DefaultLaunchBehavior")
        }
    }
}

#Preview {
    DefaultLaunchBehaviorView()
}

#endif
