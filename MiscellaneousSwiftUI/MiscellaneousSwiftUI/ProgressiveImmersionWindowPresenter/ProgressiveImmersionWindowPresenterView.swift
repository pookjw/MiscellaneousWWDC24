//
//  ProgressiveImmersionWindowPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/2/24.
//

#if os(visionOS)

import SwiftUI

struct ProgressiveImmersionWindowPresenterView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace: OpenImmersiveSpaceAction
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace: DismissImmersiveSpaceAction
    
    var body: some View {
        VStack {
            Button("Open Window") {
                Task {
                    await openImmersiveSpace(id: "Progressive")
                }
            }
            
            Button("Dismiss Window") {
                Task {
                    await dismissImmersiveSpace()
                }
            }
            
            Stepper(
                "Max", 
                value: .init(
                    get: { 
                        ProgressiveImmersionSpace.Model.shared.maxProgressiveAmount
                    },
                    set: { newValue in
                        ProgressiveImmersionSpace.Model.shared.maxProgressiveAmount = newValue
                    }
                ),
                in: 0.1...1.0, 
                step: 0.1
            )
        }
    }
}

#Preview {
    ProgressiveImmersionWindowPresenterView()
}

#endif
