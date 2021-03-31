//
//  AppDelegate.swift
//  SalamBro
//
//  Created by Murager on 01.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: MainTabController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }

}

