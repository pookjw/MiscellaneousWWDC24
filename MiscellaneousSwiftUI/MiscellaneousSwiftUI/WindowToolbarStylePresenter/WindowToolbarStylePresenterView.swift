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
        
        var body: some SwiftUI.Scene {
            WindowGroup(id: "WindowToolbarStyle") {
                Color.cyan
                    .toolbar {
                        Button {
//                            windowToolbarStyle = windowToolbarStyle.next()
                        } label: {
                            Label("Button", systemImage: "triangle.inset.filled")
                        }
                    }
            }
            
            // 일반적인 Toolbar - Title이랑 Toolbar Item이 같이 있음
//            .windowToolbarStyle(.automatic)
//            .windowToolbarStyle(.unified)
            
            // unified의 얇은 버전
            .windowToolbarStyle(.unifiedCompact)
            
            // Title 아래에 Toolbar가 나열되는 방식
//            .windowToolbarStyle(.expanded)
            
            .windowToolbarLabelStyle($windowToolbarLabelStyle)
            .onChange(of: windowToolbarLabelStyle, initial: false) { _, newValue in
                for child in Mirror(reflecting: UnifiedWindowToolbarStyle.unified(showsTitle: false)).children {
                    print(child)
                }
            }
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
