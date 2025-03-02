//
//  ConfigurationStepperDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Foundation

public struct ConfigurationStepperDescription {
    private let impl: __ConfigurationStepperDescription
    
    private init(impl: __ConfigurationStepperDescription) {
        self.impl = impl
    }
    
    public init(
        value: Double,
        minValue: Double,
        maxValue: Double,
        stepValue: Double,
        continuous: Bool,
        autorepeat: Bool,
        valueWraps: Bool
    ) {
        let impl = __ConfigurationStepperDescription(
            stepperValue: value,
            minimumValue: minValue,
            maximumValue: maxValue,
            stepValue: stepValue,
            continuous: continuous,
            autorepeat: autorepeat,
            valueWraps: valueWraps
        )
        
        self.init(impl: impl)
    }
}

extension ConfigurationStepperDescription: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> __ConfigurationStepperDescription {
        impl
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: __ConfigurationStepperDescription, result: inout ConfigurationStepperDescription?) {
        result = ConfigurationStepperDescription(impl: source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: __ConfigurationStepperDescription, result: inout ConfigurationStepperDescription?) -> Bool {
        result = ConfigurationStepperDescription(impl: source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: __ConfigurationStepperDescription?) -> ConfigurationStepperDescription {
        ConfigurationStepperDescription(impl: source!)
    }
}
