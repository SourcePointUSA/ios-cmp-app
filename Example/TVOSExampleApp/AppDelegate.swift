//
//  AppDelegate.swift
//  TVOSExampleApp
//
//  Created by Andre Herculano on 21.05.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

// swiftlint:disable line_length

import ConsentViewController
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // MARK: - UISceneSession Lifecycle (tvOS 13+)

    @available(tvOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(tvOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Application Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if CommandLine.arguments.contains("-cleanAppsData") {
            SPConsentManager.clearAllData()
            SPConsentManager.shouldCallErrorMetrics = false
        }
        UserDefaults.standard.set(CommandLine.arguments.contains("-gdpr"), forKey: "app.campaigns.gdpr")
        UserDefaults.standard.set(CommandLine.arguments.contains("-ccpa"), forKey: "app.campaigns.ccpa")
        let language = CommandLine.arguments
            .first(where: { $0.starts(with: "-lang=")})?
            .replacingOccurrences(of: "-lang=", with: "")
        UserDefaults.standard.set(language, forKey: "app.lang")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}
