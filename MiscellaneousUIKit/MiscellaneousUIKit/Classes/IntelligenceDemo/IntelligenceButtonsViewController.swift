//
//  IntelligenceButtonsViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

import UIKit
import UIKitPrivate

@objc
final class IntelligenceButtonsViewController: UIViewController {
    override func loadView() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "square.and.arrow.up.fill")
        configuration.buttonSize = .large
        
        let monochromaticButton = UIKitPrivate._UIIntelligenceButton()
        monochromaticButton.configuration = configuration
        monochromaticButton.style = .monochromatic
        monochromaticButton.addTarget(self, action: #selector(didTriggerButton(sender:)), for: .primaryActionTriggered)
        
        let staticMulticolorButton = UIKitPrivate._UIIntelligenceButton()
        staticMulticolorButton.configuration = configuration
        staticMulticolorButton.style = .staticMulticolor
        staticMulticolorButton.addTarget(self, action: #selector(didTriggerButton(sender:)), for: .primaryActionTriggered)
        
        let livingMulticolorButton = UIKitPrivate._UIIntelligenceButton()
        livingMulticolorButton.configuration = configuration
        livingMulticolorButton.style = .livingMulticolor
        livingMulticolorButton.addTarget(self, action: #selector(didTriggerButton(sender:)), for: .primaryActionTriggered)
        
        let monochromaticFillView = UIKitPrivate._UIIntelligenceButton.FillView(frame: .null, initialStyle: .monochromatic)
        let staticMulticolorFillView = UIKitPrivate._UIIntelligenceButton.FillView(frame: .null, initialStyle: .staticMulticolor)
        let livingMulticolorFillView = UIKitPrivate._UIIntelligenceButton.FillView(frame: .null, initialStyle: .livingMulticolor)
        
        let stackView = UIStackView(arrangedSubviews: [
            monochromaticButton,
            staticMulticolorButton,
            livingMulticolorButton,
            monochromaticFillView,
            staticMulticolorFillView,
            livingMulticolorFillView
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        view = stackView
    }
    
    @objc private func didTriggerButton(sender: UIKitPrivate._UIIntelligenceButton) {
        sender.setExpanded(!sender.isExpanded, animated: true)
    }
}
