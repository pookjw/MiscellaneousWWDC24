//
//  MyTabPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/7/24.
//

#if !os(tvOS)

import SwiftUI

struct MyTabPresenterView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
#if os(macOS)
        MyTabView()
#else
        Button("Present") {
            isPresented = true
        }
        .onAppear {
            isPresented = true
        }
        .fullScreenCover(isPresented: $isPresented) {
            NavigationStack {
                MyTabView()
            }
        }
#endif
    }
}

fileprivate struct MyTabView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
#if !os(macOS)
    @AppStorage("MyTabViewCustomizatiion", store: .standard) private var customization: TabViewCustomization
//    @SceneStorage("MyTabViewCustomizatiion", store: .standard) private var customization: TabViewCustomization
#endif
    @State private var isShowingPopover = false
    @State private var selectedValue: Int = .zero
    
    var body: some View {
        TabView(selection: $selectedValue) {
            Tab("Red", systemImage: "eraser.line.dashed.fill", value: .zero, role: .none) {
                Color.red.ignoresSafeArea()
            }
            .customizationID("red")
#if !os(macOS)
            .customizationBehavior(.reorderable, for: .automatic, .sidebar, .tabBar)
            .defaultVisibility(.visible, for: .automatic, .sidebar, .tabBar)
#endif
            //            .hidden()
            .contextMenu {
                Button("Hello") {}
            }
            
            Tab("Orange", systemImage: "eraser.fill", value: 1, role: .none) {
                Color.orange.ignoresSafeArea()
            }
            .customizationID("orange")
#if !os(macOS)
            .customizationBehavior(.disabled, for: .automatic, .sidebar, .tabBar)
            .defaultVisibility(.visible, for: .automatic, .sidebar, .tabBar)
#endif
            
            Tab(value: 3) {
                Color.yellow.ignoresSafeArea()
            } label: {
                Label("Yellow", systemImage: "externaldrive.fill.badge.plus")
                    .background {
                        Color.yellow
                    }
            }
            .badge("Badge!!!")
            .popover(
                isPresented: $isShowingPopover) {
                    Text("Popover Content")
                        .padding()
                }
            
            Tab(value: 4) {
                Color.green.ignoresSafeArea()
                    .tabItem { // not work - deprecated
                        Label("Green", systemImage: "person.3.sequence.fill")
                    }
            }
            
            Tab(value: 5, role: .search) {
                Color.blue.ignoresSafeArea()
            }
            
            Tab("Purple", systemImage: "person.3.sequence.fill", value: 6, role: .none) {
                Color.purple.ignoresSafeArea()
            }
            .tabPlacement(.pinned)
            .swipeActions(edge: .leading, allowsFullSwipe: true) { 
                Button(role: .destructive) { 
                    print("Foo!")
                } label: { 
                    Text("Foo")
                }
                
            }
            
            //
            
            TabSection {
                Tab.init(value: 7, role: .none) {
                    Color.pink.ignoresSafeArea()
                } label: {
                    Text("Pink")
                }
                .badge("Badge!!!")
                
            } header: {
                // Custom View is not supported
                //                Button("Section") {
                //                    
                //                }
                
                // Image is not supported
                Label("Section", systemImage: "fn")
            }
            .sectionActions { 
                Button("Hello 1") { 
                    
                }
                Button("Hello 2") { 
                    
                }
            }
        }
        .tabViewSidebarHeader {
            Text("Header")
        }
        .tabViewSidebarFooter {
            Text("Footer")
        }
        .tabViewSidebarBottomBar {
            Text("Bottom Bar")
        }
        .tabViewStyle(.sidebarAdaptable)
#if !os(macOS)
        .tabViewCustomization($customization)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigation) {
                Button("Next") {
                    selectedValue += 1
                }
            }
            
            ToolbarItem(placement: .navigation) {
                Button("Popover") {
                    isShowingPopover = true
                }
            }
            
            ToolbarItem(placement: .navigation) {
                EditButton() // not work
            }
        }
#endif
    }
}

#Preview {
    MyTabPresenterView()
}

#endif
