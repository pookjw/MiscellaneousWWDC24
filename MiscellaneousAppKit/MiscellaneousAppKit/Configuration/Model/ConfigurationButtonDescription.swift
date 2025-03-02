//
//  ConfigurationButtonDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Cocoa

public struct ConfigurationButtonDescription {
    public var title: String {
        impl.title
    }
    
    public var showsMenuAsPrimaryAction: Bool {
        impl.showsMenuAsPrimaryAction
    }
    
    private let impl: __ConfigurationButtonDescription
    
    public init(title: String) {
        let impl = __ConfigurationButtonDescription(title: title)
        self.init(impl: impl)
    }
    
    public init(title: String, showsMenuAsPrimaryAction: Bool = false, menu: NSMenu) {
        let impl = __ConfigurationButtonDescription(title: title, menu: menu, showsMenuAsPrimaryAction: showsMenuAsPrimaryAction)
        self.init(impl: impl)
    }
    
    private init(impl: __ConfigurationButtonDescription) {
        self.impl = impl
    }
}

extension ConfigurationButtonDescription: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> __ConfigurationButtonDescription {
        impl
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: __ConfigurationButtonDescription, result: inout ConfigurationButtonDescription?) {
        result = ConfigurationButtonDescription(impl: source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: __ConfigurationButtonDescription, result: inout ConfigurationButtonDescription?) -> Bool {
        result = ConfigurationButtonDescription(impl: source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: __ConfigurationButtonDescription?) -> ConfigurationButtonDescription {
        ConfigurationButtonDescription(impl: source!)
    }
}
