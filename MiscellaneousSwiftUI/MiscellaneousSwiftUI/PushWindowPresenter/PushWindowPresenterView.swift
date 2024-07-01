//
//  PushWindowPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/1/24.
//

#if os(visionOS)

import SwiftUI

struct PushWindowPresenterView: View {
    @Environment(\.pushWindow) private var pushWindow: PushWindowAction
    
    var body: some View {
        Button("Open Window") { 
            pushWindow(id: "PushWindow")
        }
        .task {
            for child in Mirror(reflecting: pushWindow).children {
                print(child)
            }
        }
    }
}

#Preview {
    PushWindowPresenterView()
}

#endif
