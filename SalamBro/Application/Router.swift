//
//  Router.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol Router {
    var didFinish: (() -> Void)? { get }
    func set(navigationController: UINavigationController)
    func getNavigationController() -> UINavigationController

    func push(viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRootViewController(animated: Bool)
    func pop(to viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func show(_ viewController: UIViewController)
}

final class MainRouter: Router {
    var didFinish: (() -> Void)?

    private var navigationController = UINavigationController()

    func set(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func getNavigationController() -> UINavigationController {
        return navigationController
    }

    func push(viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }

    func pop(to viewController: UIViewController, animated: Bool) {
        navigationController.popToViewController(viewController, animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
        didFinish?()
    }

    func dismiss(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.dismiss(animated: animated, completion: completion)
    }

    func show(_ viewController: UIViewController) {
        navigationController.show(viewController, sender: nil)
    }
}
