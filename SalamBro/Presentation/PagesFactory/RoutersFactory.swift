//
//  RoutersFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import UIKit

final class BaseNavigationLogic: NavigationLogic {
    func configure(viewController _: UIViewController, in navigationController: UINavigationController) -> BarButtonConfiguration {
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
        return scoped(MainRouter(isRootRouter: true, navigationLogic: BaseNavigationLogic()))
    }

    func makeProfileRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: BaseNavigationLogic()))
    }

    func makeSupportRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: BaseNavigationLogic()))
    }

    func makeCartRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: BaseNavigationLogic()))
    }

    func makeAuthRouter() -> Router {
        return scoped(MainRouter(isRootRouter: false, navigationLogic: BaseNavigationLogic()))
    }

    func makeOnboardingRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: BaseNavigationLogic()))
    }
}
