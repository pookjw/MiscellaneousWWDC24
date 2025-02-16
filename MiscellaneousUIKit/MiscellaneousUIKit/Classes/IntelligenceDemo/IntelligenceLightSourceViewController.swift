//
//  IntelligenceLightSourceViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

import UIKit
import UIKitPrivate

@objc
final class IntelligenceLightSourceViewController: UIViewController {
    private let sourceView = UIKitPrivate._UIIntelligenceLightSourceView(frame: .null, preferAudioReactivity: true)
    
    override func loadView() {
        view = sourceView
    }
}
