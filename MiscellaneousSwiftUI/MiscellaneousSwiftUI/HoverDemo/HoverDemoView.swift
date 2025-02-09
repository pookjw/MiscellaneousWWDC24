//
//  HoverDemoView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 2/9/25.
//

import SwiftUI

struct HoverDemoView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .hoverEffect(.highlight)
            .hoverEffect { effect, isActive, _ in
                effect.scaleEffect(isActive ? 1.5 : 1.0)
            }
    }
}

#Preview {
    HoverDemoView()
}
