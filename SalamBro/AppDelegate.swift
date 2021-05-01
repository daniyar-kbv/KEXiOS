//
//  AppDelegate.swift
//  SalamBro
//
//  Created by Murager on 01.03.2021.
//

import UIKit
import YandexMapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // if you don't have TMDB-Info.plist, just set your key in setApiKey()
        YMKMapKit.setApiKey(apiKey)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: MainTabController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }

}

