//
//  PromptComposeViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

import UIKit
import UIKitPrivate

@_expose(Cxx) public func promptComposeViewControllerClass() -> UnsafeMutableRawPointer {
    let result = UnsafeMutableRawPointer(bitPattern: Int(bitPattern: ObjectIdentifier(PromptComposeViewController.self))).unsafelyUnwrapped
    return result
}

//@_objc_non_lazy_realization
@_objcRuntimeName(PromptComposeViewController)
fileprivate final class PromptComposeViewController: UIKitPrivate.IntelligenceUI.PromptComposeViewController {
    override func promptEntryViewTextDidChange(_ entryView: IntelligenceUI.PromptEntryView) {
        super.promptEntryViewTextDidChange(entryView)
        print(#function + (entryView.textView.text ?? "nil"))
    }
    
    override func promptEntryViewDidSubmit(_ entryView: IntelligenceUI.PromptEntryView) {
        super.promptEntryViewDidSubmit(entryView)
        print(#function)
    }
    
    override func promptEntryViewShouldBeginEditing(_ entryView: IntelligenceUI.PromptEntryView) -> Bool {
        let result = super.promptEntryViewShouldBeginEditing(entryView)
        print(#function)
        return result
    }
}
