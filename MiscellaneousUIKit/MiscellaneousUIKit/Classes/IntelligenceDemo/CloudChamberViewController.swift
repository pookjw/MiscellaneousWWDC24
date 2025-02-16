//
//  CloudChamberViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

import UIKit
import UIKitPrivate

@objc
final class CloudChamberViewController: UIViewController {
    private let cloudChamberView: UIKitPrivate._UICloudChamber = {
        let descriptor = _UIIntelligenceLightSourceDescriptor
            .livingLight(
                with: _UIColorPalette(colors: [.cyan, .orange])
            )
        return descriptor._createLightSourceView(withFrame: .null) as! UIKitPrivate._UICloudChamber
    }()
    
    override func loadView() {
        view = cloudChamberView
    }
}
