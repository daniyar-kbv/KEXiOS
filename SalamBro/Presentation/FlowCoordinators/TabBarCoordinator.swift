//
//  TabBarCooridinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

final class TabBarCoordinator: LegacyCoordinator {
    var parentCoordinator: LegacyCoordinator?
    var childCoordinators: [LegacyCoordinator] = []
    var navigationController: UINavigationController
    var tabTypes = TabType.allCases

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        for coordinator in childCoordinators {
            coordinator.start()
        }
    }

    func getCoordinators() -> [TabCoordinator] {
        guard let childCoordinators = childCoordinators as? [TabCoordinator] else { return [] }
        return childCoordinators
    }

    func getChildNavigationControllers() -> [UINavigationController] {
        return getCoordinators().map { $0.childNavigationController }
    }

    func didFinish() {}

    enum TabType: CaseIterable {
        case menu
        case profile
        case support
        case cart

        var title: String {
            switch self {
            case .menu:
                return L10n.MainTab.Menu.title
            case .profile:
                return L10n.MainTab.Profile.title
            case .support:
                return L10n.MainTab.Support.title
            case .cart:
                return L10n.MainTab.Cart.title
            }
        }

        var image: UIImage {
            switch self {
            case .menu:
                return Asset.menu.image
            case .profile:
                return Asset.profile.image
            case .support:
                return Asset.support.image
            case .cart:
                return Asset.cart.image
            }
        }
    }
}
