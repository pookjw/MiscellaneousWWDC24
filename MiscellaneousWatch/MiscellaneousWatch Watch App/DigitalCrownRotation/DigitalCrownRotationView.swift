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
            .digitalCrownAccessory(.automatic)
            .digitalCrownAccessory {
                Text("Accessory!")
            }
            .digitalCrownRotation(
//                detent: $rotation,
                $rotation,
                from: 0.0,
                through: 100.0,
//                by: 1.0,
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
//                print(newValue)
            }
    }
}

#Preview {
    DigitalCrownRotationView()
}
