//
//  ToolItemsConfigurationView+InkItemView.swift
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

import SwiftUI
import PencilKit
import ObjectiveC

extension ToolItemsConfigurationView {
    struct InkItemView: View {
        private static let allInkTypes: [PKInkingTool.InkType] = [
            .marker,
            .pen,
            .pencil,
            .monoline,
            .fountainPen,
            .watercolor,
            .crayon
        ]
        
        @State private var pop = false
        
        @State private var inkType: PKInkingTool.InkType = .marker
        @State private var color: Color = .black
        @State private var width: CGFloat = 10
        @State private var allowsColorSelection = true
        
        private let completionHandler: (PKToolPickerInkingItem) -> Void
        
        init(completionHandler: @escaping (PKToolPickerInkingItem) -> Void) {
            self.completionHandler = completionHandler
        }
        
        var body: some View {
            Form {
                Picker(selection: $inkType) {
                    ForEach(Self.allInkTypes, id: \.rawValue) { inkType in
                        Text(String(describing: inkType))
                            .tag(inkType)
                    }
                } label: {
                    Text("Ink Type")
                }
                
                ColorPicker("Color", selection: $color, supportsOpacity: true)
                
                Slider(value: $width, in: 1.0...100.0) {
                    Text("Width")
                }
                
                Toggle(isOn: $allowsColorSelection) {
                    Text("Allows Color Selection")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        let item = PKToolPickerInkingItem(
                            type: inkType,
                            color: UIColor(color),
                            width: width,
                            identifier: nil
                        )
                        
                        item.allowsColorSelection = allowsColorSelection
                        
                        completionHandler(item)
                        
                        pop = true
                    }
                }
            }
            .pop(pop)
        }
    }
}
