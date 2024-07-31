//
//  DigitalCrownRotationView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 7/31/24.
//

import SwiftUI

struct DigitalCrownRotationView: View {
    @State private var rotation: Double = .zero
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .focusable()
            .digitalCrownAccessory(.visible)
            .digitalCrownAccessory {
                Text("Accessory!")
            }
            .digitalCrownRotation(
                $rotation,
                from: 0.0,
                through: 10.0,
                sensitivity: .high,
                isContinuous: true,
                isHapticFeedbackEnabled: true,
                onChange: { event in
                    print(event)
                },
                onIdle: {
                    
                }
            )
            .onChange(of: rotation) { oldValue, newValue in
                print(newValue)
            }
    }
}

#Preview {
    DigitalCrownRotationView()
}
