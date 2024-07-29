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
    
#if !os(tvOS)
    case windowManagerRole
    case restorationBehavior
    case persistentSystemOverlays
#endif
    
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
    
#if !os(tvOS)
    case toolbarPresenter
#endif
    
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
    
#if os(iOS)
    case myDocumentLaunch
#endif
    
#if os(iOS)
    case cameraCaptureEvent
#endif
    
#if !os(tvOS)
    case rename
    case myTabPresenter
#endif
    
#if os(macOS)
    case myHSplit
    case myVSplit
#endif
    
#if !os(tvOS)
    case popoverPresenter
#endif
    
    case presentationSizing
    
#if os(macOS)
    case dismissalConfirmationDialogPresenter
#endif
    
    case confirmationDialogPresenter
    
#if !os(tvOS)
    case myToolbar
#endif
    
    case largeContent
    
#if os(macOS)
    case windowToolbarStylePresenter
#endif
    
    case searchable
    case focusedTextField
    
#if !os(tvOS)
    case focusedScenePresenter
#endif
    
#if os(macOS) || os(tvOS)
    case focusedTVMac
#endif
    
    case sceneState
    
#if os(visionOS)
    case worldTrackingLimitation
#endif
    
    case privacy
    case labelsHidden
    
#if os(macOS)
    case textInputCompletion
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
            
            
#if !os(tvOS)
        case .windowManagerRole:
            WindowManagerRoleView()
        case .restorationBehavior:
            RestorationBehaviorView()
        case .persistentSystemOverlays:
            PersistentSystemOverlaysView()
#endif
            
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
            
#if !os(tvOS)
        case .toolbarPresenter:
            ToolbarPresenterView()
#endif
            
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
            
#if os(iOS)
        case .myDocumentLaunch:
            MyDocumentLaunchView()
#endif
            
#if os(iOS)
        case .cameraCaptureEvent:
            CameraCaptureEventView()
#endif
            
#if !os(tvOS)
        case .rename:
            RenameView()
        case .myTabPresenter:
            MyTabPresenterView()
#endif
            
#if os(macOS)
        case .myHSplit:
            MyHSplitView()
        case .myVSplit:
            MyVSplitView()
#endif
            
#if !os(tvOS)
        case .popoverPresenter:
            PopoverPresenterView()
#endif
            
        case .presentationSizing:
            PresentationSizingView()
            
#if os(macOS)
        case .dismissalConfirmationDialogPresenter:
            DismissalConfirmationDialogPresenterView()
#endif
            
        case .confirmationDialogPresenter:
            ConfirmationDialogPresenterView()
            
#if !os(tvOS)
        case .myToolbar:
            MyToolbarView()
#endif
            
        case .largeContent:
            LargeContentView()
            
#if os(macOS)
        case .windowToolbarStylePresenter:
            WindowToolbarStylePresenterView()
#endif
            
        case .searchable:
            SearchableView()
        case .focusedTextField:
            FocusedTextFieldView()
            
#if !os(tvOS)
        case .focusedScenePresenter:
            FocusedScenePresenterView()
#endif
            
#if os(macOS) || os(tvOS)
        case .focusedTVMac:
            FocusedTVMacView()
#endif
            
        case .sceneState:
            SceneStateView()
            
#if os(visionOS)
        case .worldTrackingLimitation:
            WorldTrackingLimitationView()
#endif
            
        case .privacy:
            PrivacyView()
        case .labelsHidden:
            LabelsHiddenView()
        case .textInputCompletion:
            TextInputCompletionView()
        }
    }
}
