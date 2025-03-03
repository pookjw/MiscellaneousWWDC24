//
//  SwiftUIConfigurationDemoView.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/3/25.
//

import SwiftUI

final class SwiftUIConfigurationDemoViewController: NSViewController {
    override func loadView() {
        view = NSHostingView(rootView: SwiftUIConfigurationDemoView())
    }
}

struct SwiftUIConfigurationDemoView: View {
    @State private var flag = false
    
    var body: some View {
        ConfigurationForm {
            ConfigurationForm
                .ButtonItem(
                    identifier: "Button",
                    title: "Title",
                    buttonTitle: "Button"
                ) { 
                    print("Button")
                }
            
                ConfigurationForm
                    .PopUpButtonItem(
                        identifier: "Pop Up Button",
                        title: "Pop Up Button",
                        menuTitles: [
                            .unselected("0"),
                            .selected("1"),
                            .primarySelected("2"),
                            .unselected("3"),
                            .selected("4")
                        ]
                    ) { string in
                        print(string)
                    }
            
            ConfigurationForm
                .SliderItem(
                    identifier: "Slider",
                    title: "Slider",
                    value: 0.5,
                    minValue: .zero,
                    maxValue: 1.0,
                    continuous: true
                ) { newValue in
                    print(newValue)
                }
            
            ConfigurationForm
                .StepperItem(
                    identifier: "Stepper",
                    title: "Stepper",
                    value: 0.5,
                    minValue: .zero,
                    maxValue: 1.0,
                    stepValue: 0.3,
                    continuous: true,
                    autorepeat: true,
                    valueWraps: true
                ) { newValue in
                    print(newValue)
                }
            
            ConfigurationForm
                .ViewPresentationItem
                .alertStyle(
                    identifier: "Alert",
                    title: "Alert",
                    viewBuilder: {
                        Text(flag ? "Hello" : "Hello\nHello\nHello")
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.white)
                            .onTapGesture {
                                flag.toggle()
                            }
                    },
                    didCloseHandler: { response in
                        print(response)
                    }
                )
            
            ConfigurationForm
                .ViewPresentationItem
                .popoverStyle(
                    identifier: "Popover",
                    title: "Popover",
                    viewBuilder: {
                        Text(flag ? "Hello" : "Hello\nHello\nHello")
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.white)
                            .onTapGesture {
                                flag.toggle()
                            }
                    },
                    didCloseHandler: { reason in
                        print(reason)
                    }
                )
            
            ConfigurationForm.EmptyItem()
            
            ConfigurationForm
                .LabelItem(identifier: "Label", title: "Label")
        }
    }
}

#Preview {
    SwiftUIConfigurationDemoView()
}
