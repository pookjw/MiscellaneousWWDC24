//
//  WindowIdealSizeView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

#if os(macOS)

import SwiftUI

struct WindowIdealSizeView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "WindowIdealSize")
        }
    }
}

#Preview {
    WindowIdealSizeView()
}

#endif
