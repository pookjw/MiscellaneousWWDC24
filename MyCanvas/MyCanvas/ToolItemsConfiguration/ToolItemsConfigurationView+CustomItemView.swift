//
//  ToolItemsConfigurationView+CustomItemView.swift
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

import SwiftUI
import PencilKit

extension ToolItemsConfigurationView {
    struct CustomItemView: View {
        private enum Mode {
            case create((PKToolPickerCustomItem) -> Void)
            case edit(PKToolPickerCustomItem)
        }
        
        @State private var configuration = PKToolPickerCustomItem.Configuration(identifier: UUID().uuidString, name: UUID().uuidString)
        @State private var color: UIColor
        @State private var width: CGFloat
        @State private var allowsColorSelection: Bool
        
        @State private var pop = false
        private let mode: Mode
        
        init(editingItem item: PKToolPickerCustomItem) {
            mode = .edit(item)
            _configuration = State(initialValue: item.configuration)
            _color = State(initialValue: item.color)
            _width = State(initialValue: item.width)
            _allowsColorSelection = State(initialValue: item.allowsColorSelection)
        }
        
        init(completionHandler: @escaping (PKToolPickerCustomItem) -> Void) {
            mode = .create(completionHandler)
            _color = State(initialValue: .black)
            _width = State(initialValue: 10)
            _allowsColorSelection = State(initialValue: true)
        }
        
        var body: some View {
            Form {
                if case .create(_) = mode {
                    Section("Configuration") {
                        ColorPicker(
                            "Default Color",
                            selection: Binding(
                                get: {
                                    Color(configuration.defaultColor)
                                },
                                set: { newValue, _ in
                                    configuration.defaultColor = UIColor(newValue)
                                }
                            ),
                            supportsOpacity: true
                        )
                        
                        Toggle("Allows Color Selection", isOn: $configuration.allowsColorSelection)
                        
                        if let firstWidth = configuration.widthVariants.keys.sorted().first,
                           let lastWidth = configuration.widthVariants.keys.sorted().last
                        {
                            Stepper("Default Width \(configuration.defaultWidth)", value: $configuration.defaultWidth, in: firstWidth...lastWidth, step: 10.0)
                        }
                        
                        Toggle(
                            isOn: Binding(
                                get: {
                                    configuration.toolAttributeControls.contains(.opacity)
                                },
                                set: { newValue in
                                    configuration.toolAttributeControls.insert(.opacity)
                                }
                            )
                        ) {
                            Text("Opacity Control")
                        }
                        
                        Toggle(
                            isOn: Binding(
                                get: {
                                    configuration.toolAttributeControls.contains(.width)
                                },
                                set: { newValue in
                                    configuration.toolAttributeControls.insert(.width)
                                }
                            )
                        ) {
                            Text("Width Control")
                        }
                    }
                    
                    Section {
                        ForEach(Array(configuration.widthVariants.keys.sorted()), id: \.self) { width in
                            Label {
                                Text(String(describing: width))
                            } icon: {
                                Image(uiImage: configuration.widthVariants[width]!)
                            }
                        }
                    }
                }
                
                Section {
                    ColorPicker(
                        "Color",
                        selection: Binding(
                            get: {
                                Color(uiColor: color)
                            },
                            set: { newValue in
                                color = UIColor(newValue)
                            }
                        ),
                        supportsOpacity: true
                    )
                    
                    if let firstWidth = configuration.widthVariants.keys.sorted().first,
                       let lastWidth = configuration.widthVariants.keys.sorted().last
                    {
                        Stepper("Width \(width)", value: $width, in: firstWidth...lastWidth, step: 10.0)
                    }
                    
                    Toggle(isOn: $allowsColorSelection) {
                        Text("Allows Color Selection")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Image", systemImage: "plus") {
                        let widths = configuration
                            .widthVariants
                            .keys
                            .sorted()
                        let width = (widths.last ?? 0) + 10
                        configuration.widthVariants[width] = UIImage(systemName: "\(Int(width)).square")!
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    switch mode {
                    case .create(let completionHandler):
                        Button("Done") {
                            configuration.imageProvider = { _ in
                                UIImage(systemName: "apple.intelligence")!
                            }
                            
                            configuration.viewControllerProvider = { _ in
                                return UIHostingController(rootView: Text("Hello World!").padding())
                            }
                            
                            let item = PKToolPickerCustomItem(configuration: configuration)
                            
                            item.color = color
                            item.width = width
                            item.allowsColorSelection = allowsColorSelection
                            
                            completionHandler(item)
                            pop = true
                        }
                    case .edit(let item):
                        Button("Update") {
                            item.color = color
                            print(item.width, width)
                            item.width = width
                            item.allowsColorSelection = allowsColorSelection
                            pop = true
                        }
                    }
                }
            }
            .pop(pop)
        }
    }
}
