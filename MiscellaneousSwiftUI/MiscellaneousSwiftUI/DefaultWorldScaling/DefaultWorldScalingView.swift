//
//  DefaultWorldScalingView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

#if os(visionOS)

import SwiftUI

struct DefaultWorldScalingView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        VStack {
            Button("Open Window") {
                openWindow(id: "DefaultWorldScaling_1")
            }
            
            Button("Open Window") {
                openWindow(id: "DefaultWorldScaling_2")
            }
        }
    }
}

#Preview {
    DefaultWorldScalingView()
}

#endif
