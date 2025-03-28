//
//  ConfigurationViewPresentationDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/3/25.
//

import Cocoa
import SwiftUI

public struct ConfigurationViewPresentationDescription {
    private let impl: __ConfigurationViewPresentationDescription
    
    private init(impl: __ConfigurationViewPresentationDescription) {
        self.impl = impl
    }
    
    public static func popoverStyle(
        viewBuilder: @escaping (@MainActor (_ layout: @MainActor @escaping () -> Void, _ reloadingView: NSView?) -> NSView),
        didCloseHandler: @escaping (@MainActor (_ resolvedView: NSView, _ reason: NSPopover.CloseReason) -> Void)
    ) -> ConfigurationViewPresentationDescription {
        let impl = __ConfigurationViewPresentationDescription(
            style: .popover,
            viewBuilder: { layout, reloadingView in
                let casted = unsafeBitCast(layout, to: (@Sendable () -> Void).self)
                
                return MainActor.assumeIsolated {
                    viewBuilder(casted, reloadingView)
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
        viewBuilder: @escaping (@MainActor (_ layout: @MainActor @escaping () -> Void, _ reloadingView: NSView?) -> NSView),
        didCloseHandler: @escaping (@MainActor (_ resolvedView: NSView, _ response: NSApplication.ModalResponse) -> Void)
    ) -> ConfigurationViewPresentationDescription {
        let impl = __ConfigurationViewPresentationDescription(
            style: .alert,
            viewBuilder: { layout, reloadingView in
                let casted = unsafeBitCast(layout, to: (@Sendable () -> Void).self)
                
                return MainActor.assumeIsolated { 
                    viewBuilder(casted, reloadingView)
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

extension ConfigurationForm {
    public struct ViewPresentationItem: Item {
        public let _itemModel: ConfigurationItemModel?
        public let _didTriggerAction: (Any?) -> Void
        
        public static func popoverStyle<T: View>(
            identifier: String,
            title: String,
            @ViewBuilder viewBuilder: @escaping (@MainActor () -> T),
            didCloseHandler: @escaping (@MainActor (_ response: NSPopover.CloseReason) -> Void)
        ) -> ViewPresentationItem {
            self.init(
                itemModel: ConfigurationItemModel
                    .viewPresentationItem(
                        identifier: identifier,
                        label: title,
                        valueResolver: { _ in
                                .popoverStyle(
                                    viewBuilder: { layout, reloadingView in
                                        ViewPresentationItem.sizableHostingView(viewBuilder: viewBuilder, layout: layout, reloadingView: reloadingView)
                                    },
                                    didCloseHandler: { _, reason in
                                        didCloseHandler(reason)
                                    }
                                )
                        }
                    ),
                didTriggerAction: { _ in }
            )
        }
        
        public static func alertStyle<T: View>(
            identifier: String,
            title: String,
            @ViewBuilder viewBuilder: @escaping (@MainActor () -> T),
            didCloseHandler: @escaping (@MainActor (_ response: NSApplication.ModalResponse) -> Void)
        ) -> ViewPresentationItem {
            self.init(
                itemModel: ConfigurationItemModel
                    .viewPresentationItem(
                        identifier: identifier,
                        label: title,
                        valueResolver: { _ in
                                .alertStyle(
                                    viewBuilder: { layout, reloadingView in
                                        ViewPresentationItem.sizableHostingView(viewBuilder: viewBuilder, layout: layout, reloadingView: reloadingView)
                                    },
                                    didCloseHandler: { _, reason in
                                        didCloseHandler(reason)
                                    }
                                )
                        }
                    ),
                didTriggerAction: { _ in }
            )
        }
        
        @MainActor private static func sizableHostingView<T: View>(
            @ViewBuilder viewBuilder: @escaping (@MainActor () -> T),
            layout: @escaping () -> Void,
            reloadingView: NSView?
        ) -> NSView {
            let hostingView = (reloadingView as? NSHostingView<AnyView>) ?? NSHostingView(rootView: AnyView(erasing: EmptyView()))
            
            let rootView = PresentationContentView(viewBuilder: viewBuilder)
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { [weak hostingView] oldValue, newValue in
                    guard let hostingView else { return }
                    hostingView.setFrameSize(newValue)
                    layout()
                }
            
            hostingView.rootView = AnyView(erasing: rootView)
            hostingView.frame = NSRect(origin: .zero, size: hostingView.intrinsicContentSize)
            
            return hostingView
        }
        
        private init(itemModel: ConfigurationItemModel, didTriggerAction: @escaping (Any?) -> Void) {
            _itemModel = itemModel
            _didTriggerAction = didTriggerAction
        }
    }
    
    fileprivate struct PresentationContentView<T: View>: View {
        @ViewBuilder private let viewBuilder: (@MainActor () -> T)
        
        init(@ViewBuilder viewBuilder: @MainActor @escaping () -> T) {
            self.viewBuilder = viewBuilder
        }
        
        var body: some View {
            viewBuilder()
        }
    }
}
