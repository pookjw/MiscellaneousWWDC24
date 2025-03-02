//
//  ConfigurationViewPresentationDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/3/25.
//

import Cocoa

public struct ConfigurationViewPresentationDescription {
    private let impl: __ConfigurationViewPresentationDescription
    
    private init(impl: __ConfigurationViewPresentationDescription) {
        self.impl = impl
    }
    
    public static func popoverStyle(
        viewBuilder: @escaping (@MainActor (_ layout: @MainActor @escaping () -> Void) -> NSView),
        didCloseHandler: @escaping (@MainActor (_ resolvedView: NSView, _ response: NSPopover.CloseReason) -> Void)
    ) -> ConfigurationViewPresentationDescription {
        let impl = __ConfigurationViewPresentationDescription(
            style: .popover,
            viewBuilder: { layout in
                let casted = unsafeBitCast(layout, to: (@Sendable () -> Void).self)
                
                return MainActor.assumeIsolated {
                    viewBuilder(casted)
                }
            },
            didCloseHandler: { resolvedView, info in
                let key = MainActor.assumeIsolated { NSPopover.closeReasonUserInfoKey }
                let reason = info[key] as! NSPopover.CloseReason
                
                MainActor.assumeIsolated {
                    didCloseHandler(resolvedView, reason)
                }
            }
        )
        
        return ConfigurationViewPresentationDescription(impl: impl)
    }
    
    public static func alertStyle(
        viewBuilder: @escaping (@MainActor (_ layout: @MainActor @escaping () -> Void) -> NSView),
        didCloseHandler: @escaping (@MainActor (_ resolvedView: NSView, _ reason: NSApplication.ModalResponse) -> Void)
    ) -> ConfigurationViewPresentationDescription {
        let impl = __ConfigurationViewPresentationDescription(
            style: .alert,
            viewBuilder: { layout in
                let casted = unsafeBitCast(layout, to: (@Sendable () -> Void).self)
                
                return MainActor.assumeIsolated { 
                    viewBuilder(casted)
                }
            },
            didCloseHandler: { resolvedView, info in
                let response = NSApplication.ModalResponse(rawValue: info[ConfigurationViewPresentationModalResponseKey] as! Int)
                
                MainActor.assumeIsolated { 
                    didCloseHandler(resolvedView, response)
                }
            }
        )
        
        return ConfigurationViewPresentationDescription(impl: impl)
    }
}

extension ConfigurationViewPresentationDescription: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> __ConfigurationViewPresentationDescription {
        impl
    }
    
    public static func _forceBridgeFromObjectiveC(_ source: __ConfigurationViewPresentationDescription, result: inout ConfigurationViewPresentationDescription?) {
        result = ConfigurationViewPresentationDescription(impl: source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ source: __ConfigurationViewPresentationDescription, result: inout ConfigurationViewPresentationDescription?) -> Bool {
        result = ConfigurationViewPresentationDescription(impl: source)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: __ConfigurationViewPresentationDescription?) -> ConfigurationViewPresentationDescription {
        ConfigurationViewPresentationDescription(impl: source!)
    }
}
