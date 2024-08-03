//
//  MyStepperView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

import SwiftUI

struct MyStepperView: View {
    @State private var value: Double = .zero
    
    var body: some View {
        Stepper("Title", value: $value, in: 0...1.0, step: 0.1, format: .percent, onEditingChanged: { finished in print(finished) })
    }
}

#Preview {
    MyStepperView()
}
