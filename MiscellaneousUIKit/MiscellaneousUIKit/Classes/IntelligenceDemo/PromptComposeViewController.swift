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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "gear"), primaryAction: nil, menu: makeMenu())
    }
    
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
    
    private func makeMenu() -> UIMenu {
        let backgroundView = promptComposeView.entryView.backgroundView
        
        let defaultAction = UIAction(title: "Default") { _ in
            backgroundView.configuration = .default
            print(backgroundView.inputView)
        }
        
        let standardAction = UIAction(title: "Standard") { _ in
            backgroundView.configuration = .standard
        }
        
        let intelligentAction = UIAction(title: "Intelligent") { _ in
            backgroundView.configuration = .intelligent
        }
        
        let intelligentLatencyAction = UIAction(title: "Intelligent Latency") { _ in
            backgroundView.configuration = .intelligentLatency
        }
        
        let intelligentWhenFocusedAction = UIAction(title: "Intelligent When Focused") { _ in
            backgroundView.configuration = .intelligentWhenFocused
        }
        
        return UIMenu(children: [defaultAction, standardAction, intelligentAction, intelligentLatencyAction, intelligentWhenFocusedAction])
    }
}
