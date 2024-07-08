//
//  MyToolbarView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/9/24.
//

import SwiftUI

struct MyToolbarView: View {
    @State private var text: String = "Hello!"
    
    var body: some View {
        TextEditor(text: $text)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(id: "1", placement: .keyboard) {
                    Button("♦️", action: {})
                }
                
                ToolbarItemGroup(placement: .navigation) {
                    Button("1", action: {})
                    Button("2", action: {})
                    Button("3", action: {})
                } label: {
                    Text("Group!")
                }

                ToolbarTitleMenu {
                    Button("Title Menu!") {
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle($text)
            .toolbarRole(.editor)
    }
}

#Preview {
    MyToolbarView()
}
