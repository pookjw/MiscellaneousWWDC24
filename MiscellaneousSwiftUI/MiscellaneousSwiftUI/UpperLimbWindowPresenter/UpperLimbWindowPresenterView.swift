//
//  UpperLimbWindowPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/3/24.
//

import SwiftUI

struct UpperLimbWindowPresenterView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace: OpenImmersiveSpaceAction
    
    var body: some View {
        VStack {
            Button("Open Window") {
                Task {
                    await openImmersiveSpace(id: "UpperLimb")
                }
            }
            
            Button("Show") {
                Model.shared.visibilityForWindow.toggle()
            }
            
            Button("Hide") {
                Model.shared.visibilityForView.toggle()
            }
        }
    }
}

extension UpperLimbWindowPresenterView {
    @MainActor
    @Observable
    final class Model {
        static let shared: Model = .init()
        
        private init() {}
        
        var visibilityForWindow: Visibility = .automatic
        var visibilityForView: Visibility = .automatic
    }
}

extension Visibility {
    fileprivate mutating func toggle() {
        switch self {
        case .automatic:
            self = .visible
        case .visible:
            self = .hidden
        case .hidden:
            self = .automatic
        }
    }
}

#Preview {
    UpperLimbWindowPresenterView()
}
