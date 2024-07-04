//
//  AppDelegate.swift
//  MultiPlayer
//
//  Created by Jinwoo Kim on 7/4/24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration: UISceneConfiguration = connectingSceneSession.configuration.copy() as! UISceneConfiguration
        
        if options.userActivities.first?.activityType == "PlayerSceneDelegate" {
            configuration.delegateClass = PlayerSceneDelegate.self
        } else {
            configuration.delegateClass = DefaultSceneDelegate.self
        }
        
        return configuration
    }
}
