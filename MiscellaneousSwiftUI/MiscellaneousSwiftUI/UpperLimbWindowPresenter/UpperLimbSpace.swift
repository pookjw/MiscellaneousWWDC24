//
//  UpperLimbSpace.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/3/24.
//

import SwiftUI

struct UpperLimbSpace: Scene {
    let windowID: String
    
    init(windowID: String) {
        self.windowID = windowID
    }
    
    var body: some Scene {
        ImmersiveSpace(id: windowID) {
            Color.orange
                .upperLimbVisibility(UpperLimbWindowPresenterView.Model.shared.visibility2)
        }
        .upperLimbVisibility(UpperLimbWindowPresenterView.Model.shared.visibility)
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
