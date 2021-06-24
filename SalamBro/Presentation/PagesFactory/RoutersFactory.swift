//
//  RoutersFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import UIKit

final class TempNavigationLogic: NavigationLogic {
    func configure(viewController _: UIViewController, in navigationController: UINavigationController) -> BarButtonConfiguration {
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.navigationBar.shadowImage = .init()
        navigationController.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController.navigationBar.backgroundColor = .clear
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold),
        ]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        if navigationController.viewControllers.count > 1 {
            return .withBackButton
        }

        return .none
    }
}

protocol RoutersFactory: AnyObject {
    func makeMenuRouter() -> Router
    func makeProfileRouter() -> Router
    func makeSupportRouter() -> Router
    func makeCartRouter() -> Router
    func makeAuthRouter() -> Router
    func makeOnboardingRouter() -> Router
}

final class RoutersFactoryImpl: DependencyFactory, RoutersFactory {
    func makeMenuRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: TempNavigationLogic()))
    }

    func makeProfileRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: TempNavigationLogic()))
    }

    func makeSupportRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: TempNavigationLogic()))
    }

    func makeCartRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: TempNavigationLogic()))
    }

    func makeAuthRouter() -> Router {
        return scoped(MainRouter(isRootRouter: false, navigationLogic: TempNavigationLogic()))
    }

    func makeOnboardingRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: TempNavigationLogic()))
    }
}
