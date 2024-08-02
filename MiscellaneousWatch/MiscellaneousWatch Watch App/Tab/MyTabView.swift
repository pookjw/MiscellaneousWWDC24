//
//  MyTabView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/2/24.
//

import SwiftUI

/*
 PUICPageViewController
 */

struct MyTabView: View {
    @State private var selectedTag: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTag) {
            Tab("Cyan", systemImage: "eraser.fill", value: 0, role: .none) { 
                Color.cyan
                    .ignoresSafeArea()
            }
            
            Tab("Orange", systemImage: "eraser.fill", value: 1, role: .none) { 
                Color.orange
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.verticalPage)
//        .tabViewStyle(.page)
    }
}

#Preview {
    MyTabView()
}
