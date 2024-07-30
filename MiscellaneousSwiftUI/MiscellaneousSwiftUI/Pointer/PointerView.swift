//
//  PointerView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/30/24.
//

#if os(macOS) || os(visionOS)

import SwiftUI

struct PointerView: View {
#if os(macOS)
    @State private var pointerVisibility: Visibility = .visible
#endif
    @State private var isStyledPointer = true
    
    var body: some View {
        VStack {
#if os(macOS)
            Button("Toggle Visibility") { 
                pointerVisibility.toggle()
            }
#endif
            
            Button("Toggle Pointer Style: \(isStyledPointer.description)") {
                isStyledPointer.toggle()
            }
        }
#if os(macOS)
        .pointerVisibility(pointerVisibility)
        .pointerStyle(isRowResizePointerStyle ? .rowResize : .default)
#else
        .pointerStyle(isStyledPointer ? .shape(.capsule, eoFill: true, size: CGSize(width: 300.0, height: 300.0)) : .default)
#endif
    }
}

extension Visibility {
    fileprivate mutating func toggle() {
        switch self {
        case .automatic:
            self = .visible
        case .visible:
            self = .hidden
        case .hidden:
            self = .visible
        }
    }
}

#Preview {
    PointerView()
}

#endif
