//
//  AppDelegate.swift
//  SalamBro
//
//  Created by Murager on 01.03.2021.
//

import IQKeyboardManagerSwift
import SVProgressHUD
import UIKit
import YandexMapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // if you don't have TMDB-Info.plist, just set your key in setApiKey()
        YMKMapKit.setApiKey(apiKey)
        configureProgressHUD()
        configureKeyboardManager()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        configureAppCoordinator()
        appCoordinator?.start()

//        Tech debt: remove when orders apply api stabilize
        DefaultStorageImpl.sharedStorage.persist(leadUUID: "ace65478-c4ba-4a78-84a8-26c49466244c")

        return true
    }

    private func configureAppCoordinator() {
        appCoordinator = AppCoordinator(serviceComponents: ServiceComponentsAssembly(),
                                        navigationController: UINavigationController(),
                                        locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                        brandRepository: DIResolver.resolve(BrandRepository.self)!)
    }

    private func configureProgressHUD() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setRingNoTextRadius(12)
        SVProgressHUD.setCornerRadius(4)
        SVProgressHUD.setBackgroundColor(.lightGray)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setRingThickness(2)
        SVProgressHUD.setForegroundColor(.kexRed)
    }

    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .kexRed
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
