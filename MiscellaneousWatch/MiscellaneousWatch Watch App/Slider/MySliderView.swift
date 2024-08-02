//
//  MySliderView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

import SwiftUI

struct MySliderView: View {
    @State private var value: Double = 0.5
    
    var body: some View {
        ScrollView(.vertical) {
            Slider(
                value: $value,
                in: 0.0...1.0,
                step: 0.1,
                label: {
                    Text("F")
                },
                minimumValueLabel: {
                    Text("Minus")
                },
                maximumValueLabel: {
                    Text("Plus")
                }
            )
            
                Slider(
                    value: $value,
                    in: 0.0...1.0,
                    step: 0.4,
                    label: {
                        Text("F")
                    }
                )
            
            Slider(
                value: $value,
                in: 0.0...1.0
            )
        }
    }
}

#Preview {
    MySliderView()
}
