//
//  ConfirmationDialogPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/9/24.
//

import SwiftUI

struct ConfirmationDialogPresenterView: View {
    @State private var isPresnted: Bool = false
    
    var body: some View {
        Button("Present") {
            isPresnted = true
        }
        .confirmationDialog("Test", isPresented: $isPresnted, titleVisibility: .visible) {
            Button("Done?") {
                
            }
        } message: {
            Text("Hello World!")
        }

    }
}

#Preview {
    ConfirmationDialogPresenterView()
}
