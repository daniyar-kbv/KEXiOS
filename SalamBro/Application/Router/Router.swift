//
//  Router.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol Router {
    var didFinish: (() -> Void)? { get }
    func set(navigationController: SBNavigationController)
    func getNavigationController() -> SBNavigationController

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

    var navigationController: SBNavigationController! {
        didSet {
            totalNumberOfPages = navigationController.viewControllers.count
            initialNumberOfPages = totalNumberOfPages
        }
    }

    private var totalNumberOfPages: Int = 0
    private var initialNumberOfPages: Int = 0

    private lazy var didTapOnBack: (() -> Void) = { [weak self] in
        self?.pop(animated: true)
    }

    private let navigationLogic: NavigationLogic
    private let isRootRouter: Bool

    init(isRootRouter: Bool, navigationLogic: NavigationLogic) {
        self.isRootRouter = isRootRouter
        self.navigationLogic = navigationLogic
    }

    func set(navigationController: SBNavigationController) {
        self.navigationController = navigationController
        self.navigationController.addObserver(self)
    }

    func getNavigationController() -> SBNavigationController {
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
        totalNumberOfPages = navigationController.viewControllers.count
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

extension MainRouter: SBNavigationControllerDelegate {
    func sbNavigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController) {
        let willPush: Bool = totalNumberOfPages < navigationController.viewControllers.count

        if willPush {
            let configuration = navigationLogic.configure(viewController: viewController, in: navigationController)
            setConfiguration(configuration, for: viewController)
        }
    }

    func sbNavigationController(_ navigationController: UINavigationController, didShow _: UIViewController) {
        let didPop: Bool = totalNumberOfPages > navigationController.viewControllers.count

        let isNonChangeable = totalNumberOfPages == navigationController.viewControllers.count
        guard !isNonChangeable else { return }

        totalNumberOfPages = navigationController.viewControllers.count

        if didPop {
            let shouldCommitSuicide: Bool = totalNumberOfPages == initialNumberOfPages && !isRootRouter
            if shouldCommitSuicide {
                didFinish?()
            }
        }
    }

    private func setConfiguration(_ configuration: BarButtonConfiguration, for viewController: UIViewController) {
        switch configuration {
        case .withBackButton:
            viewController.setBackButton(completion: didTapOnBack)
            navigationController.interactivePopGestureRecognizer?.delegate = viewController as? UIGestureRecognizerDelegate
        case .none:
            viewController.navigationItem.rightBarButtonItem = nil
            viewController.navigationItem.leftBarButtonItem = nil
            viewController.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
}
