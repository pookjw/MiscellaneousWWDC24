//
//  WindowButtonsBehaviorPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/1/24.
//

#if os(macOS)

import SwiftUI

struct WindowButtonsBehaviorPresenterView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") { 
            openWindow(id: "WindowButtonsBehavior")
        }
    }
}

extension WindowButtonsBehaviorPresenterView {
    struct WindowView: View {
        @State private var dismissBehavior: WindowInteractionBehavior = .enabled
        @State private var fullscreenBehavior: WindowInteractionBehavior = .enabled
        @State private var minimizeBehavior: WindowInteractionBehavior = .enabled
        @State private var resizeBehavior: WindowInteractionBehavior = .enabled
        
        var body: some View {
            VStack {
                Button("Toggle dismissBehavior") { 
                    dismissBehavior = dismissBehavior.next()
                }
                
                Button("Toggle fullscreenBehavior") { 
                    fullscreenBehavior = fullscreenBehavior.next()
                }
                
                Button("Toggle minimizeBehavior") { 
                    minimizeBehavior = minimizeBehavior.next()
                }
                
                Button("Toggle resizeBehavior") { 
                    resizeBehavior = resizeBehavior.next()
                }
            }
            .windowDismissBehavior(dismissBehavior)
            .windowFullScreenBehavior(fullscreenBehavior)
            .windowMinimizeBehavior(minimizeBehavior)
            .windowResizeBehavior(resizeBehavior)
        }
    }
}

extension WindowInteractionBehavior: @retroactive Equatable {
    public static func ==(lhs: WindowInteractionBehavior, rhs: WindowInteractionBehavior) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    fileprivate var rawValue: String {
        guard let guts: Any = Mirror(reflecting: self).descendant("guts")  else {
            fatalError()
        }
        
        return String(describing: guts)
    }
    
    fileprivate func next() -> Self {
        switch self {
        case .enabled: 
            return .disabled
        case .disabled:
            return .enabled
        case .automatic: 
            return .disabled
        default:
            fatalError()
        }
    }
}

#Preview {
    WindowButtonsBehaviorPresenterView()
}

#endif
