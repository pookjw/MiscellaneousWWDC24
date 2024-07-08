//
//  MyHSplitView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/8/24.
//

#if os(macOS)

import SwiftUI
import ObjectiveC

struct MyHSplitView: View {
    var body: some View {
        HSplitView { 
            Color.orange
//            Color.pink
            MyContentView()
        }
        .background { 
//            MyContentView()
        }
    }
}

fileprivate struct MyContentView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> MyContentViewController {
        .init()
    }
    
    func updateNSViewController(_ nsViewController: MyContentViewController, context: Context) {
        
    }
    
    final class MyContentViewController: NSViewController {
        // SwiftUI.SplitViewChildController 안에 있고 Parent View Controller가 nil이 나오길래 이렇게 처리
        @objc(_viewDidMoveToWindow:fromWindow:) func _viewDidMoveToWindow(_ newWindow: NSWindow?, fromWindow: NSWindow?) {
            let superMethod: Method = class_getInstanceMethod(superclass, #selector(_viewDidMoveToWindow(_:fromWindow:)))!
            let superIMP: IMP = method_getImplementation(superMethod)
            let castedSuperIMP = unsafeBitCast(superIMP, to: (@convention(c) (Any, Selector, NSWindow?, NSWindow?) -> Void).self)
            
            castedSuperIMP(self, #selector(_viewDidMoveToWindow(_:fromWindow:)), fromWindow, newWindow)
            
            //
            
            guard let superview: NSView = view.superview?.superview else {
                return
            }
            
            let viewControllerMethod: Method = class_getInstanceMethod(NSView.self, Selector(("_viewController")))!
            let viewControllerIMP: IMP = method_getImplementation(viewControllerMethod)
            let castedViewControllerIMP = unsafeBitCast(viewControllerIMP, to: (@convention(c) (Any, Selector) -> NSViewController?).self)
            
            guard let parentViewController: NSViewController = castedViewControllerIMP(superview, Selector(("_viewController")))
            else {
                return
            }
            
            guard let splitViewController: NSSplitViewController = parentViewController.parent as? NSSplitViewController
            else {
                return
            }
            
            splitViewController.splitView.dividerStyle = .paneSplitter
        }
    }
}

#Preview {
    MyHSplitView()
}

#endif
