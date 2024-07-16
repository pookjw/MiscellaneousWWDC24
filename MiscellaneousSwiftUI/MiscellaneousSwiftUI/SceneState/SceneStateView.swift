//
//  SceneStateView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/17/24.
//

import SwiftUI

// TODO: onMoveCommand (tvOS)
// TODO: https://developer.apple.com/documentation/swiftui/environmentvalues/istabbarshowingsections?changes=latest_minor

// iOS : UITraitCollection.activeAppearance
// macOS에서만 의미 있음 나머지는 항상 true
// NSWindowDidResignKeyNotification NSWindowDidBecomeKeyNotification
struct SceneStateView: View {
    @Environment(\.appearsActive) private var appearsActive: Bool
    @State private var isPresented: Bool = false
    
    var body: some View {
        Button("Present") {
            isPresented = true
        }
        .alert("Alert", isPresented: $isPresented) {
            
        }
        .onChange(of: appearsActive, initial: true) { oldValue, newValue in
            print(newValue)
        }
    }
}

#Preview {
    SceneStateView()
}
