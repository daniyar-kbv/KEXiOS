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
        let nav = QFNavigationController(rootViewController: CountriesListController(viewModel: CountriesListViewModel(repository: DIResolver.resolve(GeoRepository.self)!)))
//        let nav = UINavigationController(rootViewController: CountriesListController(viewModel: CountriesListViewModel(repository: DIResolver.resolve(GeoRepository.self)!)))
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}
