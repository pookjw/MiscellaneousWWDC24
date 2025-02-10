//
//  RealityBoxView.swift
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

import SwiftUI
import RealityKit

@_expose(Cxx)
public nonisolated func newRealityBoxViewHostingController() -> UIViewController {
    MainActor.assumeIsolated {
        UIHostingController(rootView: RealityBoxView())
    }
}

struct RealityBoxView: View {
    @State private var service = RealityBoxService()
    
    var body: some View {
        GeometryReader3D { geometry in
            RealityView { content in
                service.configureRealityView(content: &content, boundingBox: bondingBox(content: &content, proxy: geometry))
            } update: { content in
                service.updateRealityView(content: &content, boundingBox: bondingBox(content: &content, proxy: geometry))
            }
        }
    }
    
    private func bondingBox(content: inout RealityViewContent, proxy: GeometryProxy3D) -> BoundingBox {
        let localFrame: Rect3D = proxy.frame(in: .local)
        let sceneFrame: BoundingBox = content.convert(localFrame, from: .local, to: .scene)
        return sceneFrame
    }
}

#Preview {
    RealityBoxView()
}
