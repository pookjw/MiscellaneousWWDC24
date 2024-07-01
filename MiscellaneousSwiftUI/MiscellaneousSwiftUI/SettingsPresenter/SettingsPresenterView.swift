//
//  SettingsPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/1/24.
//

#if os(macOS)

import SwiftUI

struct SettingsPresenterView: View {
    @Environment(\.openSettings) private var openSettings: OpenSettingsAction
    
    var body: some View {
        VStack { 
            Button("Open Settings") { 
                openSettings()
            }
            
            SettingsLink() // DefaultSettingsLinkLabel
            
            SettingsLink {
                Text("Foo?")
            }
        }
    }
}

#Preview {
    SettingsPresenterView()
}

#endif
