//
//  WindowToolbarStylePresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/10/24.
//

#if os(macOS)

import SwiftUI

struct WindowToolbarStylePresenterView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Open Window") {
            openWindow(id: "WindowToolbarStyle")
        }
    }
}

extension WindowToolbarStylePresenterView {
    struct Scene: SwiftUI.Scene {
        @State private var windowToolbarLabelStyle: ToolbarLabelStyle = .titleAndIcon
        @State private var windowToolbarStyle: any WindowToolbarStyle = .expanded
        
        var body: some SwiftUI.Scene {
            WindowGroup(id: "WindowToolbarStyle") {
                Color.cyan
                    .toolbar {
                        Button {
                            windowToolbarStyle = windowToolbarStyle.next()
                        } label: {
                            Label("Button", systemImage: "triangle.inset.filled")
                        }
                    }
            }
            .windowToolbarStyle(windowToolbarStyle)
            .windowToolbarLabelStyle($windowToolbarLabelStyle)
            .onChange(of: windowToolbarLabelStyle, initial: false) { _, newValue in
                for child in Mirror(reflecting: UnifiedWindowToolbarStyle.unified(showsTitle: false)).children {
                    print(child)
                }
            }
        }
    }
}

extension Scene {
    @SceneBuilder
    fileprivate func any_windowToolbarStyle(_ style: any WindowToolbarStyle) -> some Scene {
        switch style {
        case let automatic as DefaultWindowToolbarStyle:
            self
                .windowToolbarStyle(automatic)
        case let unified as UnifiedWindowToolbarStyle:
            self
                .windowToolbarStyle(unified)
        default:
            self
                .windowToolbarStyle(.automatic)
        }
    }
}

extension WindowToolbarStyle {
    fileprivate func next() -> any WindowToolbarStyle {
        switch self {
        case is DefaultWindowToolbarStyle:
            return .unified(showsTitle: false)
        case let unified as UnifiedWindowToolbarStyle:
            let showsTitle: Bool = (Mirror(reflecting: unified).descendant("showsTitle") as? Bool) ?? false
            
            if !showsTitle {
                return .unified(showsTitle: true)
            } else {
                return .expanded
            }
        case is ExpandedWindowToolbarStyle:
            return .unifiedCompact(showsTitle: false)
        case let unifiedCompact as UnifiedCompactWindowToolbarStyle:
            let showsTitle: Bool = (Mirror(reflecting: unifiedCompact).descendant("showsTitle") as? Bool) ?? false
            
            if !showsTitle {
                return .unifiedCompact(showsTitle: true)
            } else {
                return .automatic
            }
        default:
            return .automatic
        }
    }
}

#Preview {
    WindowToolbarStylePresenterView()
}

#endif
