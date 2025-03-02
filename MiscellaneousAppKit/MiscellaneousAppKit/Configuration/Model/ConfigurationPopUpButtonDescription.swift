//
//  ConfigurationPopUpButtonDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Foundation

public struct ConfigurationPopUpButtonDescription {
    public var titles: [String] {
        impl.titles
    }
    
    public var selectedTitles: [String] {
        impl.selectedTitles
    }
    
    public var selectedDisplayTitle: String? {
        impl.selectedDisplayTitle
    }
    
    private let impl: __ConfigurationPopUpButtonDescription
    
    private init(impl: __ConfigurationPopUpButtonDescription) {
        self.impl = impl
    }
    
    public init(
        titles: [String],
        selectedTitles: [String] = [],
        selectedDisplayTitle: String? = nil
    ) {
        let impl = __ConfigurationPopUpButtonDescription(titles: titles, selectedTitles: selectedTitles, selectedDisplayTitle: selectedDisplayTitle)
        self.init(impl: impl)
    }
}

extension ConfigurationPopUpButtonDescription: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> __ConfigurationPopUpButtonDescription {
        impl
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: __ConfigurationPopUpButtonDescription, result: inout ConfigurationPopUpButtonDescription?) {
        result = ConfigurationPopUpButtonDescription(impl: source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: __ConfigurationPopUpButtonDescription, result: inout ConfigurationPopUpButtonDescription?) -> Bool {
        result = ConfigurationPopUpButtonDescription(impl: source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: __ConfigurationPopUpButtonDescription?) -> ConfigurationPopUpButtonDescription {
        ConfigurationPopUpButtonDescription(impl: source!)
    }
}
