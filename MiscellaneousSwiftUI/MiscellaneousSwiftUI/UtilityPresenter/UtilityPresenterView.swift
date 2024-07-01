//
//  UtilityPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/1/24.
//

#if os(macOS)

import SwiftUI

struct UtilityPresenterView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") { 
            openWindow(id: "Utility")
        }
    }
}

#Preview {
    UtilityPresenterView()
}

#endif
