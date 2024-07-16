//
//  BlendedWindowView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/24.
//

#if os(macOS)

import SwiftUI

struct BlendedWindowView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "BlendedWindow")
        }
    }
}

extension BlendedWindowView {
    struct Scene: SwiftUI.Scene {
        @State private var materialActiveAppearance: MaterialActiveAppearance = .automatic
        
        var body: some SwiftUI.Scene {
            Window("Test", id: "BlendedWindow") {
                VStack {
                    ContentView()
//                        .containerBackground(.thickMaterial, for: .window)
                        .containerBackground(Material.regular.materialActiveAppearance(materialActiveAppearance), for: .window)
                    
                    Button("Switch") {
                        materialActiveAppearance.next()
                    }
                }
            }
        }
    }
    
    fileprivate struct ContentView: View {
            @Environment(\.materialActiveAppearance) private var materialActiveAppearance: MaterialActiveAppearance
        
        var body: some View {
            HStack {
                Color.clear
                    .frame(width: 100.0)
                
                Color.orange
                    .opacity(0.5)
                    .gesture(WindowDragGesture()) // https://x.com/_silgen_name/status/1807406184984682794
            }
            .ignoresSafeArea()
            .toolbar(removing: .title)
            .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            .onChange(of: materialActiveAppearance, initial: false) { oldValue, newValue in
                // 안 불림
                print(newValue)
            }
        }
    }
}

extension MaterialActiveAppearance {
    fileprivate mutating func next() {
        switch self {
        case .active:
            self = .automatic
        case .automatic:
            self = .inactive
        case .inactive:
            self = .matchWindow
        case .matchWindow:
            self = .active
        default:
            fatalError()
        }
    }
}

#Preview {
    BlendedWindowView()
}

#endif
