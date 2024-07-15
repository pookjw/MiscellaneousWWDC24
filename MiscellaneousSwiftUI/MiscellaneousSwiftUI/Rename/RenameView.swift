//
//  RenameView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/6/24.
//

#if !os(tvOS)

import SwiftUI

struct RenameView: View {
    @State private var title: String = "Untitled"
    @Environment(\.rename) private var renameAction: RenameAction?
    
    var body: some View {
        Color.red
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    //                RenameButton()
                    Button("Rename") {
                        
                        renameAction!()
                    }
                }
            }
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbarRole(.editor)
            .navigationTitle($title)
        //        .renameAction {
        //            isFocused = true
        //        }
    }
}

#Preview {
    RenameView()
}

#endif
