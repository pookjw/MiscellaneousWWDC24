//
//  IntelligenceLightViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/8/24.
//

import UIKit
import Darwin.POSIX.dlfcn

@objc(IntelligenceLightViewController)
final class IntelligenceLightViewController: UIViewController {
    override func loadView() {
        let handle = dlopen("/System/Library/Frameworks/SwiftUICore.framework/SwiftUICore", RTLD_NOW)!
        let symbol = dlsym(handle, "CoreViewMakeIntelligenceLightSourceView")!
        let casted = unsafeBitCast(symbol, to: (@convention(thin) () -> UIView).self)
        
        let sourceView = casted()
        self.view = sourceView
    }
}
