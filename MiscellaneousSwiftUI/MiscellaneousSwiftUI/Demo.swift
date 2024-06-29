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
    
#if os(macOS)
    case windowIdealSizeView
    case windowIdealPlacement
#endif
    
#if os(visionOS)
    case volumeWorldAlignment
    case defaultWorldScaling
#endif
    
#if os(macOS)
    case defaultLaunchBehavior
#endif
    
    case windowManagerRole
    case restorationBehavior
    case persistentSystemOverlays
    
#if os(macOS)
    case windowLevel
#endif
    
    var id: Int {
        rawValue
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
#if os(macOS) || os(visionOS)
        case .defaultWindowPlacement:
            DefaultWindowPlacementView()
#endif
            
#if os(macOS)
        case .windowIdealSizeView:
            WindowIdealSizeView()
        case .windowIdealPlacement:
            WindowIdealPlacementView()
#endif
            
#if os(visionOS)
        case .volumeWorldAlignment:
            VolumeWorldAlignmentView()
        case .defaultWorldScaling:
            DefaultWorldScalingView()
#endif
            
#if os(macOS)
        case .defaultLaunchBehavior:
            DefaultLaunchBehaviorView()
#endif
            
        case .windowManagerRole:
            WindowManagerRoleView()
        case .restorationBehavior:
            RestorationBehaviorView()
        case .persistentSystemOverlays:
            PersistentSystemOverlaysView()
            
#if os(macOS)
        case .windowLevel:
            WindowLevelView()
#endif
        }
    }
}
