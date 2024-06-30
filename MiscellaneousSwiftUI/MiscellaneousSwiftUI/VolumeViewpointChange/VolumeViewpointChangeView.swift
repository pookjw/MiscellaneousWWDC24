//
//  VolumeViewpointChangeView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/1/24.
//

#if os(visionOS)

import SwiftUI

struct VolumeViewpointChangeView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "VolumeViewpointChange")
        }
    }
}

#Preview {
    VolumeViewpointChangeView()
}

#endif
