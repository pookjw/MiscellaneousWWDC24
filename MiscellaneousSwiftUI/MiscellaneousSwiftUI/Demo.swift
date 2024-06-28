//
//  Demo.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

import SwiftUI

enum Demo: Int, Identifiable, CaseIterable {
#if os(macOS) || os(visionOS)
    case defaultWindowPlacement
#endif
    
    var id: Int {
        rawValue
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case .defaultWindowPlacement:
            DefaultWindowPlacementView()
        }
    }
}
