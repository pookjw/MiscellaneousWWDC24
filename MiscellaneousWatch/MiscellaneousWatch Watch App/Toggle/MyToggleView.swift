//
//  MyToggleView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

import SwiftUI

struct MyToggleView: View {
    @State private var isOn: Bool = true
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text("Label")
        }
    }
}

#Preview {
    MyToggleView()
}
