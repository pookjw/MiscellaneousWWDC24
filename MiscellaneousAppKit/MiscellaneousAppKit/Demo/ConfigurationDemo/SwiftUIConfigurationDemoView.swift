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
    @State private var color = NSColor.white
    @State private var sliderValue = 0.5
    @State private var stepperValue = 0.5
    @State private var isOn = true
    
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
                    title: "Slider \(sliderValue)",
                    value: $sliderValue,
                    minValue: .zero,
                    maxValue: 1.0,
                    continuous: true
                )
            
            ConfigurationForm
                .StepperItem(
                    identifier: "Stepper",
                    title: "Stepper \(stepperValue)",
                    value: $stepperValue,
                    minValue: .zero,
                    maxValue: 1.0,
                    stepValue: 0.3,
                    continuous: true,
                    autorepeat: true,
                    valueWraps: true
                )
            
            ConfigurationForm
                .ViewPresentationItem
                .alertStyle(
                    identifier: "Alert",
                    title: "Alert",
                    viewBuilder: {
                        Text(isOn ? "Hello" : "Hello\nHello\nHello")
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.white)
                            .onTapGesture {
                                isOn.toggle()
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
                        Text(isOn ? "Hello" : "Hello\nHello\nHello")
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.white)
                            .onTapGesture {
                                isOn.toggle()
                            }
                    },
                    didCloseHandler: { reason in
                        print(reason)
                    }
                )
            
            ConfigurationForm.EmptyItem()
            
            ConfigurationForm
                .LabelItem(identifier: "Label", title: "Label")
            
            ConfigurationForm
                .ColorWellItem(identifier: "Color Well", title: "Color Well", color: $color)
            
            ConfigurationForm
                .SwitchItem(identifier: "Switch", title: "Switch \(isOn)", isOn: $isOn)
        }
        .overlay(alignment: .center) { 
            Color(nsColor: color)
                .frame(width: 50, height: 50)
        }
        .onChange(of: sliderValue) { oldValue, newValue in
            print(newValue)
        }
        .onChange(of: stepperValue) { oldValue, newValue in
            print(newValue)
        }
        .onChange(of: isOn) { oldValue, newValue in
            print(newValue)
        }
    }
}

#Preview {
    SwiftUIConfigurationDemoView()
}
