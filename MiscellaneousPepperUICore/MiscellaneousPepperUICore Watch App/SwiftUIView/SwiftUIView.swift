//
//  SwiftUIView.swift
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 10/14/24.
//

@preconcurrency import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Text("Hello from SwiftUI!")
    }
}

@_expose(Cxx)
public nonisolated func makeHostingController() -> NSObject {
    return MainActor.assumeIsolated {
        let hostingController: (any NSObject & _UIHostingViewable) = _makeUIHostingController(
            AnyView(
                SwiftUIView()
            ),
            tracksContentSize: true
        )
        
        return hostingController
    }
}

#Preview {
    SwiftUIView()
}
