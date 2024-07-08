//
//  DismissalConfirmationDialogPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/9/24.
//

#if os(macOS)

import SwiftUI

// Window 닫으려고 하면 Confirmation 뜸
struct DismissalConfirmationDialogPresenterView: View {
    @State private var isPresented = false
    
    var body: some View {
        Button("Present") {
            isPresented = true
        }
        .dismissalConfirmationDialog("Alert!!!", shouldPresent: isPresented) {
            Button("Foo") {
                
            }
        } message: {
            Text("Message")
        }

    }
}

#Preview {
    DismissalConfirmationDialogPresenterView()
}

#endif
