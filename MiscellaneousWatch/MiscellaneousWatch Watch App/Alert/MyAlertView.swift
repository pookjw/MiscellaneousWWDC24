//
//  MyAlertView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

import SwiftUI

struct MyAlertView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        Button("Button") {
            isPresented = true
        }
        .alert("Title", isPresented: $isPresented) {
            Button("Done 1") {
                
            }
            Button("Done 2", role: .destructive) {
                
            }
        } message: {
            Text("Message")
        }

    }
}

#Preview {
    MyAlertView()
}
