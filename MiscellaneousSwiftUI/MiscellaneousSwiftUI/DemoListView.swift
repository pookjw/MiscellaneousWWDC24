//
//  DemoListView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/24.
//

import SwiftUI

struct DemoListView: View {
    @State private var paths: [Demo] = []
    @State private var selectedDemo: Demo?
    
    var body: some View {
        NavigationStack(path: $paths) { 
            List(Demo.allCases.reversed(), id: \.self, selection: $selectedDemo) { demo in
                NavigationLink { 
                    demo.makeView()
                } label: {
                    Text(String(describing: demo))
                }
            }
            .navigationTitle("Miscellaneous")
        }
    }
}

#Preview {
    DemoListView()
}
