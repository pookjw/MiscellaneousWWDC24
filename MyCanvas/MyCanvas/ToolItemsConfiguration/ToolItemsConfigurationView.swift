//
//  ToolItemsConfigurationView.swift
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

import SwiftUI
import PencilKit
import ObjectiveC

@_cdecl("makeToolItemsConfigurationHostingController")
func makeToolItemsConfigurationHostingController(toolItems: [PKToolPickerItem], completionHandler: @escaping @Sendable ([PKToolPickerItem]) -> Void) -> UIViewController {
    MainActor.assumeIsolated {
        UIHostingController(rootView: ToolItemsConfigurationView(toolItems: toolItems, completionHandler: completionHandler))
    }
}

struct ToolItemsConfigurationView: View {
    @State private var toolItems: [PKToolPickerItem]
    private let completionHandler: ([PKToolPickerItem]) -> Void
    
    fileprivate init(
        toolItems: [PKToolPickerItem],
        completionHandler: @escaping ([PKToolPickerItem]) -> Void
    ) {
        _toolItems = State(initialValue: toolItems)
        self.completionHandler = completionHandler
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(toolItems) { toolItem in
                    VStack(alignment: .leading) {
                        if let customItem = toolItem as? PKToolPickerCustomItem {
                            NavigationLink(value: customItem) {
                                Text(toolItem.identifier)
                                Text(String(describing: toolItem.self))
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                        } else {
                            Text(toolItem.identifier)
                            Text(String(describing: toolItem.self))
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete { indexSet in
                    toolItems.remove(atOffsets: indexSet)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Remove All") {
                        toolItems.removeAll()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        NavigationLink("PKToolPickerInkingItem") {
                            InkItemView { item in
                                toolItems.append(item)
                            }
                        }
                        
                        NavigationLink("PKToolPickerEraserItem") {
                            EraserItemView { item in
                                toolItems.append(item)
                            }
                        }
                        
                        Button("PKToolPickerLassoItem") {
                            toolItems.append(PKToolPickerLassoItem())
                        }
                        
                        Button("PKToolPickerRulerItem") {
                            toolItems.append(PKToolPickerRulerItem())
                        }
                        
                        Button("PKToolPickerScribbleItem") {
                            toolItems.append(PKToolPickerScribbleItem())
                        }
                        
                        NavigationLink("PKToolPickerCustomItem") {
                            CustomItemView { item in
                                toolItems.append(item)
                            }
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        completionHandler(toolItems)
                    }
                }
            }
            .navigationDestination(for: PKToolPickerCustomItem.self) { customItem in
                CustomItemView(editingItem: customItem)
            }
        }
    }
}

extension PKToolPickerItem: @retroactive @unchecked Sendable {}
extension PKToolPickerItem: @retroactive Identifiable {}

//extension PKToolPickerItem {
//    var _width: CGFloat {
//        get {
//            let cmd = Selector(("width"))
//            let method = class_getInstanceMethod(PKToolPickerInkingItem.self, cmd)!
//            let imp = method_getImplementation(method)
//            let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> CGFloat).self)
//            return casted(self, cmd)
//        }
//        set {
//            let cmd = Selector(("setWidth:"))
//            let method = class_getInstanceMethod(PKToolPickerInkingItem.self, cmd)!
//            let imp = method_getImplementation(method)
//            let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector, CGFloat) -> Void).self)
//            casted(self, cmd, newValue)
//        }
//    }
//}
