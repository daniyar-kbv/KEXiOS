//
//  TabBarCooridinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

final class TabBarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private var serviceComponents: ServiceComponents
    var navigationController: UINavigationController
    lazy var tabTypes: [TabType] = [.menu(serviceComponents: serviceComponents), .profile, .support, .cart]

    init(serviceComponents: ServiceComponents, navigationController: UINavigationController) {
        self.serviceComponents = serviceComponents
        self.navigationController = navigationController
    }

    func start() {
        childCoordinators = tabTypes.map { $0.coordinator }
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

    enum TabType: Equatable {
        case menu(serviceComponents: ServiceComponents)
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

        var coordinator: TabCoordinator {
            switch self {
            case let .menu(serviceComponents):
                return MenuCoordinator(serviceComponents: serviceComponents,
                                       pagesFactory: MenuPagesFactoryIml(serviceComponents: serviceComponents),
                                       navigationController: UINavigationController(),
                                       tabType: self)
            case .profile:
                return ProfileCoordinator(navigationController: UINavigationController(), tabType: self)
            case .support:
                return SupportCoordinator(navigationController: UINavigationController(), tabType: self)
            case .cart:
                return CartCoordinator(navigationController: UINavigationController(), tabType: self)
            }
        }
        
        static func == (lhs: TabBarCoordinator.TabType, rhs: TabBarCoordinator.TabType) -> Bool {
            return lhs.title == rhs.title
        }
    }
}
