//
//  ToolItemsConfigurationView+EraserItemView.swift
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

import SwiftUI
import PencilKit

extension ToolItemsConfigurationView {
    struct EraserItemView: View {
        private static let allEraserTypes: [PKEraserTool.EraserType] = [
            .vector,
            .bitmap,
            .fixedWidthBitmap
        ]
        
        @State private var pop = false
        
        @State private var eraserType: PKEraserTool.EraserType = .vector
        @State private var width: CGFloat = 10
        
        private let completionHandler: (PKToolPickerEraserItem) -> Void
        
        init(completionHandler: @escaping (PKToolPickerEraserItem) -> Void) {
            self.completionHandler = completionHandler
        }
        
        var body: some View {
            Form {
                Picker(selection: $eraserType) {
                    ForEach(Self.allEraserTypes, id: \.hashValue) { eraserType in
                        Text(String(describing: eraserType))
                            .tag(eraserType)
                    }
                } label: {
                    Text("Eraser Type")
                }
                
                Slider(value: $width, in: 1.0...100.0) {
                    Text("Width")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        let item = PKToolPickerEraserItem(type: eraserType, width: width)
                        
                        completionHandler(item)
                        pop = true
                    }
                }
            }
            .pop(pop)
        }
    }
}
