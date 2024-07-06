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
    case blendedWindow
    case alertScenePresenter
    case windowBackgroundDragBehavior
#endif
    
#if os(visionOS)
    case volumeViewpointChange
#endif
    
#if os(macOS)
    case settingsPresenter
    case utilityPresenter
#endif
    
    case toolbarPresenter
    
#if os(visionOS)
    case pushWindowPresenter
#endif
    
#if os(macOS)
    case windowVisibilityTogglePresenter
    case windowButtonsBehaviorPresenter
#endif
    
#if os(visionOS)
    case progressiveImmersionWindowPresenter
    case upperLimbWindowPresenter
    case immersiveEnvironmentPicker
    case fullScreenVideoPlayer
#endif
    
#if os(iOS) || os(visionOS)
    case myDocumentLaunch
#endif
    
#if os(iOS)
    case cameraCaptureEvent
#endif
    
    case rename
    case myTabPresenter
    
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
        case .blendedWindow:
            BlendedWindowView()
        case .alertScenePresenter:
            AlertScenePresenterView()
        case .windowBackgroundDragBehavior:
            WindowBackgroundDragBehaviorView()
#endif
            
#if os(visionOS)
        case .volumeViewpointChange:
            VolumeViewpointChangeView()
#endif
            
#if os(macOS)
        case .settingsPresenter:
            SettingsPresenterView()
        case .utilityPresenter:
            UtilityPresenterView()
#endif
            
        case .toolbarPresenter:
            ToolbarPresenterView()
            
#if os(visionOS)
        case .pushWindowPresenter:
            PushWindowPresenterView()
#endif
            
#if os(macOS)
        case .windowVisibilityTogglePresenter:
            WindowVisibilityTogglePresenterView()
        case .windowButtonsBehaviorPresenter:
            WindowButtonsBehaviorPresenterView()
#endif
            
#if os(visionOS)
        case .progressiveImmersionWindowPresenter:
            ProgressiveImmersionWindowPresenterView()
        case .upperLimbWindowPresenter:
            UpperLimbWindowPresenterView()
        case .immersiveEnvironmentPicker:
            ImmersiveEnvironmentPickerView()
        case .fullScreenVideoPlayer:
            FullScreenVideoPlayerView()
#endif
            
#if os(iOS) || os(visionOS)
        case .myDocumentLaunch:
            MyDocumentLaunchView()
#endif
            
#if os(iOS)
    case .cameraCaptureEvent:
        CameraCaptureEventView()
#endif
            
        case .rename:
            RenameView()
        case .myTabPresenter:
            MyTabPresenterView()
        }
    }
}
