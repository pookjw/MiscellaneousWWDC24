//
//  RestorationBehaviorView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

#if !os(tvOS)

import SwiftUI

struct RestorationBehaviorView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "RestorationBehavior")
        }
    }
}

#Preview {
    RestorationBehaviorView()
}

#endif
