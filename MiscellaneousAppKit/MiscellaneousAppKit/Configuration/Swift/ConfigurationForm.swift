//
//  ConfigurationForm.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/3/25.
//

import SwiftUI

public struct ConfigurationForm: NSViewRepresentable {
    private let items: [any Item]
    
    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel> {
        var snapshot = NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel>()
        
        snapshot.appendSections([NSNull()])
        snapshot.appendItems(
            items.compactMap { $0._itemModel },
            toSection: NSNull()
        )
        
        return snapshot
    }
    
    public init(@DescriptorBuilder _ items: () -> [any Item]) {
        self.items = items()
    }
    
    public func makeNSView(context: Context) -> ConfigurationView {
        let view = ConfigurationView()
        view.delegate = context.coordinator
        view.apply(makeSnapshot(), animatingDifferences: true)
        return view
    }
    
    public func updateNSView(_ nsView: ConfigurationView, context: Context) {
        context.coordinator.items = items
        nsView.apply(makeSnapshot(), animatingDifferences: false)
        nsView.reloadPresentations()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(items: items)
    }
    
    public final class Coordinator: ConfigurationViewDelegate {
        fileprivate var items: [any Item]
        
        fileprivate init(items: [any Item]) {
            self.items = items
        }
        
        public func configurationView(_ configurationView: ConfigurationView, didTriggerActionWith itemModel: ConfigurationItemModel, newValue: Any?) -> Bool {
            let identifier = itemModel.identifier
            
            for item in items {
                if identifier == item._itemModel?.identifier {
                    item._didTriggerAction(newValue)
                    break
                }
            }
            
            let impl = itemModel as __ConfigurationItemModel
            return impl.type == .popUpButton
        }
        
        public var shouldShowReloadButton: Bool {
            false
        }
        
        public func didTriggerReloadButton(_ configurationView: ConfigurationView) {
            
        }
    }
}

extension ConfigurationForm {
    @resultBuilder struct DescriptorBuilder {
        public static func buildExpression<Content>(_ content: Content) -> Content where Content : Item {
            content
        }
        
        @available(*, unavailable, message: "this expression does not conform to 'Item'")
        public static func buildExpression(_ invalid: Any) -> some Item {
            fatalError()
        }
        
        public static func buildBlock<Content>(_ content: Content) -> Content where Content : Item {
            content
        }
        
        public static func buildBlock<each Content>(_ contents: repeat each Content) -> [any Item] where repeat each Content : Item {
            var resolved: [any Item] = []
            for item in repeat each contents {
                resolved.append(item)
            }
            return resolved
        }
        
        public static func buildIf<Content>(_ content: Content?) -> Content? where Content : Item {
            content
        }
        
        public static func buildEither<TrueItem, FalseItem>(first component: TrueItem) -> _ConditionalItem<TrueItem, FalseItem> where TrueItem : Item, FalseItem : Item {
            _ConditionalItem<TrueItem, FalseItem>(storage: .trueItem(component))
        }
        
        public static func buildEither<TrueItem, FalseItem>(second component: FalseItem) -> _ConditionalItem<TrueItem, FalseItem> where TrueItem : Item, FalseItem : Item {
            _ConditionalItem<TrueItem, FalseItem>(storage: .falseItem(component))
        }
        
        public static func buildLimitedAvailability<Content>(_ content: Content) -> AnyItem where Content : Item {
            AnyItem(erasing: content)
        }
    }
}

extension ConfigurationForm {
    @_typeEraser(AnyItem)
    public protocol Item {
        var _itemModel: ConfigurationItemModel? { get }
        var _didTriggerAction: ((Any?) -> Void) { get }
    }
    
    public struct AnyItem: Item {
        fileprivate let value: any Item
        
        public var _itemModel: ConfigurationItemModel? { value._itemModel }
        public var _didTriggerAction: (Any?) -> Void { value._didTriggerAction }
        
        public init<T: Item>(erasing value: T) {
            self.value = value
        }
    }
    
    public struct EmptyItem: Item {
        public var _itemModel: ConfigurationItemModel? { nil }
        public var _didTriggerAction: (Any?) -> Void { { _ in } }
        
        public init() {}
    }
    
    public struct _ConditionalItem<TrueItem: Item, FalseItem: Item>: Item {
        public var _itemModel: ConfigurationItemModel? { storage.item._itemModel }
        public var _didTriggerAction: (Any?) -> Void { storage.item._didTriggerAction }
        
        public enum Storage {
            case trueItem(TrueItem)
            case falseItem(FalseItem)
            
            fileprivate var item: any Item {
                switch self {
                case .trueItem(let trueItem):
                    return trueItem
                case .falseItem(let falseItem):
                    return falseItem
                }
            }
        }
        
        private let storage: Storage
        
        fileprivate init(storage: Storage) {
            self.storage = storage
        }
    }
}

extension Swift.Never: ConfigurationForm.Item {
    public var _itemModel: ConfigurationItemModel? {
        nil
    }
    
    public var _didTriggerAction: (Any?) -> Void {
        { _ in }
    }
}

extension Swift.Optional : ConfigurationForm.Item where Wrapped : ConfigurationForm.Item {
    public var _itemModel: ConfigurationItemModel? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return wrapped._itemModel
        }
    }
    
    public var _didTriggerAction: (Any?) -> Void {
        switch self {
        case .none:
            return { _ in }
        case .some(let wrapped):
            return wrapped._didTriggerAction
        }
    }
}

extension ConfigurationForm {
    public struct LabelItem: Item {
        public let _itemModel: ConfigurationItemModel?
        public let _didTriggerAction: (Any?) -> Void
        
        public init(
            identifier: String,
            title: String
        ) {
            self.init(
                itemModel: ConfigurationItemModel.labelItem(identifier: identifier, label: title),
                didTriggerAction: { _ in }
            )
        }
        
        private init(itemModel: ConfigurationItemModel, didTriggerAction: @escaping (Any?) -> Void) {
            _itemModel = itemModel
            _didTriggerAction = didTriggerAction
        }
    }
}

extension ConfigurationForm {
    public struct ColorWellItem: Item {
        public let _itemModel: ConfigurationItemModel?
        public let _didTriggerAction: (Any?) -> Void
        
        public init(
            identifier: String,
            title: String,
            color: Binding<NSColor>
        ) {
            _itemModel = ConfigurationItemModel
                .colorWellItem(
                    identifier: identifier,
                    label: title
                ) { _ in
                    color.wrappedValue
                }
            
            _didTriggerAction = { newColor in
                color.wrappedValue = newColor as! NSColor
            }
        }
    }
}

extension ConfigurationForm {
    public struct SwitchItem: Item {
        public let _itemModel: ConfigurationItemModel?
        public let _didTriggerAction: (Any?) -> Void
        
        public init(
            identifier: String,
            title: String,
            isOn: Binding<Bool>
        ) {
            _itemModel = ConfigurationItemModel
                .switchItem(
                    identifier: identifier,
                    label: title,
                    valueResolver: { _ in
                        isOn.wrappedValue    
                    }
                )
            
            _didTriggerAction = { newColor in
                isOn.wrappedValue = newColor as! Bool
            }
        }
    }
}
