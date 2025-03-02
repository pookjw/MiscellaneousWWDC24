//
//  ConfigurationItemModel.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Cocoa

public struct ConfigurationItemModel: Hashable {
    public var identifier: String {
        impl.identifier
    }
    
    private let impl: __ConfigurationItemModel<AnyObject>
    
    private init<T: AnyObject>(impl: __ConfigurationItemModel<T>) {
        self.impl = unsafeDowncast(impl, to: __ConfigurationItemModel<AnyObject>.self)
    }
}

extension ConfigurationItemModel: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> __ConfigurationItemModel<AnyObject> {
        return impl
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: __ConfigurationItemModel<AnyObject>, result: inout ConfigurationItemModel?) {
        result = ConfigurationItemModel(impl: source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: __ConfigurationItemModel<AnyObject>, result: inout ConfigurationItemModel?) -> Bool {
        result = ConfigurationItemModel(impl: source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: __ConfigurationItemModel<AnyObject>?) -> ConfigurationItemModel {
        ConfigurationItemModel(impl: source!)
    }
}

extension ConfigurationItemModel {
    public static func switchItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: Bool) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> Bool
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<NSNumber>(
            type: .switch,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), (value as! Bool))
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as NSNumber
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func switchItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> Bool
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<NSNumber>(
            type: .switch,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as NSNumber
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func buttonItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: ConfigurationButtonDescription) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationButtonDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationButtonDescription>(
            type: .button,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), value as! ConfigurationButtonDescription)
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationButtonDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func buttonItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationButtonDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationButtonDescription>(
            type: .button,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationButtonDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func popUpButtonItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: ConfigurationPopUpButtonDescription) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationPopUpButtonDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationPopUpButtonDescription>(
            type: .popUpButton,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), value as! ConfigurationPopUpButtonDescription)
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationPopUpButtonDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func popUpButtonItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationPopUpButtonDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationPopUpButtonDescription>(
            type: .popUpButton,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationPopUpButtonDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func sliderItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: ConfigurationSliderDescription) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationSliderDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationSliderDescription>(
            type: .slider,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), value as! ConfigurationSliderDescription)
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationSliderDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func sliderItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationSliderDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationSliderDescription>(
            type: .slider,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationSliderDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func stepperItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: ConfigurationStepperDescription) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationStepperDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationStepperDescription>(
            type: .slider,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), value as! ConfigurationStepperDescription)
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationStepperDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func stepperItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationStepperDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationStepperDescription>(
            type: .stepper,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationStepperDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func viewPresentationItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: ConfigurationViewPresentationDescription) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationViewPresentationDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationViewPresentationDescription>(
            type: .viewPresentation,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), value as! ConfigurationViewPresentationDescription)
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationViewPresentationDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func viewPresentationItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> ConfigurationViewPresentationDescription
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationViewPresentationDescription>(
            type: .viewPresentation,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl)) as __ConfigurationViewPresentationDescription
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func labelItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel) -> String
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationViewPresentationDescription>(
            type: .label,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, _ in
                labelResolver(ConfigurationItemModel(impl: impl))
            },
            valueResolver: { _ in return NSNull() }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func labelItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationViewPresentationDescription>(
            type: .label,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { _ in return NSNull() }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}

extension ConfigurationItemModel {
    public static func colorWellItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        labelResolver: @escaping (_ itemModel: ConfigurationItemModel, _ value: NSColor) -> String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> NSColor
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationViewPresentationDescription>(
            type: .colorWell,
            identifier: identifier,
            userInfo: userInfo,
            labelResolver: { impl, value in
                labelResolver(ConfigurationItemModel(impl: impl), value as! NSColor)
            },
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl))
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
    
    public static func colorWellItem(
        identifier: String,
        userInfo: [String: Any]? = nil,
        label: String,
        valueResolver: @escaping (_ itemModel: ConfigurationItemModel) -> NSColor
    ) -> ConfigurationItemModel {
        let impl = __ConfigurationItemModel<__ConfigurationViewPresentationDescription>(
            type: .colorWell,
            identifier: identifier,
            userInfo: userInfo,
            label: label,
            valueResolver: { impl in
                return valueResolver(ConfigurationItemModel(impl: impl))
            }
        )
        
        return ConfigurationItemModel(impl: impl)
    }
}
