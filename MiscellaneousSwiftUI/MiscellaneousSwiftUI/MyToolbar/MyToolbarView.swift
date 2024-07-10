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
            .toolbar(id: "MyToolbarView") {
//                ToolbarItem(id: "1", placement: .keyboard) {
//                    Button("♦️", action: {})
//                }
//                .defaultCustomization(.visible, options: .alwaysAvailable)
//                .customizationBehavior(.reorderable)
                
                ToolbarItem(id: "principal", placement: .primaryAction) { 
                    Button("1", action: {
                    })
                }
                .defaultCustomization(.visible, options: .alwaysAvailable)
                .customizationBehavior(.reorderable)
                
//                ToolbarItemGroup(placement: .navigation) {
//                    Button("1", action: {})
//                    Button("2", action: {})
//                    Button("3", action: {})
//                } label: {
//                    Text("Group!")
//                }
                
                ToolbarItem(id: "navigation", placement: .navigation) { 
                    Button("5", action: {})
                }
                .defaultCustomization(.visible, options: .alwaysAvailable)
                .customizationBehavior(.reorderable)
                
                ToolbarTitleMenu {
                    Button("Title Menu!") {
                        
                    }
                }
            }
            .navigationTitle($text)
            .toolbarRole(.editor)
//            .toolbar(removing: .title)
            .toolbarTitleDisplayMode(.inline)
#if !os(macOS)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
//            .navigationBarTitleDisplayMode(.inline)
            .overlay { 
                MyView()
            }
#endif
    }
}

#if !os(macOS)
fileprivate struct MyView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyViewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        
    }
    
    final class MyViewController: UIViewController {
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            
            if let navigationController: UINavigationController,
               let rootViewController: UIViewController = navigationController.topViewController
            {
                let navigationItem: UINavigationItem = rootViewController.navigationItem
                navigationItem.centerItemGroups = [
                    .optionalGroup(customizationIdentifier: "", items: [ .init(image: .init(systemName: "rectangle.portrait.and.arrow.right.fill"))])
                ]
            }
        }
    }
}
#endif

#Preview {
    MyToolbarView()
}
