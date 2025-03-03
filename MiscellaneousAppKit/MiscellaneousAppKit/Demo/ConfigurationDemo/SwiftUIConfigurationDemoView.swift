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
            
            if Bool.random() {
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
        }
    }
}

#Preview {
    SwiftUIConfigurationDemoView()
}
