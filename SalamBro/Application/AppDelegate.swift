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

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // if you don't have TMDB-Info.plist, just set your key in setApiKey()
        YMKMapKit.setApiKey(apiKey)
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: UpdateController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}
