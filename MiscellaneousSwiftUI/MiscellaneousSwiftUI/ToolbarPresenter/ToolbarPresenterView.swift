//
//  ToolbarPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/1/24.
//

import SwiftUI

struct ToolbarPresenterView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") { 
            openWindow(id: "ToolbarPresenter")
        }
    }
}

#Preview {
    ToolbarPresenterView()
}
