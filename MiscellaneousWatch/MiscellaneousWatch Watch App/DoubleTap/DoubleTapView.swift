//
//  DoubleTapView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 10/4/24.
//

import SwiftUI

struct DoubleTapView: View {
    var body: some View {
        Button("Button") {
            print("Foo")
        }
        .handGestureShortcut(.primaryAction)
    }
}

#Preview {
    DoubleTapView()
}
