//
//  MiscellaneousSwiftUIApp.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
import CoreGraphics
#endif

@main
struct MiscellaneousSwiftUIApp: App {
    @State private var persistentSystemOverlaysVisibility: Visibility = .hidden
    @State private var windowLevel: WindowLevel = .normal
    
    var body: some Scene {
        WindowGroup {
            DemoListView()
        }
        .defaultAppStorage(UserDefaults.standard)
//        .defaultLaunchBehavior(.suppressed)
        
        
#if os(macOS)
        // WindowGroup은 닫혀도 앱이 살아 있지만 Window는 닫히면 앱이 죽음. WindowGroup 코드 다 지우고 Window만 있는채로 앱 실행하면 알 수 있음
        Window("", id: "DefaultWindowPlacement") { 
            Text("Hello World!")
        }
        .defaultWindowPlacement { content, context in
            var displaySize: CGSize = context.defaultDisplay.bounds.size
            displaySize.width *= 0.5
            displaySize.height *= 0.5
            let size: CGSize = content.sizeThatFits(ProposedViewSize(displaySize))
            
            return WindowPlacement(x: 100.0, y: 100.0, width: size.width, height: size.height)
        }
#elseif os(visionOS)
        WindowGroup("Hello", id: "DefaultWindowPlacement") { 
            Text("Hello World!")
        }
        .defaultWindowPlacement { content, context in
            /*
             이게 먼저 불리고
             -[UIApplication activateSceneSessionForRequest:errorHandler:]이 불리면서
             
             x2의 UISceneSessionActivationRequest의 options (UIWindowSceneActivationRequestOptions)의 mrui_placementParameters (MRUILaunchPlacementParameters)에서
             
             -[MRUILaunchPlacementParameters setPreferredPlacementTarget:]
             -[MRUILaunchPlacementParameters setPreferredLaunchPosition:]
             
             등
             */
            
            return WindowPlacement.init(.leading(context.windows.first!) ,size: CGSize(width: 300.0, height: 300.0))
        }
#endif
        
#if os(macOS)
        // Title을 Double Click 할 때 크기
        Window("", id: "WindowIdealSize") {
            Text("Hello World!")
                .frame(idealWidth: 800, idealHeight: 600)
        }
        .windowIdealSize(.fitToContent)
        
        // MARK: - WindowIdealPlacement
        
        // Title을 Double Click 할 때 위치와 크기
        Window("", id: "WindowIdealPlacement") {
            Text("Hello World!")
        }
        .windowIdealPlacement { content, context in
            return WindowPlacement(x: 100.0, y: 100.0, width: 300.0, height: 300.0)
        }
#endif
        
#if os(visionOS)
        WindowGroup(id: "VolumeWorldAlignment") {
            Color.orange
        }
        .windowStyle(.volumetric)
        .volumeWorldAlignment(.gravityAligned)
        
        WindowGroup(id: "DefaultWorldScaling_1") {
            Color.cyan
        }
        .windowStyle(.volumetric)
        .defaultWorldScaling(.automatic)
        
        WindowGroup(id: "DefaultWorldScaling_2") {
            Color.cyan
        }
        .windowStyle(.volumetric)
        .defaultWorldScaling(.dynamic)
#endif
        
#if os(macOS)
        // Dock Icon을 누를 때 이 Window를 띄운다.
        Window("", id: "DefaultLaunchBehavior") {
            Text("Hello World!")
        }
        .defaultLaunchBehavior(.presented)
        
        Window("", id: "WindowManagerRole") {
            Text("Hello World!")
        }
        .windowManagerRole(.principal)
#endif
        
        WindowGroup(id: "RestorationBehavior") {
            Text("Hello World!")
        }
#if os(macOS)
        .restorationBehavior(.disabled)
#endif
        
        WindowGroup(id: "PersistentSystemOverlays") {
            Button("Toggle") {
                switch persistentSystemOverlaysVisibility {
                case .hidden:
                    persistentSystemOverlaysVisibility = .visible
                case .visible:
                    persistentSystemOverlaysVisibility = .hidden
                case .automatic:
                    fatalError()
                }
            }
        }
        .persistentSystemOverlays(persistentSystemOverlaysVisibility)
        
#if os(macOS)
        Window("", id: "WindowLevel") {
            Button("Toggle") {
                var copy: WindowLevel = windowLevel
                
                withUnsafeMutablePointer(to: &copy) { ptr in
                    ptr.withMemoryRebound(to: Int32.self, capacity: 1) { pointer in
                        switch pointer.pointee {
                        case kCGNormalWindowLevel:
                            pointer.pointee = kCGUtilityWindowLevel
                        default:
                            pointer.pointee = kCGNormalWindowLevel
                        }
                    }
                }
                
                self.windowLevel = copy
                
//                switch windowLevel {
//                case .normal:
//                    windowLevel = .desktop
//                case .desktop:
//                    windowLevel = .floating
//                case .floating:
//                    windowLevel = .normal
//                default:
//                    fatalError()
//                }
            }
        }
        .windowLevel(windowLevel)
#endif
    }
}