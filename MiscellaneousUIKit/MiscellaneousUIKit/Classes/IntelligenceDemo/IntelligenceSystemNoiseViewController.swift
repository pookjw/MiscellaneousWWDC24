//
//  IntelligenceSystemNoiseViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

import UIKit
import UIKitPrivate

@objc
final class IntelligenceSystemNoiseViewController: UIViewController {
    private let sourceView = UIKitPrivate._UIIntelligenceSystemNoiseView(frame: .null, preferringAudioReactivity: true)
    
    override func loadView() {
        view = sourceView
    }
}
