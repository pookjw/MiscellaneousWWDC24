//
//  DefaultWindowPlacementView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

#if os(macOS) || os(visionOS)
import SwiftUI

struct DefaultWindowPlacementView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                if key.hasPrefix("NSWindow Frame") {
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
            
            openWindow(id: "DefaultWindowPlacement")
        }
    }
}

#Preview {
    DefaultWindowPlacementView()
}
#endif
