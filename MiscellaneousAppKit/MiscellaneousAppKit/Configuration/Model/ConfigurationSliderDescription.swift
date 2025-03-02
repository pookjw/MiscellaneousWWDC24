//
//  ConfigurationSliderDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Foundation

public struct ConfigurationSliderDescription {
    private let impl: __ConfigurationSliderDescription
    
    private init(impl: __ConfigurationSliderDescription) {
        self.impl = impl
    }
    
    public init(value: Double, minValue: Double, maxValue: Double) {
        let impl = __ConfigurationSliderDescription(sliderValue: value, minimumValue: minValue, maximumValue: maxValue)
        self.init(impl: impl)
    }
    
    public init(value: Double, minValue: Double, maxValue: Double, continuous: Bool) {
        let impl = __ConfigurationSliderDescription(sliderValue: value, minimumValue: minValue, maximumValue: maxValue, continuous: continuous)
        self.init(impl: impl)
    }
}

extension ConfigurationSliderDescription: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> __ConfigurationSliderDescription {
        impl
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: __ConfigurationSliderDescription, result: inout ConfigurationSliderDescription?) {
        result = ConfigurationSliderDescription(impl: source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: __ConfigurationSliderDescription, result: inout ConfigurationSliderDescription?) -> Bool {
        result = ConfigurationSliderDescription(impl: source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: __ConfigurationSliderDescription?) -> ConfigurationSliderDescription {
        ConfigurationSliderDescription(impl: source!)
    }
}
