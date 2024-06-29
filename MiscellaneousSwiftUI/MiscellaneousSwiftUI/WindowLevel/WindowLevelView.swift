//
//  WindowLevelView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/24.
//

#if os(macOS)

import SwiftUI
import AppKit

struct WindowLevelView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        
        Button("Open Window") {
            openWindow(id: "WindowLevel")
        }
    }
}

#Preview {
    WindowLevelView()
}

#endif
