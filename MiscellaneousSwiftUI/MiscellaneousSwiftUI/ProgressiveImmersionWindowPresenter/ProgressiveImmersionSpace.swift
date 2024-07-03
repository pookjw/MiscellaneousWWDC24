//
//  ProgressiveImmersionSpace.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/2/24.
//

import SwiftUI

struct ProgressiveImmersionSpace: Scene {
    let windowID: String
    
    init(windowID: String) {
        self.windowID = windowID
    }
    
    var body: some Scene {
        ImmersiveSpace(id: windowID) {
            Color
                .orange
                .frame(width: 10_000.0, height: 10_000.0)
                .onImmersionChange { context in
                    print(context.amount)
                }
        }
//        .immersiveContentBrightness(.custom(Model.shared.immersiveContentBrightness)) // Simulator라 차이 없는듯
        .immersiveContentBrightness(.dim)
//        .immersionStyle(selection: .constant(.progressive(0...1.0, initialAmount: 0.1)), in: .progressive(0...1.0, initialAmount: 0.1))
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}

extension ProgressiveImmersionSpace {
    @Observable
    @MainActor
    final class Model {
        static let shared: Model = .init()
        
        var maxProgressiveAmount: Double = 0.1
        var immersiveContentBrightness: Double = 0.1
        
        private init() {}
    }
}
