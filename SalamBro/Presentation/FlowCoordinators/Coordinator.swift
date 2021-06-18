//
//  Coordinator.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func didFinish()
}

protocol TabCoordinator: Coordinator {
    var childNavigationController: UINavigationController! { get set }
    var tabType: TabBarCoordinator.TabType { get set }
}

extension Coordinator {
    func addChild(_ child: Coordinator) {
        child.parentCoordinator = self
        childCoordinators.append(child)
    }

    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    /// Tech debt, don't use
    func alert(error: Error, closeHandler: (() -> Void)? = nil) {
        let alertHandler = AlertHandler()
        let context = AlertHandler.AlertType.error(message: error.localizedDescription, closeHandler: closeHandler)
        alertHandler.present(on: getLastPresentedViewController(), animated: true, alertType: context, completion: nil)
    }

    /// Tech debt, don't use
    func alert(title: String, message: String, closeHandler: (() -> Void)? = nil) {
        let alertHandler = AlertHandler()
        let context = AlertHandler.AlertType.default(title: title, message: message, closeHandler: closeHandler)
        alertHandler.present(on: getLastPresentedViewController(), animated: true, alertType: context, completion: nil)
    }

    /// Tech debt, don't use
    func getLastPresentedViewController() -> UIViewController {
        var parentVc: UIViewController = navigationController
        var childVc: UIViewController? = navigationController.presentedViewController
        while childVc != nil {
            parentVc = childVc!
            childVc = parentVc.presentedViewController
        }
        return parentVc
    }
}

extension TabCoordinator {
    /// Tech debt, don't use
    func templateNavigationController(title: String, image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        return nav
    }
}
