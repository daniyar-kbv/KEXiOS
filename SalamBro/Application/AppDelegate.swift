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
        YMKMapKit.setApiKey(apiKey)
        configureProgressHUD()
        configureKeyboardManager()
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ChangeNameController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
//        configureAppCoordinator()
//        appCoordinator?.start()

        return true
    }

    private func configureAppCoordinator() {
        appCoordinator = AppCoordinator(serviceComponents: ServiceComponentsAssembly(),
                                        repositoryComponents: RepositoryComponentsAssembly(),
                                        appCoordinatorsFactory: ApplicationCoordinatorFactoryImpl(builder: AppCoordinatorsModulesBuilderImpl()))
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
