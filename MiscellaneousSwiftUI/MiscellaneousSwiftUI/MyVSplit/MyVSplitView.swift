//
//  MyVSplitView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/8/24.
//

#if os(macOS)

import SwiftUI

struct MyVSplitView: View {
    var body: some View {
        VSplitView { 
            Color.green
            Color.pink
        }
    }
}

#Preview {
    MyVSplitView()
}

#endif
