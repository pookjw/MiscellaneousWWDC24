//
//  SwiftConfigurationDemoViewController.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Cocoa

final class SwiftConfigurationDemoViewController: NSViewController {
    private let configurationView = ConfigurationView()
    private var switchValue = false
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configurationView.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = configurationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    private func reload() {
        var snapshot = NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel>()
        
        snapshot.appendSections([NSNull()])
        
        snapshot.appendItems(
            [
                makeColorWellItemModel(),
                makeLabelItemModel(),
                makeAlertItemModel(),
                makePopoverItemModel(),
                makeSwitchItemModel(),
                makeButtonItemModel(),
                makePopUpButtonItemModel(),
                makeSliderItemModel(),
                makeStepperItemModel()
            ],
            toSection: NSNull()
        )
        
        configurationView.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeSwitchItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .switchItem(
                identifier: "Switch",
                userInfo: ["Test": "Foo"],
                labelResolver: { _, _ in
                    return "Switch"
                },
                valueResolver: { [unowned(unsafe) self] _ in
                    switchValue
                }
            )
    }
    
    private func makeButtonItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .buttonItem(
                identifier: "Button",
                label: "Button",
                valueResolver: { _ in
                    ConfigurationButtonDescription(title: "Button")
                }
            )
    }
    
    private func makePopUpButtonItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .popUpButtonItem(
                identifier: "Pop Up Button",
                label: "Pop Up Button"
            ) { itemModel in
                ConfigurationPopUpButtonDescription(
                    titles: ["1", "2", "3"],
                    selectedTitles: [],
                    selectedDisplayTitle: nil
                )
            }
    }
    
    private func makeSliderItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .sliderItem(
                identifier: "Slider",
                label: "Slider"
            ) { itemModel in
                ConfigurationSliderDescription(
                    value: 1.0,
                    minValue: .zero,
                    maxValue: 10.0,
                    continuous: true
                )
            }
    }
    
    private func makeStepperItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .stepperItem(
                identifier: "Stepper",
                label: "Slider"
            ) { itemModel in
                ConfigurationStepperDescription(
                    value: 1.0,
                    minValue: .zero,
                    maxValue: 10.0,
                    stepValue: 3.0,
                    continuous: true,
                    autorepeat: true,
                    valueWraps: true
                )
            }
    }
    
    private func makePopoverItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .viewPresentationItem(
                identifier: "Popover",
                label: "Popover"
            ) { itemModel in
                    .popoverStyle { layout in
                        let textField = NSTextField(labelWithString: "123")
                        
                        Task { @MainActor in
                            try! await Task.sleep(for: .seconds(2))
                            textField.stringValue = "1\n2\n3"
                            textField.sizeToFit()
                            layout()
                        }
                        
                        return textField
                    } didCloseHandler: { resolvedView, reason in
                        print(reason)
                    }
            }
    }
    
    private func makeAlertItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .viewPresentationItem(
                identifier: "Alert",
                label: "Alert"
            ) { itemModel in
                    .alertStyle { layout in
                        let textField = NSTextField(labelWithString: "123")
                        
                        Task { @MainActor in
                            try! await Task.sleep(for: .seconds(2))
                            textField.stringValue = "1\n2\n3"
                            textField.sizeToFit()
                            layout()
                        }
                        
                        return textField
                    } didCloseHandler: { resolvedView, response in
                        print(response)
                    }
            }
    }
    
    private func makeLabelItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .labelItem(identifier: "Label", label: "Label Test")
    }
    
    private func makeColorWellItemModel() -> ConfigurationItemModel {
        ConfigurationItemModel
            .colorWellItem(identifier: "Color Well", label: "Color Well") { itemModel in
                NSColor.systemPink
            }
    }
}

extension SwiftConfigurationDemoViewController: ConfigurationViewDelegate {
    func configurationView(_ configurationView: ConfigurationView, didTriggerActionWith itemModel: ConfigurationItemModel, newValue: Any?) -> Bool {
        switch itemModel.identifier {
        case "Switch":
            switchValue = newValue as! Bool
            return false
        case "Button":
            print("Triggered!")
            return false
        case "Pop Up Button":
            print(newValue as! String)
            return false
        case "Slider":
            print(newValue as! Double)
            return false
        case "Stepper":
            print(newValue as! Double)
            return false
        case "Color Well":
            print(newValue as! NSColor)
            return false
        default:
            fatalError()
        }
    }
    
    var shouldShowReloadButton: Bool {
        true
    }
    
    func didTriggerReloadButton(_ configurationView: ConfigurationView) {
        reload()
    }
}
