//
//  PromptComposeViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

import UIKit
import UIKitPrivate

@_expose(Cxx) public func initializePromptComposeViewController() {
    // swift_getSingletonMetadata
    _ = PromptComposeViewController.perform(Selector(("class")))
}

@_objcRuntimeName(PromptComposeViewController)
fileprivate final class PromptComposeViewController: UIKitPrivate.IntelligenceUI.PromptComposeViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
