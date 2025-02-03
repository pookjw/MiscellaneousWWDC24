//
//  ClockFaceView.swift
//  ClockPosterDemo
//
//  Created by Jinwoo Kim on 2/3/25.
//

import SwiftUI
import ClockPoster

struct ClockFaceView: UIViewControllerRepresentable {
    static func playFace(suggestedLooksHandler: (([ClockFaceLook]) -> ())? = nil) -> ClockFaceView {
        ClockFaceView(kind: .play, suggestedLooksHandler: suggestedLooksHandler)
    }
    
    static func solarFace(suggestedLooksHandler: (([ClockFaceLook]) -> ())? = nil) -> ClockFaceView {
        ClockFaceView(kind: .solar, suggestedLooksHandler: suggestedLooksHandler)
    }
    
    static func worldFace(suggestedLooksHandler: (([ClockFaceLook]) -> ())? = nil) -> ClockFaceView {
        ClockFaceView(kind: .world, suggestedLooksHandler: suggestedLooksHandler)
    }
    
    static func analogFace(suggestedLooksHandler: (([ClockFaceLook]) -> ())? = nil) -> ClockFaceView {
        ClockFaceView(kind: .analog, suggestedLooksHandler: suggestedLooksHandler)
    }
    
    static func digitalFace(suggestedLooksHandler: (([ClockFaceLook]) -> ())? = nil) -> ClockFaceView {
        ClockFaceView(kind: .digital, suggestedLooksHandler: suggestedLooksHandler)
    }
    
    private let kind: ClockFaceKind
    private let suggestedLooksHandler: (([ClockFaceLook]) -> ())?
    private var isDisplayStyleRedMode = false
    private var look: ClockFaceLook?
    
    private init(
        kind: ClockFaceKind,
        suggestedLooksHandler: (([ClockFaceLook]) -> ())?
    ) {
        self.kind = kind
        self.suggestedLooksHandler = suggestedLooksHandler
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.presentationViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isDisplayStyleRedMode != context.coordinator.isDisplayStyleRedMode {
            context.coordinator.isDisplayStyleRedMode = isDisplayStyleRedMode
        }
        
        if let look = look ?? context.coordinator.suggestedLooks.first,
           context.coordinator.look != look {
            context.coordinator.look = look
        }
    }
    
    func makeCoordinator() -> ClockFaceController {
        let configuration = ClockPosterConfiguration.configuration(from: nil, kind: kind)        
        let controller = ClockFaceController(with: configuration)
        
        if let suggestedLooksHandler {
            suggestedLooksHandler(controller.suggestedLooks)
        }
        
        return controller
    }
    
    func redMode(_ value: Bool) -> ClockFaceView {
        var copy = self
        copy.isDisplayStyleRedMode = value
        return copy
    }
    
    func look(_ look: ClockFaceLook?) -> ClockFaceView {
        var copy = self
        copy.look = look
        return copy
    }
}
