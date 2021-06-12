//
//  CartCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

final class CartCoordinator: TabCoordinator {
    var parentCoordinator: LegacyCoordinator?
    var childCoordinators: [LegacyCoordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType

    private var authCoordinator: AuthCoordinator?

    init(navigationController: UINavigationController, tabType: TabBarCoordinator.TabType) {
        self.navigationController = navigationController
        self.tabType = tabType
    }

    func openAuth() {
        authCoordinator = AuthCoordinator(navigationController: childNavigationController, pagesFactory: AuthPagesFactoryImpl())
        authCoordinator?.start()

        authCoordinator?.didFinish = { [weak self] in
            self?.authCoordinator = nil
        }
    }

    func start() {
        let viewModel = CartViewModel(coordinator: self, cartRepository: CartRepositoryMockImpl())
        let vc = CartController(viewModel: viewModel)
        childNavigationController = templateNavigationController(title: tabType.title,
                                                                 image: tabType.image,
                                                                 rootViewController: vc)
    }

    func didFinish() {}
}
