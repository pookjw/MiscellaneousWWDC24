//
//  DefaultSceneDelegate.swift
//  MultiPlayer
//
//  Created by Jinwoo Kim on 7/5/24.
//

import UIKit

final class DefaultSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window: UIWindow = .init(windowScene: scene as! UIWindowScene)
        
        let rootViewController: UIViewController = .init()
        
        let activateSceneButton: UIButton = .init(primaryAction: UIWindowScene.ActivationAction.init({ action in
            return .init(userActivity: .init(activityType: "PlayerSceneDelegate"))
        }))
        
        rootViewController.view = activateSceneButton
        window.rootViewController = rootViewController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
