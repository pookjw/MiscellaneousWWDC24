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
        // 이걸로 만들면 수정이 안 되는건가?
        let descriptor = _UIIntelligenceLightSourceDescriptor
            .livingLight(
                with: _UIColorPalette(colors: [.cyan, .orange, .green, .red, .purple])
            )
        return descriptor._createLightSourceView(withFrame: .null) as! UIKitPrivate._UICloudChamber
    }()
    
    override func loadView() {
        view = cloudChamberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "gear"), primaryAction: nil, menu: makeMenu())
    }
    
    private func makeMenu() -> UIMenu {
        let element = UIDeferredMenuElement.uncached { [cloudChamberView] completion in
            let configuration = cloudChamberView.configuration
            
            let colorsMenu: UIMenu = {
                let addedColorActions = configuration
                    .colors
                    .map { color in
                        let image = UIImage(systemName: "circle.fill")!
                            .withTintColor(color, renderingMode: .alwaysOriginal)
                        
                        return UIAction(image: image) { _ in
                            var configuration = cloudChamberView.configuration
                            configuration.colors.removeAll { $0 == color}
                            cloudChamberView.configuration = configuration
                        }
                    }
                
                let menu = UIMenu(options: .displayAsPalette, children: addedColorActions)
                return menu
            }()
            
            completion([
                colorsMenu
            ])
        }
        
        return UIMenu(children: [element])
    }
}
