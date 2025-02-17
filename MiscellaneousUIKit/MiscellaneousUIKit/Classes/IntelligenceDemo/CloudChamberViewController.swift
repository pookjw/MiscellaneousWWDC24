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
        // configuration은 수정할 수 없는 구조같음. UIKit._UICloudChamber.init(frame: __C.CGRect, configuration: UIKit._UICloudChamber.Configuration) -> UIKit._UICloudChamber에서만 CAEmitterLayer가 구성되는 원리
        view = cloudChamberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
