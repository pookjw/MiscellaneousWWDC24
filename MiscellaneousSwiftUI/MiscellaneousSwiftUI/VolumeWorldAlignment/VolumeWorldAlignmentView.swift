//
//  VolumeWorldAlignmentView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

#if os(visionOS)

import SwiftUI

struct VolumeWorldAlignmentView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "VolumeWorldAlignment")
        }
    }
}

#Preview {
    VolumeWorldAlignmentView()
}

#endif
