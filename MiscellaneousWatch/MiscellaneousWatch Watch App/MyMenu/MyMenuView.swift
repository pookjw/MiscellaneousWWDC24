//
//  MyMenuView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

import SwiftUI

struct MyMenuView: View {
    var body: some View {
        Text("Turtle Rock")
            .padding()
            .contextMenu { // 안 됨
                Button {
                    // Add this item to a list of favorites.
                } label: {
                    Label("Add to Favorites", systemImage: "heart")
                }
                Button {
                    // Open Maps and center it on this item.
                } label: {
                    Label("Show in Maps", systemImage: "mappin")
                }
            }
    }
}

#Preview {
    MyMenuView()
}
