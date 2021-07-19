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

    private var reachabilityManager: ReachabilityManager?
    private var appCoordinator: AppCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        YMKMapKit.setApiKey(Constants.apiKey)
        configureProgressHUD()
        configureKeyboardManager()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        configureAppCoordinator()
        appCoordinator?.start()

        reachabilityManager = ReachabilityManagerImpl.shared
        reachabilityManager?.start()

        return true
    }

    private func configureAppCoordinator() {
        let serviceComponents = ServiceComponentsAssembly()
        let repositoryComponents = RepositoryComponentsAssembly(serviceComponents: serviceComponents)
        appCoordinator = AppCoordinator(serviceComponents: serviceComponents,
                                        repositoryComponents: repositoryComponents,
                                        appCoordinatorsFactory: ApplicationCoordinatorFactoryImpl(builder: AppCoordinatorsModulesBuilderImpl(routersFactory: RoutersFactoryImpl())),
                                        pagesFactory: ApplicationPagesFactoryImpl(repositoryComponents: repositoryComponents))
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
