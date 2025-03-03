//
//  ConfigurationPopUpButtonDescription.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Foundation

public struct ConfigurationPopUpButtonDescription {
    public enum Title: Equatable {
        case unselected(String)
        case selected(String)
        case primarySelected(String)
        
        fileprivate var string: String {
            switch self {
            case .unselected(let string):
                return string
            case .selected(let string):
                return string
            case .primarySelected(let string):
                return string
            }
        }
    }
    
    public var titles: [Title] {
        let titles = impl.titles
        let selectedTitles = impl.selectedTitles
        let selectedDisplayTitle = impl.selectedDisplayTitle
        
        return titles
            .map { string in
                if selectedTitles.contains(string) {
                    if selectedDisplayTitle == string {
                        return .primarySelected(string)
                    } else {
                        return .selected(string)
                    }
                } else {
                    return .unselected(string)
                }
            }
    }
    
    public var selectedDisplayTitle: String? {
        impl.selectedDisplayTitle
    }
    
    private let impl: __ConfigurationPopUpButtonDescription
    
    private init(impl: __ConfigurationPopUpButtonDescription) {
        self.impl = impl
    }
    
    public init(titles: [Title]) {
        var selectedStrings: [String] = []
        var primarySelectedString: String?
        
        let strings = [String](unsafeUninitializedCapacity: titles.count) { buffer, initializedCount in
            for (index, title) in titles.enumerated() {
                buffer.baseAddress.unsafelyUnwrapped.advanced(by: index).initialize(to: title.string)
                
                switch title {
                case .unselected(_):
                    break
                case .selected(let string):
                    selectedStrings.append(string)
                case .primarySelected(let string):
                    selectedStrings.append(string)
                    assert(primarySelectedString == nil)
                    primarySelectedString = string
                }
            }
            
            initializedCount = titles.count
        }
        
        impl = __ConfigurationPopUpButtonDescription(
            titles: strings,
            selectedTitles: selectedStrings,
            selectedDisplayTitle: primarySelectedString
        )
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

extension ConfigurationForm {
    public struct PopUpButtonItem: Item {
        public typealias MenuTitle = ConfigurationPopUpButtonDescription.Title
        
        public let _itemModel: ConfigurationItemModel?
        public let _didTriggerAction: (Any?) -> Void
        
        public init(
            identifier: String,
            title: String,
            menuTitles: [MenuTitle],
            action: @escaping ((String) -> Void)
        ) {
            self.init(
                itemModel: ConfigurationItemModel
                    .popUpButtonItem(
                        identifier: identifier,
                        label: title,
                        valueResolver: { _ in
                            ConfigurationPopUpButtonDescription(
                                titles: menuTitles
                            )
                        }
                    ),
                didTriggerAction: { newValue in
                    action(newValue as! String)
                }
            )
        }
        
        private init(itemModel: ConfigurationItemModel, didTriggerAction: @escaping (Any?) -> Void) {
            _itemModel = itemModel
            _didTriggerAction = didTriggerAction
        }
    }
}
