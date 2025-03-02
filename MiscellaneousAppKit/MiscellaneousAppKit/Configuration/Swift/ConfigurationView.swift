//
//  ConfigurationView.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/2/25.
//

import Cocoa
import ObjectiveC

@MainActor public protocol ConfigurationViewDelegate: AnyObject {
    func configurationView(_ configurationView: ConfigurationView, didTriggerActionWith itemModel: ConfigurationItemModel, newValue: Any?) -> Bool
    var shouldShowReloadButton: Bool { get }
    func didTriggerReloadButton(_ configurationView: ConfigurationView)
}

@MainActor fileprivate let delegateKey = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)

extension ConfigurationView {
    public weak var delegate: (any ConfigurationViewDelegate)? {
        get {
            _delegate.delegateImpl
        }
        set {
            _delegate.delegateImpl = newValue
            perform(Selector(("setDelegate:")), with: _delegate)
        }
    }
    
    private var _delegate: Delegate {
        if let result = objc_getAssociatedObject(self, delegateKey) as? Delegate {
            return result
        }
        
        let delegate = Delegate()
        objc_setAssociatedObject(self, delegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
//        perform(Selector(("setDelegate:")), with: _delegate)
        
        return delegate
    }
}

@MainActor
fileprivate final class Delegate: NSObject, __ConfigurationViewDelegate {
    nonisolated(unsafe) var shouldRespondReloadSelector = false
    weak var delegateImpl: ConfigurationViewDelegate? {
        didSet {
            shouldRespondReloadSelector = delegateImpl?.shouldShowReloadButton ?? false
        }
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        guard aSelector == #selector(didTriggerReloadButton(with:)) else {
            return super.responds(to: aSelector)
        }
        
        return shouldRespondReloadSelector
    }
    
    func configurationView(_ configurationView: ConfigurationView, didTriggerActionWith itemModel: __ConfigurationItemModel<AnyObject>, newValue: any NSCopying) -> Bool {
        guard let delegateImpl else {
            return false
        }
        
        let _newValue: Any?
        switch itemModel.type {
        case .button, .label:
            _newValue = nil
        case .colorWell:
            _newValue = newValue as? NSColor
        case .popUpButton:
            _newValue = newValue as? String
        case .slider, .stepper:
            _newValue = newValue as? Double
        case .switch:
            _newValue = newValue as? Bool
        case .viewPresentation:
            fatalError()
        @unknown default:
            fatalError()
        }
        
        return delegateImpl
            .configurationView(
                configurationView,
                didTriggerActionWith: itemModel as ConfigurationItemModel,
                newValue: _newValue
            )
    }
    
    func didTriggerReloadButton(with configurationView: ConfigurationView) {
        assert(shouldRespondReloadSelector)
        
        guard let delegateImpl else {
            return
        }
        
        delegateImpl.didTriggerReloadButton(configurationView)
    }
}

extension ConfigurationView {
    public var snapshot: NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel> {
        __snapshot as NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel>
    }
    
    public func apply(_ snapshot: NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel>, animatingDifferences: Bool) {
        __applySnapshot(
            snapshot as NSDiffableDataSourceSnapshotReference,
            animatingDifferences: animatingDifferences
        )
    }
}
