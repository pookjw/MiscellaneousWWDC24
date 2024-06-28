//
//  MiscellaneousSwiftUIApp.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

import SwiftUI

@main
struct MiscellaneousSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            DemoListView()
        }
        .defaultAppStorage(UserDefaults.standard)
        
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
    }
}
