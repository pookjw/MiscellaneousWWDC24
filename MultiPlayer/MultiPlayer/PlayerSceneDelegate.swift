//
//  PlayerSceneDelegate.swift
//  MultiPlayer
//
//  Created by Jinwoo Kim on 7/4/24.
//

import UIKit
import AVKit
import UniformTypeIdentifiers

final class PlayerSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        MyContentSelectionViewController.shared.setup()
        
        let window: UIWindow = .init(windowScene: scene as! UIWindowScene)
        window.rootViewController = MyContentSelectionViewController.shared.playerViewControllers.first
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
